package com.cardcompass.cardcompass.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class CardController {

    @Autowired
    private JdbcTemplate jdbc;

    // ── Add Card page ─────────────────────────────────────────────
    @GetMapping({"/add-card", "/AddCreditCard", "/AddCreditCard.jsp"})
    public String addCardPage(HttpSession session) {
        if (session.getAttribute("userId") == null) return "redirect:/LoginPage.jsp";
        return "AddCreditCard";
    }

    // ── Add Card submit (form action="AddCreditCard") ──────────────
    @PostMapping({"/add-card", "/AddCreditCard"})
    public String saveCard(@RequestParam("CardName")   String cardName,
                           @RequestParam("CardDigit")  String cardDigit,
                           @RequestParam("CardCvv")    String cardCvv,
                           @RequestParam("CardExpiry") String cardExpiry,
                           @RequestParam("CardLimit")  String cardLimit,
                           HttpSession session) {

        if (session.getAttribute("userId") == null) return "redirect:/LoginPage.jsp";
        int userId = (int) session.getAttribute("userId");

        try {
            if (cardExpiry == null || cardExpiry.trim().isEmpty()) {
                cardExpiry = "12/25";
            }

            int result = jdbc.update(
                    "INSERT INTO credit_cards(user_id, card_name, card_last4, Card_CVV, Expiry_date, credit_limit) " +
                            "VALUES (?, ?, ?, ?, ?, ?)",
                    userId,
                    cardName.trim(),
                    Integer.parseInt(cardDigit.trim()),
                    Integer.parseInt(cardCvv.trim()),
                    cardExpiry.trim(),
                    Integer.parseInt(cardLimit.trim())
            );

            return result > 0
                    ? "redirect:/my-cards?msg=added"
                    : "redirect:/AddCreditCard.jsp?msg=failed";

        } catch (Exception ex) {
            ex.printStackTrace();
            return "redirect:/AddCreditCard.jsp?msg=failed";
        }
    }

    // ── My Cards page ─────────────────────────────────────────────
    @GetMapping({"/my-cards", "/Mycards", "/Mycards.jsp"})
    public String myCards(HttpSession session, Model model) {
        if (session.getAttribute("userId") == null) return "redirect:/LoginPage.jsp";
        int userId = (int) session.getAttribute("userId");

        List<Map<String, Object>> cards = jdbc.queryForList(
                "SELECT card_id, card_name, card_last4 FROM credit_cards WHERE user_id = ?",
                userId);

        model.addAttribute("cards", cards);
        return "Mycards";
    }

    // ── Delete Card (form action="DeleteCard") ─────────────────────
    @PostMapping({"/delete-card", "/DeleteCard"})
    public String deleteCard(@RequestParam("cardId") int cardId,
                             HttpSession session) {

        if (session.getAttribute("userId") == null) return "redirect:/LoginPage.jsp";
        int userId = (int) session.getAttribute("userId");

        try {
            // Delete transactions first to avoid FK constraint error
            jdbc.update("DELETE FROM transactions WHERE card_id = ?", cardId);
            jdbc.update("DELETE FROM credit_cards WHERE card_id = ? AND user_id = ?",
                    cardId, userId);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return "redirect:/Mycards.jsp?msg=deleted";
    }
}