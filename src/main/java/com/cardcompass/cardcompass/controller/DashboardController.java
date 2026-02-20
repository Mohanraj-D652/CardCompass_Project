package com.cardcompass.cardcompass.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;

@Controller
public class DashboardController {

    // Handles both /dashboard and /Dashboard.jsp links
    @GetMapping({"/dashboard", "/Dashboard.jsp"})
    public String dashboard(HttpSession session) {
        if (session.getAttribute("userId") == null) return "redirect:/LoginPage.jsp";
        return "Dashboard";
    }
}