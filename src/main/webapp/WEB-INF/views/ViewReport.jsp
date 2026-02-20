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
    <title>Reports – CardCompass</title>
    <%@ include file="common-style.jsp" %>

    <style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap');
:root{--navy:#0f172a;--blue:#3b82f6;--blue-dark:#2563eb;--green:#22c55e;--green-dk:#16a34a;--red:#ef4444;--amber:#f59e0b;--bg:#f1f5f9;--white:#ffffff;--border:#e2e8f0;--text:#0f172a;--muted:#64748b;--card-shadow:0 1px 3px rgba(15,23,42,.07),0 4px 16px rgba(15,23,42,.05);}
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
html,body{width:100%;overflow-x:hidden;}
body{font-family:'Outfit',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;-webkit-font-smoothing:antialiased;}
.app-header{width:100%;height:64px;background:var(--navy);display:flex;align-items:center;justify-content:space-between;padding:0 32px;position:sticky;top:0;z-index:1000;box-shadow:0 2px 16px rgba(15,23,42,.3);}
.app-brand{display:flex;align-items:center;gap:10px;text-decoration:none;}
.app-brand-icon{width:36px;height:36px;background:linear-gradient(135deg,var(--blue),var(--green));border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:18px;}
.app-brand-name{font-size:16px;font-weight:700;color:var(--white);letter-spacing:-0.3px;}
.app-nav{display:flex;align-items:center;gap:6px;}
.nav-link{padding:8px 14px;border-radius:8px;font-size:13.5px;font-weight:500;text-decoration:none;color:#94a3b8;transition:all .2s;border:1.5px solid transparent;white-space:nowrap;}
.nav-link:hover{color:var(--white);background:rgba(255,255,255,.08);}
.nav-link.active{color:var(--white);background:rgba(59,130,246,.25);border-color:rgba(59,130,246,.4);}
.nav-link.btn-green{background:var(--green);color:var(--white);border-color:var(--green);font-weight:600;}
.nav-link.btn-green:hover{background:var(--green-dk);transform:translateY(-1px);}
.nav-link.btn-logout{color:#f87171;}
.nav-link.btn-logout:hover{background:rgba(239,68,68,.15);}
.page-wrap{max-width:700px;margin:60px auto;padding:0 28px;}
.page-header{text-align:center;margin-bottom:36px;}
.report-icon{width:68px;height:68px;background:linear-gradient(135deg,var(--blue),#6366f1);border-radius:20px;margin:0 auto 20px;display:flex;align-items:center;justify-content:center;font-size:32px;box-shadow:0 8px 28px rgba(59,130,246,.3);}
.page-header h1{font-size:26px;font-weight:800;color:var(--navy);letter-spacing:-0.6px;margin-bottom:8px;}
.page-header p{font-size:14.5px;color:var(--muted);line-height:1.7;max-width:440px;margin:0 auto;}
/* REPORT CARDS */
.report-cards{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:16px;}
.report-card{display:flex;align-items:center;gap:16px;background:var(--white);border-radius:14px;border:1px solid var(--border);padding:20px 22px;text-decoration:none;transition:all .25s;box-shadow:var(--card-shadow);}
.report-card:hover{transform:translateY(-3px);box-shadow:0 10px 30px rgba(15,23,42,.14);border-color:var(--blue);}
.report-card-icon{width:48px;height:48px;border-radius:13px;display:flex;align-items:center;justify-content:center;font-size:22px;flex-shrink:0;}
.rc-blue{background:rgba(59,130,246,.12);}
.rc-green{background:rgba(34,197,94,.12);}
.rc-amber{background:rgba(245,158,11,.12);}
.rc-purple{background:rgba(99,102,241,.12);}
.report-card-text{flex:1;}
.report-card-title{font-size:14.5px;font-weight:700;color:var(--navy);margin-bottom:3px;}
.report-card-desc{font-size:12.5px;color:var(--muted);line-height:1.5;}
.report-card-arrow{font-size:18px;color:var(--muted);transition:transform .2s;}
.report-card:hover .report-card-arrow{transform:translateX(4px);color:var(--blue);}
.back-link{display:flex;align-items:center;justify-content:center;gap:8px;text-decoration:none;background:var(--white);color:var(--text);border:1.5px solid var(--border);padding:13px;border-radius:12px;font-size:14px;font-weight:600;transition:all .2s;box-shadow:var(--card-shadow);}
.back-link:hover{background:#f8fafc;border-color:#cbd5e1;}
@media(max-width:600px){.report-cards{grid-template-columns:1fr;}.page-wrap{margin:32px auto;}}
@media(max-width:768px){.app-header{padding:0 18px;height:auto;flex-wrap:wrap;gap:10px;padding-top:14px;padding-bottom:14px;}.app-nav{flex-wrap:wrap;justify-content:center;gap:6px;}.nav-link{padding:7px 11px;font-size:12.5px;}}
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
        <a href="TransactionHistory" class="nav-link">History</a>
        <a href="ViewReport"         class="nav-link active">Reports</a>
        <a href="AddTransactions"    class="nav-link btn-green">+ Add Transaction</a>
        <a href="Logout"                 class="nav-link btn-logout">Logout</a>
    </nav>
</header>

<div class="page-wrap">
    <div class="page-header">
        <div class="report-icon">📊</div>
        <h1>View Reports</h1>
        <p>Analyse your credit card spending. Explore category breakdowns, card-wise totals, and full transaction history.</p>
    </div>

    <div class="report-cards">
        <a href="CardWiseSpending" class="report-card">
            <div class="report-card-icon rc-blue">💳</div>
            <div class="report-card-text">
                <div class="report-card-title">Card Wise Spending</div>
                <div class="report-card-desc">Spending totals per card</div>
            </div>
            <div class="report-card-arrow">→</div>
        </a>
        <a href="CatagerywiseSpending" class="report-card">
            <div class="report-card-icon rc-green">📂</div>
            <div class="report-card-text">
                <div class="report-card-title">Category Spending</div>
                <div class="report-card-desc">Where you spend most</div>
            </div>
            <div class="report-card-arrow">→</div>
        </a>
        <a href="TransactionHistory" class="report-card">
            <div class="report-card-icon rc-amber">📋</div>
            <div class="report-card-text">
                <div class="report-card-title">Transaction History</div>
                <div class="report-card-desc">Full list of all transactions</div>
            </div>
            <div class="report-card-arrow">→</div>
        </a>
        <%-- MonthlyReport maps to Spring MVC @GetMapping("/MonthlyReport") --%>
        <a href="MonthlyReport" class="report-card">
            <div class="report-card-icon rc-purple">📧</div>
            <div class="report-card-text">
                <div class="report-card-title">Monthly PDF Report</div>
                <div class="report-card-desc">Send report to your email</div>
            </div>
            <div class="report-card-arrow">→</div>
        </a>
    </div>

    <a href="dashboard" class="back-link">← Back to Dashboard</a>
</div>
</body>
</html>
