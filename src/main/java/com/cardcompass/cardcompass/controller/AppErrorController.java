package com.cardcompass.cardcompass.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Replaces the default Spring Boot "Whitelabel Error Page".
 * - 404  → redirect to home page
 * - 500  → redirect to home page
 * - any  → redirect to home page
 */
@Controller
public class AppErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {

        Object statusCode = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);

        if (statusCode != null) {
            int status = Integer.parseInt(statusCode.toString());

            // 404 — page not found → go home
            if (status == HttpStatus.NOT_FOUND.value()) {
                return "redirect:/";
            }

            // 500 — server error → go home
            if (status == HttpStatus.INTERNAL_SERVER_ERROR.value()) {
                return "redirect:/";
            }
        }

        // All other errors → go home
        return "redirect:/";
    }
}