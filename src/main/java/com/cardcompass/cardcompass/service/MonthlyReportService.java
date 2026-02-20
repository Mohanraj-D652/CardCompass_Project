package com.cardcompass.cardcompass.service;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;
import jakarta.mail.util.ByteArrayDataSource;
import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

/**
 * Replaces:
 *   MonthlyReportServlet.java  → buildMonthlyPdf() + sendReportEmail()
 *   MonthlyReportScheduler.java → @Scheduled replaces ScheduledExecutorService
 *   AppStartupListener.java    → NOT needed, Spring manages lifecycle
 *
 * PDF structure, fonts, table layout, email text — exactly the same.
 */
@Service
public class MonthlyReportService {

    @Autowired
    private JdbcTemplate jdbc;

    @Autowired
    private JavaMailSender mailSender;

    // Same email from MonthlyReportServlet.java SMTP_FROM
    @Value("${spring.mail.username}")
    private String smtpFrom;

    // ── Scheduler — runs every day at 23:30 ──────────────────────────────
    // Replaces MonthlyReportScheduler.java ScheduledExecutorService
    // AppStartupListener not needed — Spring starts/stops this automatically
    @Scheduled(cron = "0 30 23 * * *")
    public void runDailyCheck() {
        LocalDate today   = LocalDate.now();
        LocalDate lastDay = YearMonth.from(today).atEndOfMonth();

        System.out.println("[CardManager Scheduler] Daily check: " + today +
                " | Month-end: " + lastDay);

        // Exact same check as MonthlyReportScheduler.runDailyCheck()
        if (!today.equals(lastDay)) {
            System.out.println("[CardManager Scheduler] Not month-end — skipping.");
            return;
        }

        System.out.println("[CardManager Scheduler] MONTH-END! Sending reports...");
        sendToAllUsers(today);
    }

    // ── Send to all users — exact same as MonthlyReportScheduler.sendToAllUsers ──
    private void sendToAllUsers(LocalDate reportDate) {
        List<Map<String, Object>> users = jdbc.queryForList(
                "SELECT user_id, full_name, email FROM users");

        System.out.println("[CardManager Scheduler] Sending to " +
                users.size() + " user(s).");

        String monthLabel = reportDate.format(DateTimeFormatter.ofPattern("MMMM yyyy"));
        String filename   = "CardManager_Report_" +
                reportDate.format(DateTimeFormatter.ofPattern("MMMM_yyyy")) + ".pdf";

        for (Map<String, Object> user : users) {
            try {
                int    uid    = ((Number) user.get("user_id")).intValue();
                String uName  = (String) user.get("full_name");
                String uEmail = (String) user.get("email");

                // One failure doesn't stop others — same as your scheduler
                byte[] pdfBytes = buildMonthlyPdf(uid, uName, reportDate, true);
                sendReportEmail(uEmail, uName, monthLabel, pdfBytes, filename);

                System.out.println("[CardManager Scheduler] Sent to: " + uEmail);

            } catch (Exception e) {
                System.err.println("[CardManager Scheduler] Failed for user " +
                        user.get("user_id") + ": " + e.getMessage());
                e.printStackTrace();
            }
        }
        System.out.println("[CardManager Scheduler] Month-end send complete.");
    }

