package com.cardcompass.cardcompass.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.util.List;
import java.util.Map;

@Controller
public class TransactionController {

    @Autowired
    private JdbcTemplate jdbc;

    // ── Add Transaction page ──────────────────────────────────────
    @GetMapping({"/add-transaction", "/AddTransactions", "/AddTransactions.jsp"})
    public String addTransactionPage(HttpSession session, Model model) {
        if (session.getAttribute("userId") == null) return "redirect:/LoginPage.jsp";
        int userId = (int) session.getAttribute("userId");

        List<Map<String, Object>> cards = jdbc.queryForList(
                "SELECT card_id, card_name, card_last4 FROM credit_cards WHERE user_id = ?",
                userId);

        List<Map<String, Object>> categories = jdbc.queryForList(
                "SELECT * FROM categories ORDER BY category_name");

        model.addAttribute("cards",      cards);
        model.addAttribute("categories", categories);
        return "AddTransactions";
    }

    // ── Add Transaction submit (form action="AddTransactions") ────
    @PostMapping({"/add-transaction", "/AddTransactions"})
    public String saveTransaction(@RequestParam("card_id")     int    cardId,
                                  @RequestParam("category_id") int    categoryId,
                                  @RequestParam("amount")      double amount,
                                  @RequestParam("merchant")    String merchant,
                                  @RequestParam("tdate")       String tdate,
                                  HttpSession session) {

        if (session.getAttribute("userId") == null) return "redirect:/LoginPage.jsp";

        try {
            jdbc.update(
                    "INSERT INTO transactions (card_id, category_id, amount, merchant_name, transaction_date, entry_type) " +
                            "VALUES (?, ?, ?, ?, ?, ?)",
                    cardId, categoryId, amount, merchant.trim(), Date.valueOf(tdate), "MANUAL");
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/AddTransactions.jsp?msg=error";
        }

        return "redirect:/dashboard";
    }

    // ── Transaction History ───────────────────────────────────────
    @GetMapping({"/history", "/TransactionHistory", "/TransactionHistory.jsp"})
    public String history(HttpSession session, Model model) {
        if (session.getAttribute("userId") == null) return "redirect:/LoginPage.jsp";
        int userId = (int) session.getAttribute("userId");

        List<Map<String, Object>> transactions = jdbc.queryForList(
                "SELECT t.transaction_id, cat.category_name, t.amount, " +
                        "t.merchant_name, t.transaction_date, c.card_name, c.card_last4 " +
                        "FROM transactions t " +
                        "JOIN categories cat ON t.category_id = cat.category_id " +
                        "JOIN credit_cards c  ON t.card_id     = c.card_id " +
                        "WHERE c.user_id = ? " +
                        "ORDER BY t.transaction_date DESC, t.transaction_id DESC",
                userId);

        double totalSpent = transactions.stream()
                .mapToDouble(r -> ((Number) r.get("amount")).doubleValue())
                .sum();
        model.addAttribute("transactions", transactions);
        model.addAttribute("totalSpent",   totalSpent);
        return "TransactionHistory";
    }

    // ── Category-wise Spending ────────────────────────────────────
    @GetMapping({"/category-spend", "/CatagerywiseSpending", "/CatagerywiseSpending.jsp"})
    public String categorySpend(HttpSession session, Model model) {
        if (session.getAttribute("userId") == null) return "redirect:/LoginPage.jsp";
        int userId = (int) session.getAttribute("userId");

        List<Map<String, Object>> spending = jdbc.queryForList(
                "SELECT cat.category_name, SUM(t.amount) AS total_amount " +
                        "FROM transactions t " +
                        "JOIN categories cat ON t.category_id = cat.category_id " +
                        "JOIN credit_cards c  ON t.card_id     = c.card_id " +
                        "WHERE c.user_id = ? " +
                        "GROUP BY cat.category_id, cat.category_name",
                userId);

        double maxTotal = spending.stream()
                .mapToDouble(r -> ((Number) r.get("total_amount")).doubleValue())
                .max().orElse(0.0);

        model.addAttribute("spending",  spending);
        model.addAttribute("maxTotal",  maxTotal);
        return "CatagerywiseSpending";
    }

    // ── Card-wise Spending ────────────────────────────────────────
    @GetMapping({"/card-spend", "/CardWiseSpending", "/CardWiseSpending.jsp"})
    public String cardSpend(HttpSession session, Model model) {
        if (session.getAttribute("userId") == null) return "redirect:/LoginPage.jsp";
        int userId = (int) session.getAttribute("userId");

        List<Map<String, Object>> spending = jdbc.queryForList(
                "SELECT c.card_name, c.card_last4, SUM(t.amount) AS total " +
                        "FROM transactions t " +
                        "JOIN credit_cards c ON t.card_id = c.card_id " +
                        "WHERE c.user_id = ? " +
                        "GROUP BY c.card_id, c.card_name, c.card_last4",
                userId);

        double maxTotal = spending.stream()
                .mapToDouble(r -> ((Number) r.get("total")).doubleValue())
                .max().orElse(0.0);

        model.addAttribute("spending",  spending);
        model.addAttribute("maxTotal",  maxTotal);
        return "CardWiseSpending";
    }

    // ── View Reports page ─────────────────────────────────────────
    @GetMapping({"/reports", "/ViewReport", "/ViewReport.jsp"})
    public String reports(HttpSession session) {
        if (session.getAttribute("userId") == null) return "redirect:/LoginPage.jsp";
        return "ViewReport";
    }
}
