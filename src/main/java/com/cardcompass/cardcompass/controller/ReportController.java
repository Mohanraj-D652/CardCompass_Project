package com.cardcompass.cardcompass.controller;

import com.cardcompass.cardcompass.service.MonthlyReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Controller
public class ReportController {

    @Autowired
    private MonthlyReportService reportService;

    @GetMapping("/MonthlyReport")
    public void monthlyReport(HttpSession session,
                              HttpServletResponse response) throws Exception {

        if (session.getAttribute("userId") == null) {
            response.sendRedirect("/LoginPage.jsp");
            return;
        }

        int    userId   = (int)    session.getAttribute("userId");
        String userName = (String) session.getAttribute("userName");

        try {
            LocalDate today    = LocalDate.now();
            byte[]    pdfBytes = reportService.buildMonthlyPdf(userId, userName, today, false);

            String monthLabel = today.format(DateTimeFormatter.ofPattern("MMMM yyyy"));
            String filename   = "CardCompass_Report_" +
                    today.format(DateTimeFormatter.ofPattern("MMMM_yyyy")) + ".pdf";

            // 1. Stream PDF to browser for immediate download
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"" + filename + "\"");
            response.setContentLength(pdfBytes.length);
            response.getOutputStream().write(pdfBytes);
            response.getOutputStream().flush();

            // 2. Send email in background thread
            String emailAddress = reportService.getUserEmail(userId);
            new Thread(() -> {
                try {
                    reportService.sendReportEmail(emailAddress, userName, monthLabel, pdfBytes, filename);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }, "cardcompass-email-sender").start();

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println(
                    "<!DOCTYPE html><html><head><style>" +
                            "body{font-family:Outfit,sans-serif;padding:40px;background:#f1f5f9}" +
                            ".box{background:#fff;border-radius:14px;padding:32px;max-width:500px;" +
                            "margin:0 auto;border:1px solid #e2e8f0;box-shadow:0 4px 16px rgba(0,0,0,.08)}" +
                            "h2{color:#ef4444}a{color:#3b82f6;text-decoration:none;font-weight:600}" +
                            "</style></head><body>" +
                            "<div class='box'><h2>&#9888; Report Error</h2>" +
                            "<p style='color:#64748b'>" + e.getMessage() + "</p>" +
                            "<a href='/dashboard'>&#8592; Back to Dashboard</a>" +
                            "</div></body></html>");
        }
    }
}