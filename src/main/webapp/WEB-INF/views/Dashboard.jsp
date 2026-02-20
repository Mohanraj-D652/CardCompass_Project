<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
  <title>Dashboard – CardCompass</title>
  <%@ include file="common-style.jsp" %>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
/* ════════════════════════════════════════════════
   DESIGN SYSTEM
════════════════════════════════════════════════ */
:root {
  --c-navy:        #0b1526;
  --c-navy-2:      #111e35;
  --c-navy-3:      #1a2d4a;
  --c-blue:        #2563eb;
  --c-blue-lt:     #3b82f6;
  --c-blue-faint:  rgba(37,99,235,.08);
  --c-green:       #16a34a;
  --c-green-lt:    #22c55e;
  --c-green-faint: rgba(22,163,74,.08);
  --c-amber:       #d97706;
  --c-amber-lt:    #f59e0b;
  --c-amber-faint: rgba(217,119,6,.08);
  --c-red:         #dc2626;
  --c-red-lt:      #ef4444;
  --c-red-faint:   rgba(220,38,38,.08);
  --c-purple:      #7c3aed;
  --c-purple-lt:   #a855f7;
  --c-purple-faint:rgba(124,58,237,.08);

  --bg:        #f4f7fb;
  --surface:   #ffffff;
  --surface-2: #f8fafc;
  --border:    #e2e8f3;
  --border-2:  #d0d9ea;

  --tx-1: #0b1526;
  --tx-2: #4a5c75;
  --tx-3: #8496af;

  --sh-card:   0 1px 3px rgba(11,21,38,.05), 0 4px 16px rgba(11,21,38,.06);
  --sh-lifted: 0 8px 32px rgba(11,21,38,.10), 0 2px 8px rgba(11,21,38,.06);
  --sh-float:  0 20px 64px rgba(11,21,38,.14), 0 4px 16px rgba(11,21,38,.08);
}

*, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }
html, body { width:100%; overflow-x:hidden; }
body {
  font-family: 'Plus Jakarta Sans', sans-serif;
  background: var(--bg);
  color: var(--tx-1);
  min-height: 100vh;
  -webkit-font-smoothing: antialiased;
  line-height: 1.5;
}
a { text-decoration: none; }

/* ════════════════════════════════════════════════
   HEADER  —  brand TOP-LEFT · nav TOP-RIGHT
════════════════════════════════════════════════ */
.hdr {
  position: sticky; top: 0; z-index: 500;
  width: 100%; height: 64px;
  background: var(--c-navy);
  border-bottom: 1px solid rgba(255,255,255,.07);
  box-shadow: 0 2px 24px rgba(0,0,0,.32);
  display: flex; align-items: center;
}
.hdr-inner {
  width: 100%;
  padding: 0 32px;
  display: flex;
  align-items: center;
  justify-content: space-between;  /* ← brand LEFT edge, nav RIGHT edge */
}
/* ── Brand: sticks to LEFT ── */
.hdr-brand {
  display: flex; align-items: center; gap: 10px;
  flex-shrink: 0;
  text-decoration: none;
}
.hdr-logo {
  width: 36px; height: 36px; border-radius: 9px;
  background: linear-gradient(135deg, var(--c-blue-lt), var(--c-green-lt));
  display: flex; align-items: center; justify-content: center;
  font-size: 17px;
  box-shadow: 0 0 0 1px rgba(255,255,255,.12), 0 2px 10px rgba(37,99,235,.4);
}
.hdr-brand-name {
  font-size: 16px; font-weight: 800; color: #fff; letter-spacing: -.3px;
}
.hdr-brand-name span { color: var(--c-green-lt); }

