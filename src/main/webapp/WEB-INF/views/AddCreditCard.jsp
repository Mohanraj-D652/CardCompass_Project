<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Credit Card – CardCompass</title>
    <%@ include file="common-style.jsp" %>

    <style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap');
:root{--navy:#0f172a;--navy-2:#1e293b;--blue:#3b82f6;--blue-dark:#2563eb;--green:#22c55e;--green-dk:#16a34a;--red:#ef4444;--amber:#f59e0b;--bg:#f1f5f9;--white:#ffffff;--border:#e2e8f0;--text:#0f172a;--muted:#64748b;--muted-2:#94a3b8;--card-shadow:0 1px 3px rgba(15,23,42,.07),0 4px 16px rgba(15,23,42,.05);--hover-shadow:0 8px 28px rgba(15,23,42,.14);}
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
html,body{width:100%;overflow-x:hidden;}
body{font-family:'Outfit',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;-webkit-font-smoothing:antialiased;}
/* HEADER */
.app-header{width:100%;height:64px;background:var(--navy);display:flex;align-items:center;justify-content:space-between;padding:0 32px;position:sticky;top:0;z-index:1000;box-shadow:0 2px 16px rgba(15,23,42,.3);}
.app-brand{display:flex;align-items:center;gap:10px;text-decoration:none;}
.app-brand-icon{width:36px;height:36px;background:linear-gradient(135deg,var(--blue),var(--green));border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:18px;}
.app-brand-name{font-size:16px;font-weight:700;color:var(--white);letter-spacing:-0.3px;}
.app-nav{display:flex;align-items:center;gap:6px;}
.nav-link{padding:8px 14px;border-radius:8px;font-size:13.5px;font-weight:500;text-decoration:none;color:#94a3b8;transition:all .2s;border:1.5px solid transparent;white-space:nowrap;}
.nav-link:hover{color:var(--white);background:rgba(255,255,255,.08);}
.nav-link.btn-green{background:var(--green);color:var(--white);border-color:var(--green);font-weight:600;}
.nav-link.btn-green:hover{background:var(--green-dk);transform:translateY(-1px);}
.nav-link.btn-logout{color:#f87171;}
.nav-link.btn-logout:hover{background:rgba(239,68,68,.15);}
.nav-link.active{color:var(--white);background:rgba(59,130,246,.25);border-color:rgba(59,130,246,.4);}
/* LAYOUT */
.page-wrap{max-width:900px;margin:0 auto;padding:36px 28px;}
.page-header{margin-bottom:30px;}
.page-header h1{font-size:26px;font-weight:800;color:var(--navy);letter-spacing:-0.6px;margin-bottom:6px;}
.page-header p{font-size:14px;color:var(--muted);line-height:1.6;}
.layout-grid{display:grid;grid-template-columns:1fr 340px;gap:24px;align-items:start;}
/* CARD PREVIEW */
.cc-preview{background:linear-gradient(135deg,var(--navy) 0%,var(--navy-2) 50%,#0f2044 100%);border-radius:20px;padding:28px 26px;color:var(--white);position:relative;overflow:hidden;min-height:180px;box-shadow:0 10px 40px rgba(15,23,42,.35);}
.cc-preview::before{content:'';position:absolute;top:-40px;right:-40px;width:180px;height:180px;background:rgba(59,130,246,.15);border-radius:50%;}
.cc-preview::after{content:'';position:absolute;bottom:-50px;left:-20px;width:200px;height:200px;background:rgba(34,197,94,.08);border-radius:50%;}
.cc-chip{width:38px;height:28px;background:linear-gradient(135deg,#f0c040,#d4a010);border-radius:6px;margin-bottom:22px;}
.cc-name-display{font-size:15px;font-weight:700;margin-bottom:8px;letter-spacing:-0.2px;min-height:22px;color:rgba(255,255,255,.9);}
.cc-number-display{font-family:'Courier New',monospace;letter-spacing:3px;font-size:15px;color:rgba(255,255,255,.75);margin-bottom:20px;min-height:22px;}
.cc-footer{display:flex;justify-content:space-between;align-items:flex-end;}
.cc-label{font-size:10px;text-transform:uppercase;letter-spacing:.8px;color:rgba(255,255,255,.5);margin-bottom:4px;}
.cc-value{font-size:13px;font-weight:600;color:var(--white);min-height:19px;}
.cc-network{font-size:22px;opacity:.7;}
/* FORM CARD */
.form-card{background:var(--white);border-radius:16px;border:1px solid var(--border);padding:30px;box-shadow:var(--card-shadow);}
.form-card-title{font-size:16px;font-weight:700;color:var(--navy);margin-bottom:24px;padding-bottom:14px;border-bottom:1.5px solid var(--border);display:flex;align-items:center;gap:10px;}
.form-card-title-icon{width:32px;height:32px;background:rgba(59,130,246,.1);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:16px;}
label{display:block;margin-bottom:7px;color:var(--muted);font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.6px;}
input{width:100%;padding:13px 15px;margin-bottom:18px;border:1.5px solid var(--border);border-radius:10px;font-size:14px;font-family:'Outfit',sans-serif;background:#f8fafc;color:var(--text);transition:all .2s;outline:none;}
input:focus{border-color:var(--blue);background:var(--white);box-shadow:0 0 0 3px rgba(59,130,246,.12);}
.btn-submit{width:100%;padding:14px;background:var(--green);color:var(--white);border:none;border-radius:10px;font-size:15px;font-weight:700;cursor:pointer;transition:all .22s;box-shadow:0 2px 8px rgba(34,197,94,.3);font-family:'Outfit',sans-serif;}
.btn-submit:hover{background:var(--green-dk);transform:translateY(-1px);box-shadow:0 6px 20px rgba(34,197,94,.4);}
.btn-row{display:flex;gap:10px;margin-top:14px;}
.btn-ghost{flex:1;padding:11px;background:var(--white);color:var(--text);border:1.5px solid var(--border);border-radius:10px;text-align:center;text-decoration:none;font-size:13.5px;font-weight:600;transition:all .2s;font-family:'Outfit',sans-serif;}
.btn-ghost:hover{background:var(--bg);border-color:#cbd5e1;}
.info-box{margin-top:18px;padding:14px 16px;background:#eff6ff;border-left:4px solid var(--blue);border-radius:0 10px 10px 0;font-size:13px;color:#1e3a8a;line-height:1.7;}
/* success/error flash */
.alert-success{background:#f0fdf4;color:#166534;border:1px solid #bbf7d0;border-left:4px solid var(--green);border-radius:10px;padding:12px 16px;font-size:13.5px;margin-bottom:20px;}
.alert-error{background:#fef2f2;color:#7f1d1d;border:1px solid #fecaca;border-left:4px solid var(--red);border-radius:10px;padding:12px 16px;font-size:13.5px;margin-bottom:20px;}
@media(max-width:820px){.layout-grid{grid-template-columns:1fr;}.cc-preview{order:-1;max-width:380px;}}
@media(max-width:768px){.app-header{padding:0 18px;height:auto;flex-wrap:wrap;gap:10px;padding-top:14px;padding-bottom:14px;}.app-nav{flex-wrap:wrap;justify-content:center;gap:6px;}.nav-link{padding:7px 11px;font-size:12.5px;}.page-wrap{padding:16px 14px;}}
@media(max-width:480px){.app-brand-name{display:none;}.app-nav{width:100%;}.nav-link{flex:1;text-align:center;}}
    </style>
</head>
<body>

<header class="app-header">
    <a href="dashboard" class="app-brand">
        <div class="app-brand-icon">💳</div>
        <span class="app-brand-name">CardCompass</span>
    </a>
    <nav class="app-nav">
        <a href="dashboard"          class="nav-link">Dashboard</a>
        <a href="Mycards"            class="nav-link">My Cards</a>
        <a href="AddCreditCard"      class="nav-link active">Add Card</a>
        <a href="TransactionHistory" class="nav-link">History</a>
        <a href="AddTransactions"    class="nav-link btn-green">+ Add Transaction</a>
        <a href="Logout"                 class="nav-link btn-logout">Logout</a>
    </nav>
</header>

<div class="page-wrap">
    <div class="page-header">
        <h1>Add Credit Card</h1>
        <p>Save your credit card details to start tracking transactions.</p>
    </div>

    <%
        String flashMsg = request.getParameter("msg");
        if ("added".equals(flashMsg)) {
    %>
    <div class="alert-success">✅ Card added successfully!</div>
    <% } else if ("error".equals(flashMsg)) { %>
    <div class="alert-error">❌ Failed to add card. Please try again.</div>
    <% } %>

    <div class="layout-grid">
        <div class="form-card">
            <div class="form-card-title">
                <div class="form-card-title-icon">💳</div>
                Card Details
            </div>
            <%-- action maps to Spring MVC @PostMapping("/AddCreditCard") --%>
            <form action="AddCreditCard" method="post" onchange="updatePreview()">
                <label for="cardName">Card Name</label>
                <input type="text" id="cardName" name="CardName"
                       placeholder="e.g., HDFC Regalia, SBI SimplySave"
                       required oninput="updatePreview()">

                <label for="cardDigit">Card Last 4 Digits</label>
                <input type="number" id="cardDigit" name="CardDigit"
                       min="1000" max="9999"
                       placeholder="e.g., 4567"
                       title="Enter exactly 4 digits"
                       required oninput="updatePreview()">

                <label for="cardCvv">Card CVV</label>
                <input type="number" id="cardCvv" name="CardCvv"
                       min="100" max="9999"
                       placeholder="3-digit CVV" required>

                <label for="cardExpiry">Card Expiry (MM/YY)</label>
                <input type="text" id="cardExpiry" name="CardExpiry"
                       pattern="^(0[1-9]|1[0-2])/[0-9]{2}$"
                       placeholder="e.g., 12/25"
                       maxlength="5" required oninput="updatePreview()">

                <label for="cardLimit">Credit Limit (₹)</label>
                <input type="number" id="cardLimit" name="CardLimit"
                       placeholder="e.g., 100000" required>

                <button type="submit" class="btn-submit">💾 Save Card</button>
            </form>

            <div class="btn-row">
                <a href="Mycards" class="btn-ghost">View My Cards</a>
                <a href="dashboard" class="btn-ghost">← Dashboard</a>
            </div>

            <div class="info-box">
                🔒 Your card details are stored securely. We only save the last 4 digits of your card number for identification.
            </div>
        </div>

        <!-- Card Preview -->
        <div>
            <div style="font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:.7px;margin-bottom:12px;">Card Preview</div>
            <div class="cc-preview">
                <div class="cc-chip"></div>
                <div class="cc-name-display" id="previewName">Your Card Name</div>
                <div class="cc-number-display" id="previewNumber">XXXX &nbsp; XXXX &nbsp; XXXX &nbsp; ____</div>
                <div class="cc-footer">
                    <div>
                        <div class="cc-label">Expires</div>
                        <div class="cc-value" id="previewExpiry">MM/YY</div>
                    </div>
                    <div>
                        <div class="cc-label">Card Holder</div>
                        <div class="cc-value">YOU</div>
                    </div>
                    <div class="cc-network">💳</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
var expiryInput = document.getElementById('cardExpiry');
expiryInput.addEventListener('input', function(e) {
    var v = e.target.value.replace(/\D/g,'');
    if (v.length >= 2) v = v.substring(0,2) + '/' + v.substring(2,4);
    e.target.value = v;
    updatePreview();
});

function updatePreview() {
    var name   = document.getElementById('cardName').value || 'Your Card Name';
    var digits = document.getElementById('cardDigit').value || '____';
    var expiry = expiryInput.value || 'MM/YY';
    document.getElementById('previewName').textContent = name;
    document.getElementById('previewNumber').innerHTML = 'XXXX &nbsp; XXXX &nbsp; XXXX &nbsp; ' + String(digits).substring(0,4);
    document.getElementById('previewExpiry').textContent = expiry;
}
</script>
</body>
</html>
