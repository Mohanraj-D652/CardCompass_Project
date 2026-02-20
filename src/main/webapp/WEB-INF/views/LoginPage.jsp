<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – CardCompass</title>
    <%@ include file="common-style.jsp" %>

    <style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap');
:root{--navy:#0f172a;--navy-2:#1e293b;--blue:#3b82f6;--blue-dark:#2563eb;--green:#22c55e;--green-dk:#16a34a;--red:#ef4444;--bg:#f1f5f9;--white:#ffffff;--border:#e2e8f0;--text:#0f172a;--muted:#64748b;--muted-2:#94a3b8;}
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
body{font-family:'Outfit',sans-serif;min-height:100vh;background:linear-gradient(135deg,var(--navy) 0%,#0f2044 60%,#0a3055 100%);display:flex;justify-content:center;align-items:center;padding:20px;-webkit-font-smoothing:antialiased;position:relative;overflow:hidden;}
/* Background circles */
body::before{content:'';position:absolute;top:-100px;right:-100px;width:400px;height:400px;background:rgba(59,130,246,.08);border-radius:50%;}
body::after{content:'';position:absolute;bottom:-100px;left:-100px;width:350px;height:350px;background:rgba(34,197,94,.06);border-radius:50%;}
/* Card */
.login-card{background:var(--white);width:100%;max-width:420px;padding:44px 40px;border-radius:20px;box-shadow:0 20px 60px rgba(15,23,42,.35);position:relative;z-index:1;}
/* Brand */
.brand{text-align:center;margin-bottom:34px;}
.brand-icon{width:60px;height:60px;background:linear-gradient(135deg,var(--blue),var(--green));border-radius:16px;display:flex;align-items:center;justify-content:center;font-size:28px;margin:0 auto 14px;}
.brand h1{font-size:22px;font-weight:800;color:var(--navy);letter-spacing:-0.4px;}
.brand p{font-size:13.5px;color:var(--muted);margin-top:4px;}
/* Form */
h2{color:var(--navy);font-size:20px;font-weight:700;text-align:center;margin-bottom:26px;letter-spacing:-0.3px;}
.form-group{margin-bottom:18px;}
label{display:block;margin-bottom:7px;color:var(--muted);font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:0.6px;}
input[type="email"],input[type="password"],input[type="text"]{width:100%;padding:13px 15px;border:1.5px solid var(--border);border-radius:10px;font-size:14px;font-family:'Outfit',sans-serif;background:#f8fafc;color:var(--text);transition:all .2s;outline:none;}
input:focus{border-color:var(--blue);background:var(--white);box-shadow:0 0 0 3px rgba(59,130,246,.12);}
.pass-wrap{position:relative;}
.pass-wrap input{padding-right:48px;}
.eye-btn{position:absolute;right:14px;top:50%;transform:translateY(-50%);background:none;border:none;cursor:pointer;color:var(--muted-2);padding:4px;display:flex;align-items:center;transition:color .2s;}
.eye-btn:hover{color:var(--blue);}
.eye-btn svg{width:20px;height:20px;fill:none;stroke:currentColor;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;}
.btn-submit{width:100%;padding:14px;background:var(--blue);color:var(--white);border:none;border-radius:10px;font-size:15px;font-weight:700;cursor:pointer;transition:all .22s;box-shadow:0 2px 8px rgba(59,130,246,.3);font-family:'Outfit',sans-serif;margin-top:6px;letter-spacing:-0.2px;}
.btn-submit:hover{background:var(--blue-dark);transform:translateY(-1px);box-shadow:0 6px 20px rgba(59,130,246,.4);}
.footer-link{text-align:center;font-size:13.5px;color:var(--muted);margin-top:22px;}
.footer-link a{color:var(--blue);text-decoration:none;font-weight:600;}
.footer-link a:hover{text-decoration:underline;}
/* Messages */
.alert-success{background:#f0fdf4;color:#166534;border:1px solid #bbf7d0;border-left:4px solid var(--green);border-radius:10px;padding:12px 16px;font-size:13.5px;text-align:center;margin-bottom:20px;}
.alert-error{background:#fef2f2;color:#7f1d1d;border:1px solid #fecaca;border-left:4px solid var(--red);border-radius:10px;padding:12px 16px;font-size:13.5px;text-align:center;margin-bottom:20px;}
.divider{border:none;border-top:1.5px solid var(--border);margin:22px 0;}
/* Secure note */
.secure-note{text-align:center;font-size:12px;color:var(--muted-2);margin-top:14px;display:flex;align-items:center;justify-content:center;gap:5px;}
@media(max-width:480px){body{align-items:flex-start;padding-top:28px;}.login-card{padding:30px 22px;}}
    </style>
</head>
<body>

<div class="login-card">
    <div class="brand">
        <div class="brand-icon">💳</div>
        <h1>CardCompass</h1>
        <p>Track your credit card spending</p>
    </div>

    <%
        String msg = request.getParameter("msg");
        if ("invalid".equals(msg)) {
    %>
    <div class="alert-error">❌ Invalid email or password. Please try again.</div>
    <% } else if ("registered".equals(msg)) { %>
    <div class="alert-success">✅ Registration successful! Please login.</div>
    <% } else if ("loggedout".equals(msg)) { %>
    <div class="alert-success">✅ You have been logged out successfully.</div>
    <% } %>

    <%-- form action maps to Spring MVC @PostMapping("/LoginPage") --%>
    <form action="LoginPage" method="post">
        <h2>Welcome Back</h2>

        <div class="form-group">
            <label for="userEmail">Email Address</label>
            <input type="email" id="userEmail" name="UserEmail" placeholder="you@example.com" required>
        </div>

        <div class="form-group">
            <label for="loginPassword">Password</label>
            <div class="pass-wrap">
                <input type="password" name="UserPassword" id="loginPassword" placeholder="Enter your password" required>
                <button type="button" class="eye-btn" onclick="togglePass('loginPassword',this)" title="Show/hide password">
                    <svg id="eye-s" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                    <svg id="eye-h" viewBox="0 0 24 24" style="display:none"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                </button>
            </div>
        </div>

        <button type="submit" class="btn-submit">Sign In</button>
    </form>

    <hr class="divider">

    <div class="footer-link">
        Don't have an account? <a href="RegisterPage">Create one free</a>
    </div>

    <div class="secure-note">🔒 Your data is encrypted &amp; secure</div>
</div>

<script>
function togglePass(id, btn) {
    var inp = document.getElementById(id);
    var s = btn.querySelector('#eye-s'), h = btn.querySelector('#eye-h');
    if (inp.type === 'password') { inp.type = 'text'; s.style.display='none'; h.style.display='block'; }
    else { inp.type = 'password'; s.style.display='block'; h.style.display='none'; }
}
</script>
</body>
</html>