    // ── PDF Builder — exact copy of MonthlyReportServlet.buildMonthlyPdf ──
    public byte[] buildMonthlyPdf(int userId, String userName,
                                  LocalDate reportDate, boolean isAuto) throws Exception {

        String monthYear = reportDate.format(DateTimeFormatter.ofPattern("MMMM yyyy"));

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document doc = new Document(PageSize.A4.rotate());
        PdfWriter.getInstance(doc, baos);
        doc.open();

        // Exact same fonts as MonthlyReportServlet
        Font titleFont   = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
        Font labelFont   = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL);
        Font noteFont    = new Font(Font.FontFamily.HELVETICA,  9, Font.ITALIC,
                new BaseColor(120, 120, 120));
        Font headFont    = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD,
                BaseColor.WHITE);
        Font rowFont     = new Font(Font.FontFamily.HELVETICA, 10);
        Font totalFont   = new Font(Font.FontFamily.HELVETICA, 13, Font.BOLD);
        Font summaryFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL);

        // Exact same header as MonthlyReportServlet
        doc.add(new Paragraph("MONTHLY CREDIT CARD REPORT", titleFont));
        doc.add(new Paragraph("User  : " + userName, labelFont));
        doc.add(new Paragraph("Month : " + monthYear, labelFont));
        if (isAuto) {
            doc.add(new Paragraph(
                    "This report was auto-generated at month-end.", noteFont));
        }
        doc.add(new Paragraph(
                "Generated on : " + LocalDate.now()
                        .format(DateTimeFormatter.ofPattern("dd MMM yyyy")), noteFont));
        doc.add(new Paragraph(" "));

        // Exact same table as MonthlyReportServlet
        PdfPTable table = new PdfPTable(6);
        table.setWidthPercentage(100);
        table.setWidths(new int[]{2, 5, 4, 5, 3, 3});

        BaseColor navyBg = new BaseColor(15, 23, 42);
        String[] heads = {"#", "Card", "Category", "Merchant", "Amount (\u20b9)", "Date"};
        for (String h : heads) {
            PdfPCell cell = new PdfPCell(new Phrase(h, headFont));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setBackgroundColor(navyBg);
            cell.setPadding(7);
            table.addCell(cell);
        }

        // Exact same query as MonthlyReportServlet
        List<Map<String, Object>> rows = jdbc.queryForList(
                "SELECT t.transaction_id, c.card_name, c.card_last4, " +
                        "cat.category_name, t.merchant_name, t.amount, t.transaction_date " +
                        "FROM transactions t " +
                        "JOIN credit_cards c   ON t.card_id     = c.card_id " +
                        "JOIN categories  cat  ON t.category_id = cat.category_id " +
                        "WHERE c.user_id = ? " +
                        "AND MONTH(t.transaction_date) = ? " +
                        "AND YEAR(t.transaction_date)  = ? " +
                        "ORDER BY t.transaction_date ASC, t.transaction_id ASC",
                userId, reportDate.getMonthValue(), reportDate.getYear());

        BigDecimal total    = BigDecimal.ZERO;
        int        rowCount = 0;
        boolean    altRow   = false;

        // Exact same column alignment as MonthlyReportServlet
        int[] aligns = {
                Element.ALIGN_CENTER,
                Element.ALIGN_LEFT,
                Element.ALIGN_CENTER,
                Element.ALIGN_LEFT,
                Element.ALIGN_RIGHT,
                Element.ALIGN_CENTER
        };

        for (Map<String, Object> row : rows) {
            BigDecimal amount = BigDecimal.valueOf(
                            ((Number) row.get("amount")).doubleValue())
                    .setScale(2, RoundingMode.HALF_UP);

            String merchant = (String) row.get("merchant_name");
            BaseColor rowBg = altRow
                    ? new BaseColor(241, 245, 249)
                    : BaseColor.WHITE;
            altRow = !altRow;
            rowCount++;

            String[] cells = {
                    String.valueOf(rowCount),
                    row.get("card_name") + " (****" + row.get("card_last4") + ")",
                    (String) row.get("category_name"),
                    merchant != null ? merchant : "\u2014",
                    String.format("%.2f", amount),
                    row.get("transaction_date").toString()
            };

            for (int i = 0; i < cells.length; i++) {
                PdfPCell c = new PdfPCell(new Phrase(cells[i], rowFont));
                c.setHorizontalAlignment(aligns[i]);
                c.setBackgroundColor(rowBg);
                c.setBorderColor(new BaseColor(226, 232, 240));
                c.setPadding(5);
                table.addCell(c);
            }

            total = total.add(amount);
        }

        // Exact same empty row as MonthlyReportServlet
        if (rowCount == 0) {
            PdfPCell empty = new PdfPCell(
                    new Phrase("No transactions found for " + monthYear + ".", rowFont));
            empty.setColspan(6);
            empty.setHorizontalAlignment(Element.ALIGN_CENTER);
            empty.setPadding(14);
            table.addCell(empty);
        }

        doc.add(table);
        doc.add(new Paragraph(" "));

        // Exact same totals section as MonthlyReportServlet
        doc.add(new Paragraph(
                "TOTAL MONTHLY SPENDING :  \u20b9 " + String.format("%.2f", total),
                totalFont));

        if (rowCount > 0) {
            doc.add(new Paragraph(" "));
            BigDecimal avg = total.divide(
                    BigDecimal.valueOf(rowCount), 2, RoundingMode.HALF_UP);
            doc.add(new Paragraph(
                    "Total Transactions          : " + rowCount, summaryFont));
            doc.add(new Paragraph(
                    "Average per Transaction : \u20b9 " +
                            String.format("%.2f", avg), summaryFont));
        }

        doc.close();
        return baos.toByteArray();
    }

    // ── Email sender — exact same text as MonthlyReportServlet.sendReportEmail ──
    public void sendReportEmail(String toEmail, String toName,
                                String monthLabel, byte[] pdfBytes,
                                String filename) throws Exception {

        MimeMessage msg = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(msg, true, "UTF-8");

        helper.setFrom(smtpFrom, "CardManager");
        helper.setTo(toEmail);
        helper.setSubject("Your Monthly Spending Report \u2013 " + monthLabel);

        // Exact same email body as MonthlyReportServlet
        helper.setText(
                "Hi " + toName + ",\n\n" +
                        "Your credit card spending report for " + monthLabel + " is attached.\n\n" +
                        "You can also download it anytime from the CardManager dashboard " +
                        "by clicking \"Send PDF\".\n\n" +
                        "Best regards,\n" +
                        "CardManager", false);

        helper.addAttachment(filename,
                new ByteArrayDataSource(pdfBytes, "application/pdf"));

        mailSender.send(msg);
        System.out.println("[CardManager] Report emailed to: " + toEmail);
    }

    // ── Get user email from DB ────────────────────────────────────────────
    public String getUserEmail(int userId) {
        try {
            return jdbc.queryForObject(
                    "SELECT email FROM users WHERE user_id = ?",
                    String.class, userId);
        } catch (Exception e) {
            return null;
        }
    }
}