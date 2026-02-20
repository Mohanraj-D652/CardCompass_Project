

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
    <title>Add Transaction – CardCompass</title>
    <%@ include file="common-style.jsp" %>

    <!-- Tesseract.js - Free browser OCR, no API key needed -->
    <script src="https://cdn.jsdelivr.net/npm/tesseract.js@5/dist/tesseract.min.js"></script>
    <style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap');

/* ── EXACT design tokens from Dashboard & TransactionHistory ── */
:root{
  --navy:#0f172a;
  --navy-2:#1e293b;
  --blue:#3b82f6;
  --blue-dark:#2563eb;
  --green:#22c55e;
  --green-dk:#16a34a;
  --red:#ef4444;
  --amber:#f59e0b;
  --bg:#f1f5f9;
  --white:#ffffff;
  --border:#e2e8f0;
  --text:#0f172a;
  --muted:#64748b;
  --muted-2:#94a3b8;
  --card-shadow:0 1px 3px rgba(15,23,42,.07),0 4px 16px rgba(15,23,42,.05);
  --hover-shadow:0 8px 28px rgba(15,23,42,.14);
}

*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
html,body{width:100%;overflow-x:hidden;}
body{
  font-family:'Outfit',sans-serif;
  background:var(--bg);
  color:var(--text);
  min-height:100vh;
  -webkit-font-smoothing:antialiased;
}

