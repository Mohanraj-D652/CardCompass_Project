<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Category Wise Spending – CardCompass</title>
<%@ include file="common-style.jsp" %>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
/* ════════════════════════════════════════════
   DESIGN TOKENS  (mirrors Dashboard exactly)
════════════════════════════════════════════ */
:root{
  --c-navy:       #0b1526;
  --c-navy-2:     #111e35;
  --c-blue:       #2563eb;
  --c-blue-lt:    #3b82f6;
  --c-green:      #16a34a;
  --c-green-lt:   #22c55e;
  --c-amber-lt:   #f59e0b;
  --c-red:        #dc2626;
  --c-red-lt:     #ef4444;
  --bg:           #f4f7fb;
  --surface:      #ffffff;
  --surface-2:    #f8fafc;
  --border:       #e2e8f3;
  --border-2:     #d0d9ea;
  --tx-1:         #0b1526;
  --tx-2:         #4a5c75;
  --tx-3:         #8496af;
  --sh-card:      0 1px 3px rgba(11,21,38,.05),0 4px 16px rgba(11,21,38,.06);
  --sh-float:     0 20px 64px rgba(11,21,38,.14),0 4px 16px rgba(11,21,38,.08);
}
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
html,body{width:100%;overflow-x:hidden;}
body{font-family:'Plus Jakarta Sans',sans-serif;background:var(--bg);color:var(--tx-1);min-height:100vh;-webkit-font-smoothing:antialiased;line-height:1.5;}
a{text-decoration:none;}