/* ── Nav: sticks to RIGHT ── */
.hdr-nav {
  display: flex; align-items: center;
  gap: 4px;
  flex-shrink: 0;
}
.nav-a {
  padding: 7px 12px; border-radius: 8px;
  font-size: 13px; font-weight: 500;
  color: rgba(255,255,255,.55);
  border: 1.5px solid transparent;
  transition: color .18s, background .18s;
  white-space: nowrap; line-height: 1;
}
.nav-a:hover  { color: #fff; background: rgba(255,255,255,.07); }
.nav-a.active { color: #fff; background: rgba(37,99,235,.22); border-color: rgba(59,130,246,.35); }
.hdr-sep { width: 1px; height: 20px; background: rgba(255,255,255,.12); margin: 0 6px; flex-shrink: 0; }
.nav-a.add-btn {
  background: var(--c-green-lt); color: #fff !important;
  font-weight: 700; border: none !important;
  box-shadow: 0 2px 12px rgba(34,197,94,.4);
  padding: 8px 16px;
}
.nav-a.add-btn:hover {
  background: var(--c-green);
  box-shadow: 0 4px 20px rgba(34,197,94,.5);
  transform: translateY(-1px);
}
.nav-a.logout { color: #f87171 !important; }
.nav-a.logout:hover { background: rgba(239,68,68,.1) !important; color:#fca5a5 !important; }

/* ════════════════════════════════════════════════
   PAGE SHELL
════════════════════════════════════════════════ */
.page {
  max-width: 1320px; margin: 0 auto;
  padding: 40px 32px;               /* matches hdr-inner padding exactly */
  display: flex; flex-direction: column; gap: 32px;
}

/* ════════════════════════════════════════════════
   HERO BANNER
════════════════════════════════════════════════ */
.hero {
  position: relative; overflow: hidden;
  background: var(--c-navy);
  border-radius: 20px;
  padding: 40px 48px;
  display: flex; align-items: center;
  justify-content: space-between; gap: 24px;
  flex-wrap: wrap;
  border: 1px solid rgba(255,255,255,.06);
  box-shadow: var(--sh-float);
}
.hero::before {
  content: ''; position: absolute; inset: 0; pointer-events: none;
  background-image:
    linear-gradient(rgba(255,255,255,.028) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255,255,255,.028) 1px, transparent 1px);
  background-size: 48px 48px;
}
.hero-orb {
  position: absolute; border-radius: 50%; pointer-events: none;
}
.hero-orb-1 {
  width: 380px; height: 380px; top: -110px; right: -70px;
  background: radial-gradient(circle, rgba(37,99,235,.22) 0%, transparent 65%);
}
.hero-orb-2 {
  width: 280px; height: 280px; bottom: -110px; left: 240px;
  background: radial-gradient(circle, rgba(22,163,74,.13) 0%, transparent 65%);
}
.hero-left { position: relative; z-index: 2; }
.hero-tag {
  display: inline-flex; align-items: center; gap: 7px;
  padding: 4px 12px; border-radius: 20px;
  background: rgba(34,197,94,.1); border: 1px solid rgba(34,197,94,.2);
  font-size: 11px; font-weight: 700; color: var(--c-green-lt);
  letter-spacing: .9px; text-transform: uppercase;
  margin-bottom: 14px;
}
.hero-dot { width: 6px; height: 6px; border-radius: 50%; background: var(--c-green-lt); animation: blink 2s infinite; }
@keyframes blink { 0%,100%{opacity:1} 50%{opacity:.25} }
.hero-title {
  font-size: 30px; font-weight: 800; color: #fff;
  letter-spacing: -.5px; line-height: 1.2; margin-bottom: 8px;
}
.hero-sub { font-size: 14px; color: rgba(255,255,255,.48); font-weight: 400; }
.hero-right { position: relative; z-index: 2; display: flex; gap: 12px; flex-wrap: wrap; }
.btn {
  display: inline-flex; align-items: center; gap: 7px;
  padding: 12px 22px; border-radius: 10px;
  font-size: 14px; font-weight: 700;
  font-family: 'Plus Jakarta Sans', sans-serif;
  cursor: pointer; border: none; transition: all .2s;
  white-space: nowrap;
}
.btn-green {
  background: var(--c-green-lt); color: #fff;
  box-shadow: 0 2px 14px rgba(34,197,94,.35);
}
.btn-green:hover { background: var(--c-green); transform: translateY(-1px); box-shadow: 0 6px 24px rgba(34,197,94,.45); }
.btn-ghost-w {
  background: rgba(255,255,255,.08); color: rgba(255,255,255,.88);
  border: 1.5px solid rgba(255,255,255,.16);
}
.btn-ghost-w:hover { background: rgba(255,255,255,.14); }

/* ════════════════════════════════════════════════
   SECTION HEADING
════════════════════════════════════════════════ */
.sec-head { display: flex; align-items: center; gap: 12px; margin-bottom: 18px; }
.sec-title {
  font-size: 10.5px; font-weight: 700; color: var(--tx-3);
  text-transform: uppercase; letter-spacing: 1.4px; white-space: nowrap;
}
.sec-rule { flex: 1; height: 1px; background: var(--border); }

/* ════════════════════════════════════════════════
   STAT CARDS  —  strict 4-column equal grid
════════════════════════════════════════════════ */
.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}
.scard {
  position: relative; overflow: hidden;
  border-radius: 16px;
  padding: 24px 24px 20px;
  background: var(--c-navy-2);
  border: 1px solid rgba(255,255,255,.06);
  box-shadow: 0 4px 20px rgba(0,0,0,.28), inset 0 1px 0 rgba(255,255,255,.05);
  transition: transform .28s cubic-bezier(.34,1.56,.64,1), box-shadow .28s;
  display: flex; flex-direction: column;
  min-height: 188px;
}
.scard:hover {
  transform: translateY(-4px);
  box-shadow: 0 0 0 1.5px var(--a-neon), 0 16px 48px rgba(0,0,0,.36), 0 0 48px -8px var(--a-glow);
}
/* Ambient glow */
.scard::before {
  content: ''; position: absolute; inset: 0; pointer-events: none;
  background: radial-gradient(ellipse at 85% 15%, var(--a-glow) 0%, transparent 55%);
  opacity: .2; transition: opacity .28s;
}
.scard:hover::before { opacity: .42; }
/* Top accent line */
.scard::after {
  content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px;
  background: linear-gradient(90deg, transparent, var(--a-mid) 50%, transparent);
  border-radius: 16px 16px 0 0;
}

/* Colour tokens per card */
.scard.c-blue   { --a-neon:rgba(59,130,246,.5);  --a-glow:rgba(59,130,246,.28);  --a-mid:#3b82f6; --a-acc:#60a5fa; }
.scard.c-green  { --a-neon:rgba(34,197,94,.5);   --a-glow:rgba(34,197,94,.28);   --a-mid:#22c55e; --a-acc:#4ade80; }
.scard.c-amber  { --a-neon:rgba(245,158,11,.5);  --a-glow:rgba(245,158,11,.28);  --a-mid:#f59e0b; --a-acc:#fbbf24; }
.scard.c-red    { --a-neon:rgba(239,68,68,.5);   --a-glow:rgba(239,68,68,.28);   --a-mid:#ef4444; --a-acc:#f87171; }

.scard-top {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 20px; position: relative; z-index: 2;
}
.scard-label {
  font-size: 10.5px; font-weight: 700; letter-spacing: 1.1px;
  text-transform: uppercase; color: rgba(255,255,255,.38);
}
.scard-icon {
  width: 36px; height: 36px; border-radius: 9px;
  background: rgba(255,255,255,.06);
  border: 1px solid rgba(255,255,255,.07);
  display: flex; align-items: center; justify-content: center;
  font-size: 17px;
}
.scard-body { position: relative; z-index: 2; flex: 1; }
.scard-val  {
  font-size: 38px; font-weight: 800; color: #fff;
  letter-spacing: -2px; line-height: 1; margin-bottom: 5px;
}
.scard-desc { font-size: 12px; color: rgba(255,255,255,.34); }
.scard-foot {
  margin-top: 20px; padding-top: 14px;
  border-top: 1px solid rgba(255,255,255,.07);
  display: flex; align-items: center; justify-content: space-between;
  position: relative; z-index: 2;
}
.scard-link {
  display: inline-flex; align-items: center; gap: 5px;
  font-size: 12px; font-weight: 600; color: var(--a-acc);
  transition: gap .18s;
}
.scard-link:hover { gap: 9px; }
.scard-link svg  { width: 13px; height: 13px; }
.scard-dot {
  width: 7px; height: 7px; border-radius: 50%;
  background: var(--a-acc); box-shadow: 0 0 8px 2px var(--a-glow);
  animation: beat 2s ease-in-out infinite;
}
@keyframes beat { 0%,100%{transform:scale(1);opacity:1} 50%{transform:scale(1.8);opacity:.3} }

/* ════════════════════════════════════════════════
   BOTTOM GRID  —  Quick Nav + Tips side-by-side
════════════════════════════════════════════════ */
.bottom-grid {
  display: grid;
  grid-template-columns: 1fr 360px;
  gap: 24px;
  align-items: start;
}

/* ── Panel shell ── */
.panel {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 20px;
  padding: 28px;
  box-shadow: var(--sh-card);
}
.panel-head { margin-bottom: 20px; }
.panel-title { font-size: 15px; font-weight: 800; color: var(--tx-1); margin-bottom: 4px; }
.panel-sub   { font-size: 12.5px; color: var(--tx-2); }

/* ── Quick nav grid ── */
.qgrid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}
.qitem {
  display: flex; flex-direction: column; align-items: center; gap: 9px;
  padding: 20px 12px;
  background: var(--surface-2);
  border: 1.5px solid var(--border);
  border-radius: 14px;
  transition: border-color .2s, box-shadow .2s, transform .2s, background .2s;
}
.qitem:hover {
  background: var(--surface);
  border-color: var(--c-blue-lt);
  box-shadow: 0 4px 20px rgba(37,99,235,.10);
  transform: translateY(-2px);
}
.qicon {
  width: 44px; height: 44px; border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  font-size: 20px;
}
.qi-b { background: var(--c-blue-faint); }
.qi-g { background: var(--c-green-faint); }
.qi-a { background: var(--c-amber-faint); }
.qi-r { background: var(--c-red-faint); }
.qi-p { background: var(--c-purple-faint); }
.qi-n { background: rgba(11,21,38,.06); }
.qlabel { font-size: 12.5px; font-weight: 600; color: var(--tx-1); text-align: center; line-height: 1.3; }

/* ── Tips panel ── */
.tips-panel {
  display: flex; flex-direction: column; gap: 10px;
}
.tip-row {
  display: flex; align-items: flex-start; gap: 14px;
  padding: 16px;
  background: var(--surface-2);
  border: 1px solid var(--border);
  border-radius: 14px;
  transition: border-color .2s, box-shadow .2s;
}
.tip-row:hover { border-color: var(--border-2); box-shadow: var(--sh-card); }
.tip-ico {
  width: 36px; height: 36px; border-radius: 10px;
  display: flex; align-items: center; justify-content: center;
  font-size: 17px; flex-shrink: 0;
}
.tip-t { font-size: 13px; font-weight: 700; color: var(--tx-1); margin-bottom: 3px; }
.tip-d { font-size: 12px; color: var(--tx-2); line-height: 1.5; }

/* ════════════════════════════════════════════════
   REPORT STRIP
════════════════════════════════════════════════ */
.rbanner {
  background: var(--c-navy-2);
  border: 1px solid rgba(255,255,255,.06);
  border-radius: 20px;
  padding: 28px 48px;
  display: flex; align-items: center;
  justify-content: space-between; gap: 24px; flex-wrap: wrap;
  box-shadow: 0 4px 24px rgba(0,0,0,.2);
  position: relative; overflow: hidden;
}
.rbanner::before {
  content: ''; position: absolute; right: -40px; top: 50%; transform: translateY(-50%);
  width: 260px; height: 260px; border-radius: 50%; pointer-events: none;
  background: radial-gradient(circle, rgba(37,99,235,.18) 0%, transparent 65%);
}
.rb-left { position: relative; z-index: 2; }
.rb-title { font-size: 16px; font-weight: 800; color: #fff; margin-bottom: 4px; }
.rb-sub   { font-size: 13px; color: rgba(255,255,255,.48); }
.rb-btns  { position: relative; z-index: 2; display: flex; gap: 12px; flex-wrap: wrap; }
.btn-blue {
  background: var(--c-blue-lt); color: #fff;
  box-shadow: 0 2px 12px rgba(59,130,246,.35);
}
.btn-blue:hover { background: var(--c-blue); transform: translateY(-1px); box-shadow: 0 6px 24px rgba(59,130,246,.45); }
.btn-ghost-dark {
  background: rgba(255,255,255,.07); color: rgba(255,255,255,.8);
  border: 1.5px solid rgba(255,255,255,.14);
}
.btn-ghost-dark:hover { background: rgba(255,255,255,.12); }

/* ════════════════════════════════════════════════
   RESPONSIVE
════════════════════════════════════════════════ */
@media (max-width: 1200px) {
  .hdr-inner    { padding: 0 20px; }
  .nav-a        { padding: 6px 9px; font-size: 12.5px; }
  .nav-a.add-btn{ padding: 7px 12px; }
}
@media (max-width: 1100px) {
  .stat-grid    { grid-template-columns: repeat(2, 1fr); }
  .bottom-grid  { grid-template-columns: 1fr; }
  .tips-panel   { flex-direction: row; flex-wrap: wrap; }
  .tip-row      { flex: 1 1 calc(50% - 8px); }
}
@media (max-width: 768px) {
  .hdr-inner    { padding: 0 16px; }
  .hdr-nav      { display: none; }
  .page         { padding: 24px 16px; gap: 24px; }
  .hero         { padding: 28px 24px; }
  .hero-title   { font-size: 22px; }
  .stat-grid    { grid-template-columns: 1fr 1fr; gap: 12px; }
  .qgrid        { grid-template-columns: repeat(2, 1fr); }
  .rbanner      { padding: 24px 24px; }
  .tip-row      { flex: 1 1 100%; }
}
@media (max-width: 480px) {
  .stat-grid { grid-template-columns: 1fr; }
}
</style>
</head>
<body>

<!-- ════ HEADER ════ -->
<header class="hdr">
  <div class="hdr-inner">

    <a href="dashboard" class="hdr-brand">
      <div class="hdr-logo">💳</div>
      <span class="hdr-brand-name">Card<span>Compass</span></span>
    </a>

    <nav class="hdr-nav">
      <a href="dashboard"          class="nav-a active">Dashboard</a>
      <a href="Mycards"            class="nav-a">My Cards</a>
      <a href="AddCreditCard"      class="nav-a">Add Card</a>
      <a href="TransactionHistory" class="nav-a">History</a>
      <a href="ViewReport"         class="nav-a">Reports</a>
      <div class="hdr-sep"></div>
      <a href="AddTransactions"    class="nav-a add-btn">+ Add Transaction</a>
      <a href="MonthlyReport"      class="nav-a">Send PDF 📧</a>
      <a href="Logout"             class="nav-a logout">Logout</a>
    </nav>

  </div>
</header>

<!-- ════ PAGE ════ -->
<main class="page">

  <!-- 1 · HERO -->
  <section class="hero">
    <div class="hero-orb hero-orb-1"></div>
    <div class="hero-orb hero-orb-2"></div>

    <div class="hero-left">
      <div class="hero-tag">
        <span class="hero-dot"></span>
        CardCompass · Live Overview
      </div>
      <div class="hero-title">Welcome Back 👋</div>
      <div class="hero-sub">Your complete credit card spending command centre.</div>
    </div>

    <div class="hero-right">
      <a href="AddTransactions" class="btn btn-green">＋ New Transaction</a>
      <a href="ViewReport"      class="btn btn-ghost-w">📊 View Reports</a>
    </div>
  </section>

  <!-- 2 · STAT CARDS -->
  <div>
    <div class="sec-head">
      <span class="sec-title">At a Glance</span>
      <div class="sec-rule"></div>
    </div>
    <div class="stat-grid">

      <div class="scard c-blue">
        <div class="scard-top">
          <span class="scard-label">My Cards</span>
          <div class="scard-icon">💳</div>
        </div>
        <div class="scard-body">
          <div class="scard-val">—</div>
          <div class="scard-desc">Active credit cards</div>
        </div>
        <div class="scard-foot">
          <a href="Mycards" class="scard-link">
            View all cards
            <svg fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
          </a>
          <span class="scard-dot"></span>
        </div>
      </div>

      <div class="scard c-green">
        <div class="scard-top">
          <span class="scard-label">Transactions</span>
          <div class="scard-icon">📊</div>
        </div>
        <div class="scard-body">
          <div class="scard-val">—</div>
          <div class="scard-desc">Total recorded entries</div>
        </div>
        <div class="scard-foot">
          <a href="TransactionHistory" class="scard-link">
            View history
            <svg fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
          </a>
          <span class="scard-dot"></span>
        </div>
      </div>

      <div class="scard c-amber">
        <div class="scard-top">
          <span class="scard-label">Category Spend</span>
          <div class="scard-icon">🏷️</div>
        </div>
        <div class="scard-body">
          <div class="scard-val">—</div>
          <div class="scard-desc">Spending by category</div>
        </div>
        <div class="scard-foot">
          <a href="CatagerywiseSpending" class="scard-link">
            View breakdown
            <svg fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
          </a>
          <span class="scard-dot"></span>
        </div>
      </div>

      <div class="scard c-red">
        <div class="scard-top">
          <span class="scard-label">Reports</span>
          <div class="scard-icon">📄</div>
        </div>
        <div class="scard-body">
          <div class="scard-val">—</div>
          <div class="scard-desc">Monthly summaries</div>
        </div>
        <div class="scard-foot">
          <a href="ViewReport" class="scard-link">
            View reports
            <svg fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
          </a>
          <span class="scard-dot"></span>
        </div>
      </div>

    </div>
  </div>

  <!-- 3 · BOTTOM GRID -->
  <div class="bottom-grid">

    <!-- Quick Navigation -->
    <div class="panel">
      <div class="panel-head">
        <div class="panel-title">Quick Navigation</div>
        <div class="panel-sub">Jump to any section instantly</div>
      </div>
      <div class="qgrid">
        <a href="Mycards"              class="qitem"><div class="qicon qi-b">💳</div><span class="qlabel">My Cards</span></a>
        <a href="AddTransactions"      class="qitem"><div class="qicon qi-g">➕</div><span class="qlabel">Add Transaction</span></a>
        <a href="TransactionHistory"   class="qitem"><div class="qicon qi-a">📋</div><span class="qlabel">History</span></a>
        <a href="CatagerywiseSpending" class="qitem"><div class="qicon qi-p">📊</div><span class="qlabel">Category Spend</span></a>
        <a href="CardWiseSpending"     class="qitem"><div class="qicon qi-r">📈</div><span class="qlabel">Card Spend</span></a>
        <a href="ViewReport"           class="qitem"><div class="qicon qi-n">📄</div><span class="qlabel">Reports</span></a>
      </div>
    </div>

    <!-- Tips -->
    <div class="panel">
      <div class="panel-head">
        <div class="panel-title">Tips &amp; Shortcuts</div>
        <div class="panel-sub">Make the most of CardCompass</div>
      </div>
      <div class="tips-panel">
        <div class="tip-row">
          <div class="tip-ico qi-p">📊</div>
          <div>
            <div class="tip-t">Category Insights</div>
            <div class="tip-d">See which spending categories drain your budget the most.</div>
          </div>
        </div>
        <div class="tip-row">
          <div class="tip-ico qi-b">💳</div>
          <div>
            <div class="tip-t">Card Comparison</div>
            <div class="tip-d">Compare total spend across all your credit cards at once.</div>
          </div>
        </div>
        <div class="tip-row">
          <div class="tip-ico qi-a">📧</div>
          <div>
            <div class="tip-t">Monthly PDF</div>
            <div class="tip-d">Email yourself a full monthly spending report anytime.</div>
          </div>
        </div>
      </div>
    </div>

  </div>

  <!-- 4 · REPORT STRIP -->
  <div class="rbanner">
    <div class="rb-left">
      <div class="rb-title">📬 Monthly Email Report</div>
      <div class="rb-sub">Get a complete PDF summary of your spending delivered to your inbox.</div>
    </div>
    <div class="rb-btns">
      <a href="MonthlyReport" class="btn btn-blue">Send PDF Report 📧</a>
      <a href="ViewReport"    class="btn btn-ghost-dark">View Reports →</a>
    </div>
  </div>

</main>
</body>
</html>