/* ══════════════════════════════════════════
   HEADER — identical to Dashboard.jsp
══════════════════════════════════════════ */
.app-header{
  width:100%;height:64px;
  background:var(--navy);
  display:flex;align-items:center;justify-content:space-between;
  padding:0 32px;
  position:sticky;top:0;z-index:1000;
  box-shadow:0 2px 16px rgba(15,23,42,.3);
}
.app-brand{display:flex;align-items:center;gap:10px;text-decoration:none;}
.app-brand-icon{
  width:36px;height:36px;
  background:linear-gradient(135deg,var(--blue),var(--green));
  border-radius:10px;
  display:flex;align-items:center;justify-content:center;
  font-size:18px;
}
.app-brand-name{font-size:16px;font-weight:700;color:var(--white);letter-spacing:-0.3px;}
.app-nav{display:flex;align-items:center;gap:6px;}
.nav-link{
  padding:8px 14px;border-radius:8px;
  font-size:13.5px;font-weight:500;
  text-decoration:none;color:#94a3b8;
  transition:all .2s;
  border:1.5px solid transparent;
  white-space:nowrap;
}
.nav-link:hover{color:var(--white);background:rgba(255,255,255,.08);}
.nav-link.active{color:var(--white);background:rgba(59,130,246,.25);border-color:rgba(59,130,246,.4);}
.nav-link.btn-green{
  background:var(--green);color:var(--white);
  border-color:var(--green);font-weight:600;
}
.nav-link.btn-green:hover{background:var(--green-dk);transform:translateY(-1px);}
.nav-link.btn-logout{color:#f87171;}
.nav-link.btn-logout:hover{background:rgba(239,68,68,.15);color:#fca5a5;}
.nav-link.btn-scan{
  background:var(--blue);color:var(--white);
  border-color:var(--blue);font-weight:600;
  display:flex;align-items:center;gap:6px;
}
.nav-link.btn-scan:hover{background:var(--blue-dark);transform:translateY(-1px);}

/* ══════════════════════════════════════════
   PAGE LAYOUT — identical to Dashboard.jsp
══════════════════════════════════════════ */
.page-wrap{max-width:1200px;margin:0 auto;padding:32px 28px;}

/* ── Page header (matches TransactionHistory) ── */
.page-header{
  display:flex;justify-content:space-between;align-items:flex-start;
  flex-wrap:wrap;gap:16px;margin-bottom:28px;
}
.page-header h1{font-size:26px;font-weight:800;color:var(--navy);letter-spacing:-0.6px;margin-bottom:6px;}
.page-header p{font-size:14px;color:var(--muted);line-height:1.6;}

/* ── Primary action button (matches TransactionHistory btn-success) ── */
.btn-success{
  display:inline-flex;align-items:center;gap:7px;
  padding:11px 20px;
  background:var(--blue);color:var(--white);
  text-decoration:none;border-radius:10px;
  font-size:14px;font-weight:700;font-family:'Outfit',sans-serif;
  transition:all .22s;
  box-shadow:0 2px 8px rgba(59,130,246,.3);
  border:none;cursor:pointer;
}
.btn-success:hover{background:var(--blue-dark);transform:translateY(-1px);}
.btn-success.green{
  background:var(--green);
  box-shadow:0 2px 8px rgba(34,197,94,.3);
}
.btn-success.green:hover{background:var(--green-dk);}

/* ══════════════════════════════════════════
   LAYOUT: two-column on wide screens
══════════════════════════════════════════ */
.content-grid{
  display:grid;
  grid-template-columns:1fr 380px;
  gap:24px;
  align-items:start;
}

/* ══════════════════════════════════════════
   FORM CARD — matches Dashboard stat cards
══════════════════════════════════════════ */
.form-card{
  background:var(--white);
  border-radius:14px;
  border:1px solid var(--border);
  box-shadow:var(--card-shadow);
  overflow:hidden;
}
.form-card-header{
  padding:20px 26px 18px;
  border-bottom:1.5px solid var(--border);
  display:flex;align-items:center;gap:12px;
}
.form-card-header-icon{
  width:40px;height:40px;
  background:linear-gradient(135deg,var(--green),#16a34a);
  border-radius:10px;
  display:flex;align-items:center;justify-content:center;
  font-size:18px;
  flex-shrink:0;
}
.form-card-header-title{font-size:17px;font-weight:700;color:var(--navy);letter-spacing:-0.3px;}
.form-card-header-sub{font-size:12.5px;color:var(--muted);margin-top:2px;}
.form-card-body{padding:26px;}

/* ── Form fields ── */
.field-group{margin-bottom:20px;}
.field-group:last-of-type{margin-bottom:0;}
.field-label{
  display:block;margin-bottom:7px;
  font-size:13px;font-weight:600;
  color:var(--navy);letter-spacing:.1px;
}
.field-label span{color:var(--red);}
.field-input,
.field-select{
  width:100%;padding:11px 14px;
  border:1.5px solid var(--border);
  border-radius:9px;
  font-size:14px;font-family:'Outfit',sans-serif;
  color:var(--text);background:#f8fafc;
  transition:all .2s;
  outline:none;
}
.field-select{
  cursor:pointer;appearance:none;
  background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath fill='%2364748b' d='M6 8L0 0h12z'/%3E%3C/svg%3E");
  background-repeat:no-repeat;background-position:right 14px center;
  padding-right:38px;
}
.field-input:focus,.field-select:focus{
  border-color:var(--blue);
  background:var(--white);
  box-shadow:0 0 0 3px rgba(59,130,246,.1);
}
.field-input.scanned{
  border-color:var(--amber);background:#fffbeb;
  box-shadow:0 0 0 3px rgba(245,158,11,.12);
}
.field-input::placeholder{color:var(--muted-2);}

/* ── Submit button ── */
.btn-submit{
  width:100%;padding:13px 20px;
  background:var(--green);color:var(--white);
  border:none;border-radius:10px;
  font-size:15px;font-weight:700;font-family:'Outfit',sans-serif;
  cursor:pointer;transition:all .22s;
  box-shadow:0 2px 8px rgba(34,197,94,.3);
  display:flex;align-items:center;justify-content:center;gap:8px;
  margin-top:24px;
}
.btn-submit:hover{background:var(--green-dk);transform:translateY(-1px);box-shadow:0 6px 18px rgba(34,197,94,.4);}

/* ── Nav buttons below form ── */
.nav-buttons{display:flex;gap:10px;margin-top:14px;}
.btn-secondary{
  flex:1;padding:11px 14px;
  background:var(--white);color:var(--muted);
  border:1.5px solid var(--border);
  border-radius:9px;
  text-align:center;text-decoration:none;
  font-size:13.5px;font-weight:600;font-family:'Outfit',sans-serif;
  transition:all .2s;
  display:flex;align-items:center;justify-content:center;gap:6px;
}
.btn-secondary:hover{border-color:var(--blue);color:var(--blue);background:#f0f7ff;}

/* ══════════════════════════════════════════
   VERIFY BANNER — matches info-box in Dashboard
══════════════════════════════════════════ */
#billVerifyBanner{
  display:none;
  background:#fffbeb;
  border:1.5px solid var(--amber);
  border-left:4px solid var(--amber);
  border-radius:10px;
  padding:14px 16px;margin-bottom:20px;
  font-size:13.5px;color:#7a5c00;line-height:1.7;
}
#billVerifyBanner strong{color:var(--navy);}
.verify-row{display:flex;flex-wrap:wrap;gap:14px;margin-top:8px;}
.verify-item{display:flex;align-items:center;gap:6px;font-size:13px;}
.verify-item .vk{color:var(--muted);font-weight:600;text-transform:uppercase;font-size:10.5px;letter-spacing:.5px;}
.verify-item .vv{color:var(--navy);font-weight:700;}

/* ══════════════════════════════════════════
   SIDEBAR TIPS CARD — matches quick-link style
══════════════════════════════════════════ */
.sidebar-card{
  background:var(--white);border-radius:14px;
  border:1px solid var(--border);box-shadow:var(--card-shadow);
  overflow:hidden;
}
.sidebar-card-header{
  padding:16px 20px;border-bottom:1.5px solid var(--border);
  font-size:13.5px;font-weight:700;color:var(--navy);
  display:flex;align-items:center;gap:8px;
}
.sidebar-card-body{padding:16px 20px;}

/* ── OCR/Scan card in sidebar ── */
.scan-promo{
  background:linear-gradient(135deg,var(--navy) 0%,#0f2044 100%);
  border-radius:14px;border:1px solid var(--navy-2);
  padding:22px;
  position:relative;overflow:hidden;
}
.scan-promo::before{
  content:'';position:absolute;top:-30px;right:-30px;
  width:120px;height:120px;
  background:rgba(59,130,246,.15);border-radius:50%;
}
.scan-promo::after{
  content:'';position:absolute;bottom:-40px;left:10px;
  width:100px;height:100px;
  background:rgba(34,197,94,.1);border-radius:50%;
}
.scan-promo-icon{font-size:36px;margin-bottom:12px;position:relative;}
.scan-promo-title{font-size:16px;font-weight:800;color:var(--white);margin-bottom:6px;position:relative;letter-spacing:-0.3px;}
.scan-promo-desc{font-size:13px;color:rgba(255,255,255,.6);line-height:1.6;margin-bottom:16px;position:relative;}
.btn-scan-big{
  width:100%;padding:12px 16px;
  background:var(--blue);color:var(--white);
  border:none;border-radius:10px;
  font-size:14px;font-weight:700;font-family:'Outfit',sans-serif;
  cursor:pointer;transition:all .22s;
  display:flex;align-items:center;justify-content:center;gap:8px;
  position:relative;
  box-shadow:0 2px 8px rgba(59,130,246,.4);
}
.btn-scan-big:hover{background:var(--blue-dark);transform:translateY(-1px);}

/* ── Tips list ── */
.tip-item{
  display:flex;align-items:flex-start;gap:10px;
  padding:10px 0;border-bottom:1px solid var(--border);
  font-size:13px;color:var(--muted);line-height:1.5;
}
.tip-item:last-child{border-bottom:none;padding-bottom:0;}
.tip-icon{font-size:15px;flex-shrink:0;margin-top:1px;}

/* ── Category quick-pick chips ── */
.cat-chips{display:flex;flex-wrap:wrap;gap:7px;margin-top:8px;}
.cat-chip{
  padding:5px 12px;border-radius:20px;
  font-size:12px;font-weight:600;
  cursor:pointer;transition:all .18s;
  border:1.5px solid var(--border);
  background:var(--white);color:var(--muted);
  font-family:'Outfit',sans-serif;
}
.cat-chip:hover,.cat-chip.active{
  background:rgba(59,130,246,.1);color:var(--blue);
  border-color:rgba(59,130,246,.35);
}
.chip-food.active   {background:rgba(239,68,68,.1);color:#b91c1c;border-color:rgba(239,68,68,.35);}
.chip-travel.active {background:rgba(59,130,246,.1);color:#1e40af;border-color:rgba(59,130,246,.35);}
.chip-shop.active   {background:rgba(245,158,11,.1);color:#b45309;border-color:rgba(245,158,11,.35);}
.chip-health.active {background:rgba(34,197,94,.1);color:#15803d;border-color:rgba(34,197,94,.35);}
.chip-util.active   {background:rgba(168,85,247,.1);color:#6b21a8;border-color:rgba(168,85,247,.35);}
.chip-ent.active    {background:rgba(236,72,153,.1);color:#9d174d;border-color:rgba(236,72,153,.35);}
.chip-edu.active    {background:rgba(20,184,166,.1);color:#0f766e;border-color:rgba(20,184,166,.35);}

/* ══════════════════════════════════════════
   UPLOAD MODAL
══════════════════════════════════════════ */
.upload-modal{
  display:none;position:fixed;top:0;left:0;
  width:100%;height:100%;
  background:rgba(15,23,42,.7);
  backdrop-filter:blur(4px);
  z-index:2000;
  justify-content:center;align-items:center;
}
.upload-modal.active{display:flex;}
.modal-content{
  background:var(--white);border-radius:20px;
  padding:0;max-width:580px;width:90%;
  max-height:90vh;overflow-y:auto;
  position:relative;
  box-shadow:0 20px 60px rgba(15,23,42,.4);
}
.modal-header{
  background:linear-gradient(135deg,var(--navy) 0%,#0f2044 100%);
  padding:28px 30px 24px;
  border-radius:20px 20px 0 0;
  position:relative;overflow:hidden;
}
.modal-header::before{
  content:'';position:absolute;top:-20px;right:-20px;
  width:120px;height:120px;
  background:rgba(59,130,246,.15);border-radius:50%;
}
.modal-header h3{font-size:20px;font-weight:800;color:var(--white);margin-bottom:6px;position:relative;letter-spacing:-0.4px;}
.modal-header p{font-size:13px;color:rgba(255,255,255,.6);position:relative;line-height:1.5;}
.modal-close{
  position:absolute;top:16px;right:16px;
  background:rgba(255,255,255,.15);color:var(--white);
  border:none;width:32px;height:32px;border-radius:50%;
  cursor:pointer;font-size:16px;font-weight:700;
  display:flex;align-items:center;justify-content:center;
  transition:all .2s;
}
.modal-close:hover{background:rgba(239,68,68,.8);transform:rotate(90deg);}
.modal-body{padding:24px 28px;}

/* ── Upload zone ── */
.upload-zone{
  background:#f8fafc;border:2px dashed var(--border);
  border-radius:12px;padding:32px 20px;text-align:center;
  cursor:pointer;transition:all .25s;margin-bottom:16px;
}
.upload-zone:hover{border-color:var(--blue);background:#f0f7ff;}
.upload-zone.dragover{background:#e0f0ff;border-color:var(--blue);border-width:2.5px;}
.upload-icon{font-size:40px;margin-bottom:10px;}
.upload-text{font-size:15px;font-weight:700;color:var(--navy);margin-bottom:5px;}
.upload-subtext{color:var(--muted);font-size:12.5px;}
.file-input-wrapper input{display:none;}
.btn-choose-file{
  background:var(--blue);color:var(--white);
  padding:10px 26px;border-radius:8px;
  border:none;cursor:pointer;
  font-size:13.5px;font-weight:700;margin-top:14px;
  font-family:'Outfit',sans-serif;transition:all .2s;
}
.btn-choose-file:hover{background:var(--blue-dark);}

/* ── Bill preview inside modal ── */
.bill-preview-wrap{display:none;margin-bottom:16px;}
.bill-preview-wrap img{
  width:100%;max-height:260px;object-fit:contain;
  border-radius:10px;border:1.5px solid var(--border);
}
.btn-remove{
  background:rgba(239,68,68,.1);color:var(--red);
  padding:8px 16px;border:1.5px solid rgba(239,68,68,.25);
  border-radius:8px;cursor:pointer;
  font-size:13px;font-weight:600;margin-top:10px;
  font-family:'Outfit',sans-serif;transition:all .2s;
}
.btn-remove:hover{background:var(--red);color:var(--white);}

/* ── OCR progress ── */
#ocrProgressWrap{display:none;margin:14px 0;}
.ocr-label{
  font-size:12.5px;color:var(--muted);margin-bottom:7px;
  display:flex;justify-content:space-between;font-weight:600;
}
.ocr-bar-bg{background:#e2e8f0;border-radius:20px;height:8px;overflow:hidden;}
.ocr-bar-fill{
  height:100%;border-radius:20px;
  background:linear-gradient(90deg,var(--blue),var(--green));
  transition:width .3s ease;width:0%;
}

/* ── Extracted fields ── */
#extractedFields{
  display:none;
  background:#f0f9ff;border:1.5px solid #bae6fd;
  border-radius:12px;padding:18px;margin-bottom:14px;
}
#extractedFields h4{
  font-size:13px;color:#0369a1;margin-bottom:14px;
  font-weight:700;display:flex;align-items:center;gap:6px;
}
.extracted-row{
  display:flex;align-items:center;gap:10px;margin-bottom:10px;
}
.extracted-row label{
  min-width:76px;font-size:12.5px;color:var(--muted);
  font-weight:600;margin:0;
}
.extracted-row input,.extracted-row select{
  flex:1;padding:8px 12px;
  border:1.5px solid var(--border);border-radius:8px;
  font-size:13px;font-family:'Outfit',sans-serif;
  background:var(--white);color:var(--text);
  margin:0;outline:none;transition:all .2s;
}
.extracted-row input:focus,.extracted-row select:focus{
  border-color:var(--blue);box-shadow:0 0 0 3px rgba(59,130,246,.1);
}
.btn-use-data{
  width:100%;padding:12px;
  background:var(--green);color:var(--white);
  border:none;border-radius:9px;
  font-size:14px;font-weight:700;
  cursor:pointer;transition:all .22s;margin-top:6px;
  font-family:'Outfit',sans-serif;
  box-shadow:0 2px 8px rgba(34,197,94,.3);
}
.btn-use-data:hover{background:var(--green-dk);transform:translateY(-1px);}

/* ── Alert inside modal ── */
.alert{padding:11px 15px;border-radius:9px;font-size:13px;margin-bottom:12px;font-weight:500;}
.alert-success{background:#f0fdf4;color:#15803d;border:1.5px solid #bbf7d0;}
.alert-error  {background:#fef2f2;color:#b91c1c;border:1.5px solid #fecaca;}
.alert-info   {background:#f0f9ff;color:#0369a1;border:1.5px solid #bae6fd;}

/* ══════════════════════════════════════════
   RESPONSIVE
══════════════════════════════════════════ */
@media(max-width:900px){
  .content-grid{grid-template-columns:1fr;}
}
@media(max-width:768px){
  .app-header{padding:0 18px;height:auto;flex-wrap:wrap;gap:10px;padding-top:14px;padding-bottom:14px;}
  .app-nav{flex-wrap:wrap;justify-content:center;gap:6px;}
  .nav-link{padding:7px 11px;font-size:12.5px;}
  .page-wrap{padding:16px 14px;}
  .page-header{flex-direction:column;align-items:flex-start;}
}
@media(max-width:480px){
  .app-brand-name{display:none;}
  .app-nav{width:100%;}
  .nav-link{flex:1;text-align:center;}
}
    </style>
</head>
<body>

<!-- ══ HEADER — identical structure to Dashboard.jsp ══ -->
<header class="app-header">
    <a href="dashboard" class="app-brand">
        <div class="app-brand-icon">💳</div>
        <span class="app-brand-name">CardCompass</span>
    </a>
    <nav class="app-nav">
        <a href="dashboard"          class="nav-link">Dashboard</a>
        <a href="Mycards"            class="nav-link">My Cards</a>
        <a href="AddCreditCard"      class="nav-link">Add Card</a>
        <a href="TransactionHistory" class="nav-link">History</a>
        <a href="ViewReport"         class="nav-link">Reports</a>
        <a href="AddTransactions"    class="nav-link active">+ Add Transaction</a>
        <button onclick="openUploadModal()" class="nav-link btn-scan">📷 Scan Bill</button>
        <a href="Logout"              class="nav-link btn-logout">Logout</a>
    </nav>
</header>

<!-- ══ PAGE ══ -->
<div class="page-wrap">

    <!-- Page header — matches TransactionHistory.jsp style -->
    <div class="page-header">
        <div>
            <h1>Add Transaction</h1>
            <p>Log a new purchase manually or scan a bill image — OCR runs entirely in your browser.</p>
        </div>
        <button onclick="openUploadModal()" class="btn-success">📷 Scan Bill</button>
    </div>

    <!-- Two-column layout -->
    <div class="content-grid">

        <!-- ══ LEFT: MAIN FORM CARD ══ -->
        <div class="form-card">
            <div class="form-card-header">
                <div class="form-card-header-icon">➕</div>
                <div>
                    <div class="form-card-header-title">Transaction Details</div>
                    <div class="form-card-header-sub">Fill in the fields below and save</div>
                </div>
            </div>
            <div class="form-card-body">

                <!-- Verify banner (shown after OCR scan) -->
                <div id="billVerifyBanner">
                    ⚠️ <strong>Bill scanned — verify data before saving</strong>
                    <div class="verify-row">
                        <div class="verify-item">
                            <span class="vk">Merchant</span>
                            <span class="vv" id="verifyMerchant">—</span>
                        </div>
                        <div class="verify-item">
                            <span class="vk">Amount</span>
                            <span class="vv" id="verifyAmount" style="color:var(--green);">—</span>
                        </div>
                        <div class="verify-item">
                            <span class="vk">Date</span>
                            <span class="vv" id="verifyDate">—</span>
                        </div>
                    </div>
                    <div style="margin-top:8px;font-size:12.5px;color:var(--muted);">✏️ Correct any wrong values above before saving.</div>
                </div>

                <form action="AddTransactions" method="post" id="txnForm">

                    <!-- Card select -->
                    <div class="field-group">
                        <label class="field-label" for="card_id">Select Card <span>*</span></label>
                        <select name="card_id" id="card_id" class="field-select" required>
                            <option value="">— Choose your card —</option>
                            <c:forEach var="card" items="${cards}">
                            <option value="${card.card_id}">
                                💳 ${card.card_name} (••••&nbsp;${card.card_last4})
                            </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Category select -->
                    <div class="field-group">
                        <label class="field-label" for="categorySelect">Category <span>*</span></label>
                        <select name="category_id" id="categorySelect" class="field-select" required>
                            <option value="">— Choose category —</option>
                            <c:forEach var="cat" items="${categories}">
                            <option value="${cat.category_id}">${cat.category_name}</option>
                            </c:forEach>
                        </select>
                        <!-- Quick-pick chips -->
                        <div class="cat-chips" id="catChips">
                            <button type="button" class="cat-chip chip-food"   onclick="quickCat(this,'Food')">🍔 Food</button>
                            <button type="button" class="cat-chip chip-travel" onclick="quickCat(this,'Travel')">✈️ Travel</button>
                            <button type="button" class="cat-chip chip-shop"   onclick="quickCat(this,'Shopping')">🛍️ Shopping</button>
                            <button type="button" class="cat-chip chip-health" onclick="quickCat(this,'Healthcare')">💊 Healthcare</button>
                            <button type="button" class="cat-chip chip-util"   onclick="quickCat(this,'Utilities')">💡 Utilities</button>
                            <button type="button" class="cat-chip chip-ent"    onclick="quickCat(this,'Entertainment')">🎬 Entertainment</button>
                            <button type="button" class="cat-chip chip-edu"    onclick="quickCat(this,'Education')">📚 Education</button>
                        </div>
                    </div>

                    <!-- Merchant -->
                    <div class="field-group">
                        <label class="field-label" for="merchantInput">Merchant Name <span>*</span></label>
                        <input type="text" name="merchant" id="merchantInput" class="field-input"
                               placeholder="e.g., Zomato, Netflix, Amazon" required>
                    </div>

                    <!-- Amount -->
                    <div class="field-group">
                        <label class="field-label" for="amountInput">Amount (₹) <span>*</span></label>
                        <input type="number" name="amount" id="amountInput" class="field-input"
                               step="0.01" min="0.01" placeholder="0.00" required>
                    </div>

                    <!-- Date -->
                    <div class="field-group">
                        <label class="field-label" for="dateInput">Transaction Date <span>*</span></label>
                        <input type="date" name="tdate" id="dateInput" class="field-input" required>
                    </div>

                    <button type="submit" class="btn-submit">
                        💾 Save Transaction
                    </button>
                </form>

                <div class="nav-buttons">
                    <a href="dashboard"          class="btn-secondary">🏠 Dashboard</a>
                    <a href="TransactionHistory"  class="btn-secondary">📋 History</a>
                    <a href="Mycards"             class="btn-secondary">💳 My Cards</a>
                </div>

            </div>
        </div><!-- /form-card -->

        <!-- ══ RIGHT: SIDEBAR ══ -->
        <div style="display:flex;flex-direction:column;gap:18px;">

            <!-- OCR Scan promo -->
            <div class="scan-promo">
                <div class="scan-promo-icon">🧾</div>
                <div class="scan-promo-title">Scan a Bill</div>
                <div class="scan-promo-desc">Upload a photo of any receipt or invoice — OCR reads it instantly in your browser. No internet API needed.</div>
                <button onclick="openUploadModal()" class="btn-scan-big">📷 Open Bill Scanner</button>
            </div>

            <!-- Tips card -->
            <div class="sidebar-card">
                <div class="sidebar-card-header">💡 Quick Tips</div>
                <div class="sidebar-card-body">
                    <div class="tip-item">
                        <span class="tip-icon">📷</span>
                        <span>Use clear, well-lit photos of bills for best OCR accuracy.</span>
                    </div>
                    <div class="tip-item">
                        <span class="tip-icon">✅</span>
                        <span>Always review scanned values — OCR may misread handwritten amounts.</span>
                    </div>
                    <div class="tip-item">
                        <span class="tip-icon">🏷️</span>
                        <span>Use the category chips above the dropdown for faster selection.</span>
                    </div>
                    <div class="tip-item">
                        <span class="tip-icon">📊</span>
                        <span>View spending breakdowns on the <a href="CatagerywiseSpending" style="color:var(--blue);text-decoration:none;font-weight:600;">Category Spend</a> page.</span>
                    </div>
                </div>
            </div>

        </div><!-- /sidebar -->

    </div><!-- /content-grid -->
</div><!-- /page-wrap -->


<!-- ══ UPLOAD / SCAN MODAL ══════════════════════════════════════════ -->
<div id="uploadModal" class="upload-modal">
    <div class="modal-content">

        <div class="modal-header">
            <button class="modal-close" onclick="closeUploadModal()">×</button>
            <h3>📷 Scan Bill Image</h3>
            <p>Upload your receipt — text is read directly in your browser, nothing is sent to any server.</p>
        </div>

        <div class="modal-body">

            <div id="alertContainer"></div>

            <!-- Drop zone -->
            <div id="dropZone" class="upload-zone">
                <div class="upload-icon">🧾</div>
                <div class="upload-text">Drag & Drop your bill here</div>
                <div class="upload-subtext">JPG · PNG · JPEG · up to 10 MB</div>
                <div class="file-input-wrapper">
                    <button type="button" class="btn-choose-file"
                            onclick="document.getElementById('billImageInput').click()">
                        Choose File
                    </button>
                    <input type="file" id="billImageInput" accept="image/*">
                </div>
            </div>

            <!-- Preview -->
            <div id="billPreviewWrap" class="bill-preview-wrap">
                <img id="previewImage" src="" alt="Bill preview">
                <br>
                <button type="button" class="btn-remove" onclick="resetScan()">✕ Remove &amp; Reset</button>
            </div>

            <!-- OCR progress bar -->
            <div id="ocrProgressWrap">
                <div class="ocr-label">
                    <span id="ocrStatus">Reading bill...</span>
                    <span id="ocrPct">0%</span>
                </div>
                <div class="ocr-bar-bg">
                    <div class="ocr-bar-fill" id="ocrBarFill"></div>
                </div>
            </div>

            <!-- Extracted fields — editable before applying -->
            <div id="extractedFields">
                <h4>✅ Extracted Data — Edit if needed before applying:</h4>

                <div class="extracted-row">
                    <label>Merchant</label>
                    <input type="text" id="ocr_merchant" placeholder="Merchant name">
                </div>
                <div class="extracted-row">
                    <label>Amount ₹</label>
                    <input type="number" id="ocr_amount" step="0.01" placeholder="0.00">
                </div>
                <div class="extracted-row">
                    <label>Date</label>
                    <input type="date" id="ocr_date">
                </div>
                <div class="extracted-row">
                    <label>Category</label>
                    <select id="ocr_category">
                        <option value="">— Select —</option>
                        <option>Food</option>
                        <option>Travel</option>
                        <option>Entertainment</option>
                        <option>Shopping</option>
                        <option>Healthcare</option>
                        <option>Utilities</option>
                        <option>Education</option>
                        <option>Others</option>
                    </select>
                </div>

                <button type="button" class="btn-use-data" onclick="applyExtractedData()">
                    ✅ Use This Data &amp; Fill Form
                </button>
            </div>

            <p style="text-align:center;color:var(--muted-2);font-size:12px;margin-top:12px;">
                💡 Tip: Clear, well-lit photos give the best OCR results
            </p>
        </div><!-- /modal-body -->
    </div><!-- /modal-content -->
</div><!-- /modal -->


<!-- ══ JAVASCRIPT — all OCR logic preserved exactly ══ -->
<script>
// ── DOM refs ──────────────────────────────────────────────────────────
var dropZone        = document.getElementById('dropZone');
var billInput       = document.getElementById('billImageInput');
var previewImage    = document.getElementById('previewImage');
var billPreviewWrap = document.getElementById('billPreviewWrap');
var ocrProgressWrap = document.getElementById('ocrProgressWrap');
var ocrBarFill      = document.getElementById('ocrBarFill');
var ocrStatus       = document.getElementById('ocrStatus');
var ocrPct          = document.getElementById('ocrPct');
var extractedFields = document.getElementById('extractedFields');
var alertContainer  = document.getElementById('alertContainer');
var uploadModal     = document.getElementById('uploadModal');

var merchantInput   = document.getElementById('merchantInput');
var amountInput     = document.getElementById('amountInput');
var dateInput       = document.getElementById('dateInput');
var categorySelect  = document.getElementById('categorySelect');

// Set today's date as default
dateInput.value = new Date().toISOString().split('T')[0];

// ── Category quick-pick chips ─────────────────────────────────────────
function quickCat(chip, catName) {
    document.querySelectorAll('.cat-chip').forEach(function(c){ c.classList.remove('active'); });
    chip.classList.add('active');
    for (var i = 0; i < categorySelect.options.length; i++) {
        if (categorySelect.options[i].text.toLowerCase().indexOf(catName.toLowerCase()) !== -1) {
            categorySelect.selectedIndex = i; break;
        }
    }
}
// Sync chips when dropdown changes
categorySelect.addEventListener('change', function() {
    var val = this.options[this.selectedIndex].text.toLowerCase();
    document.querySelectorAll('.cat-chip').forEach(function(c){
        var cn = c.textContent.trim().toLowerCase();
        c.classList.toggle('active', cn.indexOf(val) !== -1 || val.indexOf(cn.replace(/[^a-z]/g,'')) !== -1);
    });
});

// ── Modal open/close ──────────────────────────────────────────────────
function openUploadModal()  { uploadModal.classList.add('active'); }
function closeUploadModal() { uploadModal.classList.remove('active'); }
uploadModal.addEventListener('click', function(e) {
    if (e.target === uploadModal) closeUploadModal();
});

// ── Drag & drop ───────────────────────────────────────────────────────
['dragenter','dragover','dragleave','drop'].forEach(function(ev) {
    dropZone.addEventListener(ev, function(e){ e.preventDefault(); e.stopPropagation(); });
});
dropZone.addEventListener('dragenter', function(){ dropZone.classList.add('dragover'); });
dropZone.addEventListener('dragover',  function(){ dropZone.classList.add('dragover'); });
dropZone.addEventListener('dragleave', function(){ dropZone.classList.remove('dragover'); });
dropZone.addEventListener('drop', function(e){
    dropZone.classList.remove('dragover');
    handleFiles(e.dataTransfer.files);
});
billInput.addEventListener('change', function(e){ handleFiles(e.target.files); });

// ── File handling ─────────────────────────────────────────────────────
function handleFiles(files) {
    if (!files || files.length === 0) return;
    var file = files[0];
    if (!file.type.startsWith('image/')) {
        showAlert('Please upload an image file (JPG, PNG, JPEG)', 'error'); return;
    }
    if (file.size > 10 * 1024 * 1024) {
        showAlert('File too large. Max 10 MB.', 'error'); return;
    }
    var reader = new FileReader();
    reader.onload = function(e) {
        previewImage.src = e.target.result;
        dropZone.style.display        = 'none';
        billPreviewWrap.style.display = 'block';
        runOCR(file);
    };
    reader.readAsDataURL(file);
}

// ── Tesseract OCR ─────────────────────────────────────────────────────
function runOCR(file) {
    ocrProgressWrap.style.display = 'block';
    extractedFields.style.display = 'none';
    alertContainer.innerHTML = '';

    ocrStatus.textContent    = 'Loading OCR engine...';
    ocrBarFill.style.width   = '5%';
    ocrPct.textContent       = '5%';

    Tesseract.recognize(file, 'eng', {
        logger: function(m) {
            if (m.status === 'recognizing text') {
                var pct = Math.round(m.progress * 100);
                ocrBarFill.style.width = pct + '%';
                ocrPct.textContent     = pct + '%';
                ocrStatus.textContent  = 'Reading text... ' + pct + '%';
            } else if (m.status === 'loading tesseract core') {
                ocrStatus.textContent = 'Loading OCR engine...';
            } else if (m.status === 'initializing tesseract') {
                ocrStatus.textContent  = 'Initializing...';
                ocrBarFill.style.width = '20%';
            } else if (m.status === 'loading language traineddata') {
                ocrStatus.textContent  = 'Loading language data...';
                ocrBarFill.style.width = '40%';
            }
        }
    }).then(function(result) {
        ocrBarFill.style.width = '100%';
        ocrPct.textContent     = '100%';
        ocrStatus.textContent  = '✅ Done!';
        var text = result.data.text;
        console.log('[OCR] Raw text:\n' + text);
        setTimeout(function() {
            ocrProgressWrap.style.display = 'none';
            parseAndFillExtracted(text);
        }, 500);
    }).catch(function(err) {
        ocrProgressWrap.style.display = 'none';
        console.error('[OCR] Error:', err);
        showAlert('OCR failed: ' + err.message + '. Please enter details manually.', 'error');
    });
}

// ── Smart bill text parser — logic preserved exactly ─────────────────
function parseAndFillExtracted(text) {
    var lines = text.split('\n').map(function(l){ return l.trim(); }).filter(Boolean);
    console.log('[OCR] Lines:', lines);

    // Amount
    var amount = '';
    var amountPatterns = [
        /topup\s*amount[\s:₹Rs.]*([0-9]+\.?[0-9]*)/i,
        /total[\s:₹Rs.]*([0-9]+\.?[0-9]*)/i,
        /amount[\s:₹Rs.]*([0-9]+\.?[0-9]*)/i,
        /inr[\s:₹Rs.]*([0-9]+\.?[0-9]*)/i,
        /grand\s*total[\s:₹Rs.]*([0-9]+\.?[0-9]*)/i,
        /payable[\s:₹Rs.]*([0-9]+\.?[0-9]*)/i,
        /paid[\s:₹Rs.]*([0-9]+\.?[0-9]*)/i,
        /₹\s*([0-9]+\.?[0-9]*)/
    ];
    for (var i = 0; i < amountPatterns.length; i++) {
        var m = text.match(amountPatterns[i]);
        if (m) { amount = parseFloat(m[1]).toFixed(2); break; }
    }

    // Date
    var date = '';
    var datePatterns = [
        { re: /\b(\d{2})[\/\-](\d{2})[\/\-](\d{4})\b/,
          fn: function(m){ return m[3]+'-'+m[2]+'-'+m[1]; } },
        { re: /\b(\d{4})[\/\-](\d{2})[\/\-](\d{2})\b/,
          fn: function(m){ return m[1]+'-'+m[2]+'-'+m[3]; } },
        { re: /\b(\d{1,2})\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+(\d{4})\b/i,
          fn: function(m){
              var months={jan:'01',feb:'02',mar:'03',apr:'04',may:'05',jun:'06',
                          jul:'07',aug:'08',sep:'09',oct:'10',nov:'11',dec:'12'};
              return m[3]+'-'+months[m[2].toLowerCase()]+'-'+m[1].padStart(2,'0');
          }
        }
    ];
    for (var j = 0; j < datePatterns.length; j++) {
        var dm = text.match(datePatterns[j].re);
        if (dm) { date = datePatterns[j].fn(dm); break; }
    }

    // Merchant
    var merchant = '';
    var skipWords = /receipt|invoice|bill|tax|gst|vat|transaction|date|time|no\.|number|customer|cashier|thank|welcome|please|visit|again/i;
    for (var k = 0; k < Math.min(lines.length, 6); k++) {
        var line = lines[k];
        if (line.length > 3 && !skipWords.test(line) && !/^\d+$/.test(line)) {
            merchant = toTitleCase(line.replace(/[^a-zA-Z0-9\s]/g, '').trim());
            if (merchant.length > 2) break;
        }
    }

    // Category
    var category = guessCategory(text, merchant);

    document.getElementById('ocr_merchant').value = merchant;
    document.getElementById('ocr_amount').value   = amount;
    document.getElementById('ocr_date').value     = date;
    setSelectByText('ocr_category', category);

    extractedFields.style.display = 'block';

    if (!amount) {
        showAlert('⚠️ Could not detect amount — please enter it manually below.', 'info');
    } else {
        showAlert('✅ Bill scanned! Review the values below, then click "Use This Data".', 'success');
    }
}

// ── Apply extracted data to main form ────────────────────────────────
function applyExtractedData() {
    var merchant = document.getElementById('ocr_merchant').value.trim();
    var amount   = document.getElementById('ocr_amount').value.trim();
    var date     = document.getElementById('ocr_date').value.trim();
    var category = document.getElementById('ocr_category').value;

    if (merchant) merchantInput.value = merchant;
    if (amount) {
        amountInput.value = amount;
        amountInput.classList.add('scanned');
    }
    if (date) dateInput.value = date;

    // Match category dropdown
    if (category) {
        for (var i = 0; i < categorySelect.options.length; i++) {
            if (categorySelect.options[i].text.toLowerCase().indexOf(category.toLowerCase()) !== -1) {
                categorySelect.selectedIndex = i; break;
            }
        }
        // Sync chips
        document.querySelectorAll('.cat-chip').forEach(function(c){
            var chipText = c.textContent.trim().replace(/[^a-z]/gi,'').toLowerCase();
            var catLow   = category.toLowerCase();
            c.classList.toggle('active', catLow.indexOf(chipText) !== -1 || chipText.indexOf(catLow.substring(0,4)) !== -1);
        });
    }

    // Show verify banner
    var banner = document.getElementById('billVerifyBanner');
    banner.style.display = 'block';
    document.getElementById('verifyMerchant').textContent = merchant || '—';
    document.getElementById('verifyAmount').textContent   = amount ? '₹' + amount : '—';
    document.getElementById('verifyDate').textContent     = date || '—';

    closeUploadModal();
    document.querySelector('.form-card').scrollIntoView({ behavior: 'smooth' });
    amountInput.focus();
}

// ── Reset scanned highlight when user edits manually ─────────────────
amountInput.addEventListener('input', function() {
    amountInput.classList.remove('scanned');
    var v = document.getElementById('verifyAmount');
    if (v && amountInput.value) v.textContent = '₹' + amountInput.value;
});

// ── Reset scan ────────────────────────────────────────────────────────
function resetScan() {
    billInput.value               = '';
    previewImage.src              = '';
    billPreviewWrap.style.display = 'none';
    dropZone.style.display        = 'block';
    ocrProgressWrap.style.display = 'none';
    extractedFields.style.display = 'none';
    alertContainer.innerHTML      = '';
}

// ── Helpers ───────────────────────────────────────────────────────────
function showAlert(msg, type) {
    alertContainer.innerHTML = '<div class="alert alert-' + type + '">' + msg + '</div>';
}
function toTitleCase(str) {
    return str.replace(/\w\S*/g, function(txt){
        return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
    });
}
function setSelectByText(id, text) {
    if (!text) return;
    var sel = document.getElementById(id);
    for (var i = 0; i < sel.options.length; i++) {
        if (sel.options[i].text.toLowerCase() === text.toLowerCase()) {
            sel.selectedIndex = i; return;
        }
    }
}
function guessCategory(text, merchant) {
    var t = (text + ' ' + merchant).toLowerCase();
    if (/zomato|swiggy|restaurant|food|cafe|pizza|burger|hotel|dine|eat|kitchen|bakery|kfc|mcdonald|domino/i.test(t))
        return 'Food';
    if (/metro|bus|train|flight|uber|ola|cab|taxi|auto|petrol|fuel|toll|travel|airline|ticket|singara|chennai card/i.test(t))
        return 'Travel';
    if (/netflix|amazon prime|hotstar|spotify|movie|cinema|pvr|inox|concert|game|entertainment/i.test(t))
        return 'Entertainment';
    if (/amazon|flipkart|myntra|shopping|mart|mall|store|shop|market/i.test(t))
        return 'Shopping';
    if (/hospital|clinic|pharmacy|medical|medicine|doctor|health|lab|diagnostic/i.test(t))
        return 'Healthcare';
    if (/electricity|water|gas|internet|broadband|wifi|mobile|recharge|postpaid|utility|bill/i.test(t))
        return 'Utilities';
    if (/school|college|university|course|tuition|education|book|library/i.test(t))
        return 'Education';
    return 'Others';
}
</script>
</body>
</html>
