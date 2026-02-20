<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
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
    <title>My Cards – CardCompass</title>
    <%@ include file="common-style.jsp" %>

    <style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap');
:root{--navy:#0f172a;--navy-2:#1e293b;--blue:#3b82f6;--blue-dark:#2563eb;--green:#22c55e;--green-dk:#16a34a;--red:#ef4444;--red-dk:#dc2626;--amber:#f59e0b;--bg:#f1f5f9;--white:#ffffff;--border:#e2e8f0;--text:#0f172a;--muted:#64748b;--muted-2:#94a3b8;--card-shadow:0 1px 3px rgba(15,23,42,.07),0 4px 16px rgba(15,23,42,.05);--hover-shadow:0 8px 28px rgba(15,23,42,.14);}
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
.page-wrap{max-width:1200px;margin:0 auto;padding:32px 28px;}
.page-header{display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:16px;margin-bottom:28px;}
.page-header h1{font-size:26px;font-weight:800;color:var(--navy);letter-spacing:-0.6px;margin-bottom:6px;}
.page-header p{font-size:14px;color:var(--muted);}
/* CARDS GRID */
.cards-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:20px;}
/* CC VISUAL */
.cc-card{background:linear-gradient(135deg,var(--navy) 0%,var(--navy-2) 50%,#0f2044 100%);border-radius:18px 18px 0 0;padding:26px 24px;color:var(--white);position:relative;overflow:hidden;box-shadow:0 8px 32px rgba(15,23,42,.28);transition:all .25s;}
.card-wrapper:hover .cc-card{box-shadow:0 16px 48px rgba(15,23,42,.35);}
.cc-card::before{content:'';position:absolute;top:-40px;right:-40px;width:180px;height:180px;background:rgba(59,130,246,.12);border-radius:50%;}
.cc-card::after{content:'';position:absolute;bottom:-50px;left:-20px;width:180px;height:180px;background:rgba(34,197,94,.07);border-radius:50%;}
.cc-card.card-blue::before{background:rgba(59,130,246,.18);}
.cc-card.card-green::before{background:rgba(34,197,94,.18);}
.cc-card.card-amber::before{background:rgba(245,158,11,.18);}
.cc-card.card-purple::before{background:rgba(168,85,247,.18);}
.cc-chip{width:38px;height:28px;background:linear-gradient(135deg,#f0c040,#d4a010);border-radius:7px;margin-bottom:22px;}
.cc-name{font-size:15px;font-weight:700;margin-bottom:8px;letter-spacing:-0.2px;}
.cc-number{font-family:'Courier New',monospace;letter-spacing:3px;font-size:14.5px;color:rgba(255,255,255,.75);margin-bottom:22px;}
.cc-footer{display:flex;justify-content:space-between;align-items:flex-end;padding-top:16px;border-top:1px solid rgba(255,255,255,.15);}
.cc-meta-label{font-size:10px;text-transform:uppercase;letter-spacing:.8px;color:rgba(255,255,255,.5);margin-bottom:3px;}
.cc-meta-value{font-size:12.5px;font-weight:600;color:var(--white);}
.cc-status{display:inline-flex;align-items:center;gap:5px;padding:3px 10px;background:rgba(34,197,94,.2);border:1px solid rgba(34,197,94,.35);border-radius:20px;font-size:11.5px;font-weight:600;color:#86efac;}
/* ACTION STRIP */
.card-wrapper{border-radius:18px;overflow:hidden;transition:transform .25s;}
.card-wrapper:hover{transform:translateY(-4px);}
.card-action-strip{background:var(--white);border:1px solid var(--border);border-top:none;border-radius:0 0 18px 18px;padding:14px 20px;display:flex;gap:10px;align-items:center;justify-content:space-between;box-shadow:var(--card-shadow);}
.btn-delete{background:transparent;color:var(--red);border:1.5px solid rgba(239,68,68,.3);padding:8px 16px;border-radius:8px;cursor:pointer;font-size:13px;font-weight:600;transition:all .2s;font-family:'Outfit',sans-serif;display:flex;align-items:center;gap:6px;}
.btn-delete:hover{background:var(--red);color:var(--white);border-color:var(--red);transform:translateY(-1px);box-shadow:0 4px 14px rgba(239,68,68,.3);}
.btn-add-txn{text-decoration:none;background:rgba(34,197,94,.1);color:var(--green-dk);border:1.5px solid rgba(34,197,94,.3);padding:8px 14px;border-radius:8px;font-size:13px;font-weight:600;transition:all .2s;display:flex;align-items:center;gap:6px;}
.btn-add-txn:hover{background:var(--green);color:var(--white);border-color:var(--green);}
/* EMPTY */
.empty-state{text-align:center;padding:70px 30px;background:var(--white);border-radius:16px;border:1px solid var(--border);box-shadow:var(--card-shadow);}
.empty-icon{font-size:52px;margin-bottom:16px;}
.empty-state h3{font-size:19px;font-weight:700;color:var(--navy);margin-bottom:8px;}
.empty-state p{font-size:14px;color:var(--muted);margin-bottom:24px;line-height:1.7;}
.btn-primary{display:inline-flex;align-items:center;gap:8px;padding:13px 26px;background:var(--blue);color:var(--white);text-decoration:none;border-radius:10px;font-size:14.5px;font-weight:700;transition:all .22s;box-shadow:0 2px 8px rgba(59,130,246,.3);font-family:'Outfit',sans-serif;}
.btn-primary:hover{background:var(--blue-dark);transform:translateY(-1px);box-shadow:0 6px 20px rgba(59,130,246,.4);}
/* HEADER ACTIONS */
.btn-success{display:inline-flex;align-items:center;gap:7px;padding:11px 20px;background:var(--green);color:var(--white);text-decoration:none;border-radius:10px;font-size:14px;font-weight:700;transition:all .22s;box-shadow:0 2px 8px rgba(34,197,94,.3);}
.btn-success:hover{background:var(--green-dk);transform:translateY(-1px);}
/* flash messages */
.alert-success{background:#f0fdf4;color:#166534;border:1px solid #bbf7d0;border-left:4px solid var(--green);border-radius:10px;padding:12px 16px;font-size:13.5px;margin-bottom:20px;}
.alert-error{background:#fef2f2;color:#7f1d1d;border:1px solid #fecaca;border-left:4px solid var(--red);border-radius:10px;padding:12px 16px;font-size:13.5px;margin-bottom:20px;}
@media(max-width:768px){.app-header{padding:0 18px;height:auto;flex-wrap:wrap;gap:10px;padding-top:14px;padding-bottom:14px;}.app-nav{flex-wrap:wrap;justify-content:center;gap:6px;}.nav-link{padding:7px 11px;font-size:12.5px;}.page-wrap{padding:16px 14px;}.cards-grid{grid-template-columns:1fr;}}
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
        <a href="Mycards"            class="nav-link active">My Cards</a>
        <a href="AddCreditCard"      class="nav-link">Add Card</a>
        <a href="TransactionHistory" class="nav-link">History</a>
        <a href="AddTransactions"    class="nav-link btn-green">+ Add Transaction</a>
        <a href="Logout"                 class="nav-link btn-logout">Logout</a>
    </nav>
</header>

<div class="page-wrap">
    <div class="page-header">
        <div>
            <h1>My Saved Cards</h1>
            <p>Manage your credit cards. Add new cards or remove existing ones.</p>
        </div>
        <a href="AddCreditCard" class="btn-success">+ Add New Card</a>
    </div>

    <%
        String flashMsg = request.getParameter("msg");
        if ("deleted".equals(flashMsg)) {
    %>
    <div class="alert-success">✅ Card removed successfully.</div>
    <% } else if ("error".equals(flashMsg)) { %>
    <div class="alert-error">❌ Failed to remove card. Please try again.</div>
    <% } %>

    <div class="cards-grid">
<c:choose>
  <c:when test="${not empty cards}">
    <c:forEach var="card" items="${cards}" varStatus="st">
      <c:set var="cardClasses" value="card-blue,card-green,card-amber,card-purple"/>
      <c:set var="cls" value="card-blue"/>
      <c:if test="${st.index % 4 == 1}"><c:set var="cls" value="card-green"/></c:if>
      <c:if test="${st.index % 4 == 2}"><c:set var="cls" value="card-amber"/></c:if>
      <c:if test="${st.index % 4 == 3}"><c:set var="cls" value="card-purple"/></c:if>
      <div class="card-wrapper">
        <div class="cc-card ${cls}">
          <div class="cc-chip"></div>
          <div class="cc-name">${card.card_name}</div>
          <div class="cc-number">XXXX &nbsp; XXXX &nbsp; XXXX &nbsp; ${card.card_last4}</div>
          <div class="cc-footer">
            <div>
              <div class="cc-meta-label">Last 4 Digits</div>
              <div class="cc-meta-value">**** ${card.card_last4}</div>
            </div>
            <div class="cc-status">● Active</div>
          </div>
        </div>
        <div class="card-action-strip">
          <a href="AddTransactions" class="btn-add-txn">+ Add Transaction</a>
          <form action="DeleteCard" method="post" style="display:inline;"
                onsubmit="return confirm('Remove ${card.card_name}? This cannot be undone.')">
            <input type="hidden" name="cardId" value="${card.card_id}">
            <button type="submit" class="btn-delete">🗑 Remove</button>
          </form>
        </div>
      </div>
    </c:forEach>
  </c:when>
  <c:otherwise>
    <div class="empty-state">
      <div class="empty-icon">💳</div>
      <h3>No Cards Added Yet</h3>
      <p>Add your first credit card to start tracking your spending and managing transactions.</p>
      <a href="AddCreditCard" class="btn-primary">+ Add Your First Card</a>
    </div>
  </c:otherwise>
</c:choose>
    </div>
</body>
</html>