/* ════════════════════════════════════════════
   HEADER  —  brand TOP-LEFT · nav TOP-RIGHT
════════════════════════════════════════════ */
.hdr{
  position:sticky;top:0;z-index:500;
  width:100%;height:64px;
  background:var(--c-navy);
  border-bottom:1px solid rgba(255,255,255,.07);
  box-shadow:0 2px 24px rgba(0,0,0,.32);
  display:flex;align-items:center;
}
/* hdr-inner: NO max-width, NO margin auto — full width with padding only */
.hdr-inner{
  width:100%;
  padding:0 32px;
  display:flex;
  align-items:center;
  justify-content:space-between;
}
/* Brand — far LEFT */
.hdr-brand{
  display:flex;align-items:center;gap:10px;
  flex-shrink:0;text-decoration:none;
}
.hdr-logo{
  width:36px;height:36px;border-radius:9px;
  background:linear-gradient(135deg,var(--c-blue-lt),var(--c-green-lt));
  display:flex;align-items:center;justify-content:center;font-size:17px;
  box-shadow:0 0 0 1px rgba(255,255,255,.12),0 2px 10px rgba(37,99,235,.4);
}
.hdr-name{font-size:16px;font-weight:800;color:#fff;letter-spacing:-.3px;}
.hdr-name span{color:var(--c-green-lt);}
/* Nav — far RIGHT */
.hdr-nav{display:flex;align-items:center;gap:4px;flex-shrink:0;}
.nav-a{
  padding:7px 12px;border-radius:8px;
  font-size:13px;font-weight:500;
  color:rgba(255,255,255,.55);
  border:1.5px solid transparent;
  transition:color .18s,background .18s;
  white-space:nowrap;line-height:1;
}
.nav-a:hover{color:#fff;background:rgba(255,255,255,.07);}
.nav-a.active{color:#fff;background:rgba(37,99,235,.22);border-color:rgba(59,130,246,.35);}
.hdr-sep{width:1px;height:20px;background:rgba(255,255,255,.12);margin:0 6px;flex-shrink:0;}
.nav-a.add-btn{
  background:var(--c-green-lt);color:#fff!important;
  font-weight:700;border:none!important;
  box-shadow:0 2px 12px rgba(34,197,94,.4);
  padding:8px 16px;
}
.nav-a.add-btn:hover{background:var(--c-green);box-shadow:0 4px 20px rgba(34,197,94,.5);transform:translateY(-1px);}
.nav-a.logout{color:#f87171!important;}
.nav-a.logout:hover{background:rgba(239,68,68,.1)!important;color:#fca5a5!important;}

/* ════════════════════════════════════════════
   PAGE SHELL
════════════════════════════════════════════ */
.page{
  max-width:1100px;margin:0 auto;
  padding:40px 32px;
  display:flex;flex-direction:column;gap:24px;
}

/* ════════════════════════════════════════════
   PAGE HEADER BLOCK
════════════════════════════════════════════ */
.page-hdr{display:flex;align-items:flex-start;flex-wrap:wrap;gap:16px;}
.page-eyebrow{
  font-size:11px;font-weight:700;letter-spacing:1.4px;
  text-transform:uppercase;color:var(--c-blue-lt);margin-bottom:8px;
}
.page-title{font-size:26px;font-weight:800;color:var(--tx-1);letter-spacing:-.4px;margin-bottom:5px;}
.page-sub{font-size:14px;color:var(--tx-2);}
.page-hdr-right{display:flex;gap:10px;flex-wrap:wrap;align-items:center;}

/* Buttons */
.btn{
  display:inline-flex;align-items:center;gap:7px;
  padding:10px 20px;border-radius:9px;
  font-size:13.5px;font-weight:700;
  font-family:'Plus Jakarta Sans',sans-serif;
  cursor:pointer;border:none;transition:all .2s;white-space:nowrap;
}
.btn-ghost{background:var(--surface);color:var(--tx-1);border:1.5px solid var(--border);}
.btn-ghost:hover{border-color:var(--c-blue-lt);color:var(--c-blue-lt);background:#f0f7ff;}
.btn-solid{background:var(--c-blue-lt);color:#fff;box-shadow:0 2px 12px rgba(59,130,246,.3);}
.btn-solid:hover{background:var(--c-blue);box-shadow:0 4px 20px rgba(59,130,246,.4);transform:translateY(-1px);}

/* ════════════════════════════════════════════
   ALERT BANNER  —  full width, structured
════════════════════════════════════════════ */
.alert-banner{
  display:flex;align-items:center;gap:16px;
  background:#fffbeb;
  border:1px solid #fde68a;border-left:4px solid var(--c-amber-lt);
  border-radius:12px;padding:16px 20px;
  box-shadow:0 2px 8px rgba(245,158,11,.06);
  width:100%;
}
.alert-icon{
  width:38px;height:38px;border-radius:10px;
  background:rgba(245,158,11,.12);
  display:flex;align-items:center;justify-content:center;
  font-size:18px;flex-shrink:0;
}
.alert-body{flex:1;}
.alert-title{font-size:13.5px;font-weight:700;color:#92400e;margin-bottom:3px;}
.alert-desc{font-size:12.5px;color:#78350f;line-height:1.55;}

/* ════════════════════════════════════════════
   TABLE CARD
════════════════════════════════════════════ */
.tcard{
  background:var(--surface);
  border:1px solid var(--border);
  border-radius:16px;
  box-shadow:var(--sh-card);
  overflow:hidden;
}

/* ── Table header ── */
.thead{
  display:grid;
  /* col widths: Category | Status | Spending Share (flex) | Amount */
  grid-template-columns: 220px 160px 1fr 160px;
  align-items:center;
  gap:0;
  background:var(--surface-2);
  border-bottom:2px solid var(--border);
  padding:0;
}
.th-cell{
  padding:14px 20px;
  font-size:10.5px;font-weight:700;
  color:var(--tx-3);text-transform:uppercase;letter-spacing:.9px;
}
.th-cell.right{text-align:right;}

/* ── Data rows ── */
.tbody{display:flex;flex-direction:column;}

.trow{
  display:grid;
  grid-template-columns: 220px 160px 1fr 160px;
  align-items:center;gap:0;
  border-bottom:1px solid var(--surface-2);
  transition:background .15s;
  position:relative;
}
.trow:last-child{border-bottom:none;}

/* Normal row */
.trow.normal:hover{background:#fafbfd;}

/* Highest row */
.trow.highest{
  background:linear-gradient(90deg,#fff5f5,#fff8f8);
  border-left:3px solid var(--c-red-lt);
  border-bottom:1px solid #fee2e2;
}
.trow.highest::after{
  content:'';position:absolute;top:0;right:0;bottom:0;width:3px;
  background:linear-gradient(180deg,var(--c-red-lt),var(--c-amber-lt));
}

/* ── Cells ── */
.tcell{padding:18px 20px;}
.tcell.right{text-align:right;}

/* Category pill */
.cat-pill{
  display:inline-flex;align-items:center;gap:7px;
  padding:6px 14px;border-radius:24px;
  font-size:13px;font-weight:600;
}
.cat-pill.n{background:rgba(37,99,235,.07);color:#1d4ed8;border:1px solid rgba(37,99,235,.14);}
.cat-pill.h{background:rgba(239,68,68,.09);color:#b91c1c;border:1px solid rgba(239,68,68,.22);}
.pill-dot{width:7px;height:7px;border-radius:50%;background:var(--c-red-lt);box-shadow:0 0 5px var(--c-red-lt);flex-shrink:0;}

/* Status */
.st-dash{color:var(--tx-3);font-size:16px;font-weight:300;}
.st-badge{
  display:inline-flex;align-items:center;gap:5px;
  padding:5px 12px;border-radius:20px;
  font-size:11.5px;font-weight:700;
  background:rgba(239,68,68,.08);color:#b91c1c;
  border:1px solid rgba(239,68,68,.18);
}

/* Progress bar */
.bar-wrap{display:flex;align-items:center;gap:10px;}
.bar-track{
  flex:1;height:8px;border-radius:20px;overflow:hidden;
  background:#eaeff6;min-width:60px;
}
.bar-track.h{height:9px;background:#fecaca;}
.bar-fill{height:100%;border-radius:20px;}
.bar-fill.n{background:linear-gradient(90deg,var(--c-blue-lt),var(--c-green-lt));}
.bar-fill.h{background:linear-gradient(90deg,var(--c-red-lt),var(--c-amber-lt));}
.bar-pct{
  font-size:12px;font-weight:600;
  min-width:38px;text-align:right;flex-shrink:0;
}
.bar-pct.n{color:var(--tx-2);}
.bar-pct.h{color:#b91c1c;font-weight:700;}

/* Amount */
.amt{font-size:15px;font-weight:700;}
.amt.n{color:#15803d;}
.amt.h{color:var(--c-red-lt);font-weight:800;font-size:16px;}

/* ── Empty state ── */
.empty{
  display:flex;flex-direction:column;align-items:center;
  padding:72px 24px;gap:10px;
}
.empty-ico{font-size:48px;}
.empty-t{font-size:17px;font-weight:800;color:var(--tx-1);}
.empty-d{font-size:13.5px;color:var(--tx-2);}

/* ════════════════════════════════════════════
   RESPONSIVE
════════════════════════════════════════════ */
@media(max-width:900px){
  .thead,.trow{grid-template-columns:180px 140px 1fr 140px;}
}
@media(max-width:768px){
  .hdr-inner{padding:0 20px;gap:16px;}
  .hdr-nav{display:none;}
  .page{padding:24px 16px;gap:20px;}
  .thead,.trow{grid-template-columns:1fr 100px 1fr 120px;}
  .th-cell:nth-child(2),.tcell:nth-child(2){display:none;}
  .thead,.trow{grid-template-columns:1fr 1fr 120px;}
}
@media(max-width:540px){
  .thead,.trow{grid-template-columns:1fr 1fr;}
  .th-cell:nth-child(3),.tcell:nth-child(3){display:none;}
  .page-hdr{flex-direction:column;align-items:flex-start;}
}
</style>
</head>
<body>

<!-- ════ HEADER ════ -->
<header class="hdr">
  <div class="hdr-inner">

    <a href="dashboard" class="hdr-brand">
      <div class="hdr-logo">&#128179;</div>
      <span class="hdr-name">Card<span>Compass</span></span>
    </a>

    <nav class="hdr-nav">
      <a href="dashboard"            class="nav-a">Dashboard</a>
      <a href="TransactionHistory"   class="nav-a">History</a>
      <a href="CatagerywiseSpending" class="nav-a active">Category</a>
      <a href="CardWiseSpending"     class="nav-a">By Card</a>
      <a href="ViewReport"           class="nav-a">Reports</a>
      <div class="hdr-sep"></div>
      <a href="AddTransactions"      class="nav-a add-btn">+ Transaction</a>
      <a href="Logout"               class="nav-a logout">Logout</a>
    </nav>

  </div>
</header>

<!-- ════ PAGE ════ -->
<main class="page">

  <!-- Page header -->
  <div class="page-hdr">
    <div class="page-hdr-left">
      <div class="page-eyebrow">Spending Analysis</div>
      <div class="page-title">Category Wise Spending</div>
      <div class="page-sub">See where you spend the most across all your cards.</div>
    </div>
  </div>

  <!-- Alert -->
  <div class="alert-banner">
    <div class="alert-icon">&#9888;&#65039;</div>
    <div class="alert-body">
      <div class="alert-title">Highest Spend Alert</div>
      <div class="alert-desc">The category with the highest total spending is highlighted in red and pinned to the top of the list.</div>
    </div>
  </div>

  <!-- Table -->
  <div class="tcard">

    <!-- Header row -->
    <div class="thead">
      <div class="th-cell">Category</div>
      <div class="th-cell">Status</div>
      <div class="th-cell">Spending Share</div>
      <div class="th-cell right">Total Amount</div>
    </div>

    <!-- Body -->
    <div class="tbody">
      <c:choose>
        <c:when test="${not empty spending}">

          <%-- PASS 1 — highest row first --%>
          <c:forEach var="row" items="${spending}">
            <c:set var="diff" value="${row.total_amount - maxTotal}"/>
            <c:set var="isH"  value="${diff > -0.001 and diff < 0.001 and maxTotal > 0}"/>
            <c:set var="pct"  value="${maxTotal > 0 ? (row.total_amount * 100 / maxTotal) : 0}"/>
            <c:if test="${isH}">
              <div class="trow highest">
                <div class="tcell">
                  <span class="cat-pill h">
                    <span class="pill-dot"></span>
                    <c:out value="${row.category_name}"/>
                  </span>
                </div>
                <div class="tcell"><span class="st-badge">&#9888; Highest Spend</span></div>
                <div class="tcell">
                  <div class="bar-wrap">
                    <div class="bar-track h"><div class="bar-fill h" style="width:<c:out value='${pct}'/>%"></div></div>
                    <span class="bar-pct h"><fmt:formatNumber value="${pct}" pattern="0"/>%</span>
                  </div>
                </div>
                <div class="tcell right">
                  <span class="amt h">&#8377;<fmt:formatNumber value="${row.total_amount}" pattern="#,##0.00"/></span>
                </div>
              </div>
            </c:if>
          </c:forEach>

          <%-- PASS 2 — all other rows --%>
          <c:forEach var="row" items="${spending}">
            <c:set var="diff" value="${row.total_amount - maxTotal}"/>
            <c:set var="isH"  value="${diff > -0.001 and diff < 0.001 and maxTotal > 0}"/>
            <c:set var="pct"  value="${maxTotal > 0 ? (row.total_amount * 100 / maxTotal) : 0}"/>
            <c:if test="${!isH}">
              <div class="trow normal">
                <div class="tcell"><span class="cat-pill n"><c:out value="${row.category_name}"/></span></div>
                <div class="tcell"><span class="st-dash">&#8212;</span></div>
                <div class="tcell">
                  <div class="bar-wrap">
                    <div class="bar-track"><div class="bar-fill n" style="width:<c:out value='${pct}'/>%"></div></div>
                    <span class="bar-pct n"><fmt:formatNumber value="${pct}" pattern="0"/>%</span>
                  </div>
                </div>
                <div class="tcell right">
                  <span class="amt n">&#8377;<fmt:formatNumber value="${row.total_amount}" pattern="#,##0.00"/></span>
                </div>
              </div>
            </c:if>
          </c:forEach>

        </c:when>
        <c:otherwise>
          <div class="empty">
            <div class="empty-ico">&#128202;</div>
            <div class="empty-t">No spending data yet</div>
            <div class="empty-d">Add transactions to see your category-wise analysis.</div>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <!-- Bottom actions — single set of buttons -->
  <div style="display:flex;gap:10px;flex-wrap:wrap;">
    <a href="ViewReport"       class="btn btn-ghost">&#8592; Back to Reports</a>
    <a href="CardWiseSpending" class="btn btn-ghost">&#128179; Card Wise</a>
    <a href="dashboard"        class="btn btn-solid">&#127968; Dashboard</a>
  </div>

</main>
</body>
</html>
