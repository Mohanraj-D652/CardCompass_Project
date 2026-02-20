<%-- TransactionHistory.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="fn"  uri="jakarta.tags.functions"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction History – CardCompass</title>
    <%@ include file="common-style.jsp" %>
    <style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap');
:root{--navy:#0f172a;--navy-2:#1e293b;--blue:#3b82f6;--blue-dark:#2563eb;--green:#22c55e;--green-dk:#16a34a;--red:#ef4444;--bg:#f1f5f9;--white:#ffffff;--border:#e2e8f0;--text:#0f172a;--muted:#64748b;--muted-2:#94a3b8;--card-shadow:0 1px 3px rgba(15,23,42,.07),0 4px 16px rgba(15,23,42,.05);}
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
.page-header p{font-size:14px;color:var(--muted);line-height:1.6;}
.summary-row{background:var(--white);border-radius:14px;border:1px solid var(--border);padding:18px 24px;margin-bottom:24px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:14px;box-shadow:var(--card-shadow);border-left:4px solid var(--green);}
.summary-row-item{display:flex;flex-direction:column;gap:2px;}
.summary-row-label{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.7px;color:var(--muted);}
.summary-row-value{font-size:20px;font-weight:800;color:var(--navy);}
.table-wrap{background:var(--white);border-radius:14px;border:1px solid var(--border);box-shadow:var(--card-shadow);overflow:hidden;}
.table-toolbar{padding:16px 20px;border-bottom:1.5px solid var(--border);display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;}
.table-title{font-size:14px;font-weight:700;color:var(--navy);display:flex;align-items:center;gap:8px;}
.search-input{padding:9px 14px;border:1.5px solid var(--border);border-radius:8px;font-size:13.5px;font-family:'Outfit',sans-serif;background:#f8fafc;color:var(--text);outline:none;width:220px;transition:all .2s;}
.search-input:focus{border-color:var(--blue);background:var(--white);box-shadow:0 0 0 3px rgba(59,130,246,.1);}
table{width:100%;border-collapse:collapse;}
thead th{background:#f8fafc;padding:13px 16px;text-align:left;font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:.6px;border-bottom:1.5px solid var(--border);}
.th-right{text-align:right;}
tbody td{padding:14px 16px;font-size:14px;color:var(--text);border-bottom:1px solid #f1f5f9;vertical-align:middle;}
tbody tr:last-child td{border-bottom:none;}
tbody tr:hover{background:#f8fafc;}
.cat-badge{display:inline-flex;align-items:center;gap:5px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(59,130,246,.1);color:#1e40af;}
.cat-food{background:rgba(239,68,68,.1);color:#b91c1c;}
.cat-travel{background:rgba(59,130,246,.1);color:#1e40af;}
.cat-shop{background:rgba(245,158,11,.1);color:#b45309;}
.cat-health{background:rgba(34,197,94,.1);color:#15803d;}
.cat-util{background:rgba(168,85,247,.1);color:#6b21a8;}
.cat-ent{background:rgba(236,72,153,.1);color:#9d174d;}
.cat-edu{background:rgba(20,184,166,.1);color:#0f766e;}
.cat-other{background:rgba(100,116,139,.1);color:#334155;}
.amount-cell{text-align:right;font-weight:700;color:#15803d;font-size:15px;}
.id-cell{font-weight:700;color:var(--muted-2);font-size:13px;}
.merchant-cell{color:var(--navy);font-weight:500;}
.date-cell{color:var(--muted);font-size:13px;}
.no-data-cell{text-align:center;padding:60px 20px !important;color:var(--muted);}
.no-data-icon{font-size:44px;margin-bottom:12px;}
.btn-add-link{display:inline-flex;align-items:center;gap:7px;padding:12px 22px;background:var(--blue);color:var(--white);text-decoration:none;border-radius:10px;font-size:14px;font-weight:700;margin-top:16px;transition:all .22s;}
.btn-add-link:hover{background:var(--blue-dark);transform:translateY(-1px);}
.btn-success{display:inline-flex;align-items:center;gap:7px;padding:11px 20px;background:var(--green);color:var(--white);text-decoration:none;border-radius:10px;font-size:14px;font-weight:700;transition:all .22s;box-shadow:0 2px 8px rgba(34,197,94,.3);}
.btn-success:hover{background:var(--green-dk);transform:translateY(-1px);}

/* ── PAGINATION — added, matches existing style ── */
.pagination-wrap{
  display:flex;align-items:center;justify-content:space-between;
  flex-wrap:wrap;gap:12px;
  padding:14px 20px;
  border-top:1.5px solid var(--border);
  background:#f8fafc;
}
.pagination-info{
  font-size:13px;font-weight:500;color:var(--muted);
}
.pagination-controls{
  display:flex;align-items:center;gap:4px;
}
.pg-btn{
  min-width:36px;height:36px;
  padding:0 10px;
  border:1.5px solid var(--border);
  border-radius:8px;
  background:var(--white);
  color:var(--navy);
  font-size:13.5px;font-weight:600;
  font-family:'Outfit',sans-serif;
  cursor:pointer;
  transition:all .18s;
  display:inline-flex;align-items:center;justify-content:center;
}
.pg-btn:hover:not(:disabled){
  border-color:var(--blue);
  color:var(--blue);
  background:#f0f7ff;
}
.pg-btn.active{
  background:var(--blue);
  color:var(--white);
  border-color:var(--blue);
}
.pg-btn:disabled{
  opacity:.4;cursor:not-allowed;
}
.pg-sep{
  font-size:13px;color:var(--muted-2);
  padding:0 2px;user-select:none;
}

@media(max-width:768px){.app-header{padding:0 18px;height:auto;flex-wrap:wrap;gap:10px;padding-top:14px;padding-bottom:14px;}.app-nav{flex-wrap:wrap;justify-content:center;gap:6px;}.nav-link{padding:7px 11px;font-size:12.5px;}.page-wrap{padding:16px 14px;}.search-input{width:100%;}.pagination-wrap{flex-direction:column;align-items:flex-start;}}
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
        <a href="dashboard"            class="nav-link">Dashboard</a>
        <a href="Mycards"              class="nav-link">My Cards</a>
        <a href="TransactionHistory"   class="nav-link active">History</a>
        <a href="CatagerywiseSpending" class="nav-link">Spending</a>
        <a href="ViewReport"           class="nav-link">Reports</a>
        <a href="AddTransactions"      class="nav-link btn-green">+ Add Transaction</a>
        <a href="Logout"               class="nav-link btn-logout">Logout</a>
    </nav>
</header>

<div class="page-wrap">
    <div class="page-header">
        <div>
            <h1>Transaction History</h1>
            <p>All your card transactions — newest first, 10 per page.</p>
        </div>
        <a href="AddTransactions" class="btn-success">+ New Transaction</a>
    </div>

    <c:if test="${not empty transactions}">
    <div class="summary-row">
        <div class="summary-row-item">
            <span class="summary-row-label">Total Transactions</span>
            <span class="summary-row-value">${fn:length(transactions)}</span>
        </div>
        <div class="summary-row-item">
            <span class="summary-row-label">Total Spent</span>
            <span class="summary-row-value">&#8377;<fmt:formatNumber value="${totalSpent}" pattern="#,##0.00"/></span>
        </div>
    </div>
    </c:if>

    <div class="table-wrap">
        <div class="table-toolbar">
            <div class="table-title">&#128203; All Transactions</div>
            <input type="text" class="search-input" id="searchInput"
                   placeholder="Search merchant, category..." onkeyup="filterTable()">
        </div>
        <table id="txnTable">
            <thead>
                <tr>
                    <th style="width:60px;">#</th>
                    <th style="width:160px;">Category</th>
                    <th class="th-right" style="width:130px;">Amount</th>
                    <th>Merchant</th>
                    <th style="width:120px;">Date</th>
                </tr>
            </thead>
            <tbody id="txnBody">
<%-- Render newest → oldest: step through list in reverse index order --%>
<c:choose>
  <c:when test="${not empty transactions}">
    <c:set var="txnSize" value="${fn:length(transactions)}"/>
    <c:forEach var="i" begin="0" end="${txnSize - 1}" step="1">
      <%-- Compute reverse index so row 1 = most-recent transaction --%>
      <c:set var="revIdx" value="${txnSize - 1 - i}"/>
      <c:set var="t"      value="${transactions[revIdx]}"/>
      <c:set var="catName" value="${t.category_name}"/>
      <c:set var="catLow"  value="${fn:toLowerCase(catName)}"/>
      <c:set var="catClass" value="cat-other"/>
      <c:if test="${fn:contains(catLow,'food')}">     <c:set var="catClass" value="cat-food"/></c:if>
      <c:if test="${fn:contains(catLow,'travel')}">   <c:set var="catClass" value="cat-travel"/></c:if>
      <c:if test="${fn:contains(catLow,'shop')}">     <c:set var="catClass" value="cat-shop"/></c:if>
      <c:if test="${fn:contains(catLow,'health')}">   <c:set var="catClass" value="cat-health"/></c:if>
      <c:if test="${fn:contains(catLow,'util')}">     <c:set var="catClass" value="cat-util"/></c:if>
      <c:if test="${fn:contains(catLow,'entertain')}"><c:set var="catClass" value="cat-ent"/></c:if>
      <c:if test="${fn:contains(catLow,'edu')}">      <c:set var="catClass" value="cat-edu"/></c:if>
      <tr>
        <td class="id-cell">${i + 1}</td>
        <td><span class="cat-badge ${catClass}"><c:out value="${catName}"/></span></td>
        <td class="amount-cell">&#8377;<fmt:formatNumber value="${t.amount}" pattern="#,##0.00"/></td>
        <td class="merchant-cell">
          <c:choose>
            <c:when test="${not empty t.merchant_name}"><c:out value="${t.merchant_name}"/></c:when>
            <c:otherwise>&#8212;</c:otherwise>
          </c:choose>
        </td>
        <td class="date-cell">${t.transaction_date}</td>
      </tr>
    </c:forEach>
  </c:when>
  <c:otherwise>
    <tr><td colspan="5" class="no-data-cell">
      <div class="no-data-icon">&#128237;</div>
      <div style="font-size:16px;font-weight:700;color:var(--navy);margin-bottom:6px;">No Transactions Yet</div>
      <div style="font-size:14px;color:var(--muted);">Add your first transaction to start tracking spending.</div>
      <a href="AddTransactions" class="btn-add-link">+ Add Transaction</a>
    </td></tr>
  </c:otherwise>
</c:choose>
            </tbody>
        </table>

        <!-- Pagination bar — rendered by JS below the table, inside the card -->
        <div class="pagination-wrap" id="paginationWrap" style="display:none;">
            <div class="pagination-info" id="pageInfo"></div>
            <div class="pagination-controls" id="pageControls"></div>
        </div>
    </div>
</div>

<script>
/* ══════════════════════════════════════════════════════════════
   PAGINATION — 10 rows per page, newest first (row 1 = latest)
   • Rows are already rendered newest-first by the JSP above
   • Search filters rows then resets to page 1 automatically
   • If rows 1-10 are full → page 2 gets rows 11-20, etc.
══════════════════════════════════════════════════════════════ */
var ROWS_PER_PAGE = 10;
var currentPage   = 1;

/* All data rows (excludes the no-data placeholder row) */
function getAllDataRows() {
    return Array.from(document.querySelectorAll('#txnBody tr')).filter(function(r) {
        return !r.querySelector('.no-data-cell');
    });
}

/* Rows currently matching the search filter */
function getMatchedRows() {
    return getAllDataRows().filter(function(r) {
        return r.dataset.hidden !== 'true';
    });
}

/* Go to a specific page */
function renderPage(page) {
    currentPage = page;

    var matched    = getMatchedRows();
    var total      = matched.length;
    var totalPages = Math.max(1, Math.ceil(total / ROWS_PER_PAGE));

    /* Clamp page within valid range */
    if (currentPage < 1)          currentPage = 1;
    if (currentPage > totalPages) currentPage = totalPages;

    var start = (currentPage - 1) * ROWS_PER_PAGE; /* 0-based start index */
    var end   = start + ROWS_PER_PAGE;              /* exclusive end index */

    /* First hide ALL data rows, then reveal only this page's slice */
    getAllDataRows().forEach(function(r) { r.style.display = 'none'; });
    matched.forEach(function(r, i) {
        if (i >= start && i < end) r.style.display = '';
    });

    /* ── Info text: "Showing 1–10 of 45 transactions" ── */
    var from = total === 0 ? 0 : start + 1;
    var to   = Math.min(end, total);
    document.getElementById('pageInfo').textContent =
        'Showing ' + from + '\u2013' + to + ' of ' + total + ' transaction' + (total !== 1 ? 's' : '');

    /* ── Build pagination controls ── */
    var ctrl = document.getElementById('pageControls');
    ctrl.innerHTML = '';

    /* ← Prev */
    var prev = document.createElement('button');
    prev.className = 'pg-btn';
    prev.textContent = '\u2190';
    prev.disabled = (currentPage === 1);
    prev.onclick = (function(p){ return function(){ renderPage(p - 1); }; })(currentPage);
    ctrl.appendChild(prev);

    /* Page number buttons with smart … truncation */
    buildPageRange(currentPage, totalPages).forEach(function(p) {
        if (p === '\u2026') {
            var sep = document.createElement('span');
            sep.className = 'pg-sep';
            sep.textContent = '\u2026';
            ctrl.appendChild(sep);
        } else {
            var btn = document.createElement('button');
            btn.className = 'pg-btn' + (p === currentPage ? ' active' : '');
            btn.textContent = p;
            btn.onclick = (function(pg){ return function(){ renderPage(pg); }; })(p);
            ctrl.appendChild(btn);
        }
    });

    /* → Next */
    var next = document.createElement('button');
    next.className = 'pg-btn';
    next.textContent = '\u2192';
    next.disabled = (currentPage >= totalPages || total === 0);
    next.onclick = (function(p){ return function(){ renderPage(p + 1); }; })(currentPage);
    ctrl.appendChild(next);

    /* Show pagination bar only when there is more than one page */
    document.getElementById('paginationWrap').style.display =
        (total > ROWS_PER_PAGE) ? 'flex' : 'none';
}

/* Smart page range: always shows ≤7 items with … where needed */
function buildPageRange(cur, total) {
    if (total <= 7) {
        var a = [];
        for (var i = 1; i <= total; i++) a.push(i);
        return a;
    }
    if (cur <= 4)          return [1, 2, 3, 4, 5, '\u2026', total];
    if (cur >= total - 3)  return [1, '\u2026', total-4, total-3, total-2, total-1, total];
    return [1, '\u2026', cur-1, cur, cur+1, '\u2026', total];
}

/* Search — hide/show rows then reset to page 1 */
function filterTable() {
    var q = document.getElementById('searchInput').value.toLowerCase().trim();
    getAllDataRows().forEach(function(r) {
        var match = (q === '') || (r.textContent.toLowerCase().indexOf(q) > -1);
        r.dataset.hidden = match ? 'false' : 'true';
    });
    renderPage(1);
}

/* Initialise on page load — shows newest 10 first */
window.addEventListener('DOMContentLoaded', function() {
    getAllDataRows().forEach(function(r) { r.dataset.hidden = 'false'; });
    renderPage(1);
});
</script>
</body>
</html>
