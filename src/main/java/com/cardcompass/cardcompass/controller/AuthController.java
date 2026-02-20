package com.cardcompass.cardcompass.controller;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class AuthController {

    @Autowired
    private JdbcTemplate jdbc;

    // ── Landing page ──────────────────────────────────────────────
    @GetMapping({"/", "/index.jsp"})
    public String index() {
        return "index";
    }

    // ── Login page ────────────────────────────────────────────────
    @GetMapping({"/login", "/LoginPage", "/LoginPage.jsp"})
    public String loginPage() {
        return "LoginPage";
    }

    // ── Login submit (form action="LoginPage") ─────────────────────
    @PostMapping({"/login", "/LoginPage"})
    public String doLogin(@RequestParam("UserEmail")    String useremail,
                          @RequestParam("UserPassword") String userpassword,
                          HttpSession session) {
        try {
            List<Map<String, Object>> rows = jdbc.queryForList(
                    "SELECT * FROM users WHERE email = ?", useremail.trim());

            if (!rows.isEmpty()) {
                Map<String, Object> user = rows.get(0);
                String storedHash = (String) user.get("password");

                boolean ok;
                try {
                    // Try BCrypt first (new users)
                    ok = BCrypt.checkpw(userpassword, storedHash);
                } catch (Exception ex) {
                    // Fallback: plain-text compare (old users)
                    ok = userpassword.equals(storedHash);
                }

                if (ok) {
                    session.setAttribute("userId",    ((Number) user.get("user_id")).intValue());
                    session.setAttribute("userName",  (String) user.get("full_name"));
                    session.setAttribute("userEmail", (String) user.get("email"));
                    return "redirect:/dashboard";
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "redirect:/LoginPage.jsp?msg=invalid";
    }

    // ── Register page ─────────────────────────────────────────────
    @GetMapping({"/register", "/RegisterPage", "/RegisterPage.jsp"})
    public String registerPage() {
        return "RegisterPage";
    }

    // ── Register submit (form action="RegisterPage") ───────────────
    @PostMapping({"/register", "/RegisterPage"})
    public String doRegister(@RequestParam("UserName")     String username,
                             @RequestParam("UserEmail")    String useremail,
                             @RequestParam("UserPassword") String userpassword) {
        try {
            List<Map<String, Object>> existing = jdbc.queryForList(
                    "SELECT email FROM users WHERE email = ?", useremail.trim());

            if (!existing.isEmpty()) {
                return "redirect:/RegisterPage.jsp?msg=exists";
            }

            String hashedPassword = BCrypt.hashpw(userpassword, BCrypt.gensalt(12));

            int result = jdbc.update(
                    "INSERT INTO users(full_name, email, password) VALUES (?, ?, ?)",
                    username.trim(), useremail.trim(), hashedPassword);

            return result > 0
                    ? "redirect:/LoginPage.jsp?msg=registered"
                    : "redirect:/RegisterPage.jsp?msg=failed";

        } catch (Exception ex) {
            ex.printStackTrace();
            return "redirect:/RegisterPage.jsp?msg=failed";
        }
    }

    // ── Logout ────────────────────────────────────────────────────
    @GetMapping({"/logout", "/Logout"})
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/LoginPage.jsp?msg=loggedout";
    }
}