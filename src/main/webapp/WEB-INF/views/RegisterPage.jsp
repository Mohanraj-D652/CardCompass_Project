<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register – CardCompass</title>
    <%@ include file="common-style.jsp" %>

    <style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap');

:root {
    --navy:      #0f172a;
    --navy-2:    #1e293b;
    --blue:      #3b82f6;
    --blue-dark: #2563eb;
    --green:     #22c55e;
    --green-dk:  #16a34a;
    --red:       #ef4444;
    --white:     #ffffff;
    --border:    #e2e8f0;
    --text:      #0f172a;
    --muted:     #64748b;
    --muted-2:   #94a3b8;
}

*, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }
html { height:100%; }

body {
    font-family: 'Outfit', sans-serif;
    min-height: 100vh;
    min-height: 100dvh;
    background: var(--navy);
    display: flex;
    flex-direction: column;
    -webkit-font-smoothing: antialiased;
    overflow-x: hidden;
    position: relative;
}

/* dot grid */
body::before {
    content:'';
    position:fixed; inset:0; z-index:0;
    background-image: radial-gradient(rgba(255,255,255,.04) 1px, transparent 1px);
    background-size: 28px 28px;
    pointer-events:none;
}

/* background orbs */
.orb {
    position: fixed; border-radius:50%;
    filter: blur(70px); pointer-events:none; z-index:0;
}
.orb-1 { width:380px; height:380px; background:rgba(59,130,246,.13); top:-80px; right:-80px; animation:d1 10s ease-in-out infinite; }
.orb-2 { width:320px; height:320px; background:rgba(34,197,94,.09);  bottom:-80px; left:-80px; animation:d2 12s ease-in-out infinite; }
@keyframes d1 { 0%,100%{transform:translate(0,0)} 50%{transform:translate(-16px,20px)} }
@keyframes d2 { 0%,100%{transform:translate(0,0)} 50%{transform:translate(14px,-16px)} }

/* ── Top nav ─────────────────────────────── */
.top-nav {
    position: relative; z-index:10;
    height: 56px;
    display: flex; align-items:center; justify-content:space-between;
    padding: 0 24px;
    border-bottom: 1px solid rgba(255,255,255,.07);
    flex-shrink: 0;
}
.nav-brand {
    display:flex; align-items:center; gap:9px;
    text-decoration:none;
}
.nav-brand-icon {
    width:30px; height:30px;
    background: linear-gradient(135deg, var(--blue), var(--green));
    border-radius:8px;
    display:flex; align-items:center; justify-content:center;
    font-size:14px;
}
.nav-brand-name { font-size:15px; font-weight:800; color:var(--white); letter-spacing:-.3px; }
.nav-back {
    font-size:13px; font-weight:600;
    color:var(--muted-2); text-decoration:none;
    display:flex; align-items:center; gap:5px;
    padding:6px 12px;
    border:1.5px solid rgba(255,255,255,.1);
    border-radius:7px;
    transition:all .2s;
}
.nav-back:hover { color:var(--white); border-color:rgba(255,255,255,.25); background:rgba(255,255,255,.06); }

/* ── Page centering ──────────────────────── */
.page-body {
    flex:1;
    display:flex; align-items:center; justify-content:center;
    padding:20px 16px 28px;
    position:relative; z-index:1;
}

/* ── Card ────────────────────────────────── */
.card {
    width:100%; max-width:380px;
    background:rgba(255,255,255,.97);
    border-radius:18px;
    box-shadow:0 20px 56px rgba(0,0,0,.42), 0 0 0 1px rgba(255,255,255,.07);
    overflow:hidden;
    animation:up .5s cubic-bezier(.22,.61,.36,1) both;
}
@keyframes up {
    from { opacity:0; transform:translateY(24px) scale(.98); }
    to   { opacity:1; transform:translateY(0)     scale(1); }
}

/* card header */
.card-head {
    background:linear-gradient(135deg,var(--navy) 0%,#0f2044 100%);
    padding:20px 24px 18px;
    text-align:center;
    position:relative; overflow:hidden;
}
.card-head::before {
    content:''; position:absolute; top:-30px; right:-30px;
    width:120px; height:120px;
    background:rgba(59,130,246,.1); border-radius:50%;
}
.card-head::after {
    content:''; position:absolute; bottom:-40px; left:-20px;
    width:100px; height:100px;
    background:rgba(34,197,94,.08); border-radius:50%;
}
.head-icon {
    width:44px; height:44px;
    background:linear-gradient(135deg,var(--blue),var(--green));
    border-radius:12px;
    display:flex; align-items:center; justify-content:center;
    font-size:20px;
    margin:0 auto 10px;
    box-shadow:0 4px 16px rgba(59,130,246,.38);
    position:relative; z-index:1;
}
.card-head h1 {
    font-size:17px; font-weight:800;
    color:var(--white); letter-spacing:-.3px;
    position:relative; z-index:1;
    margin-bottom:3px;
}
.card-head p {
    font-size:12px; color:rgba(255,255,255,.5);
    position:relative; z-index:1;
}

/* card body */
.card-body { padding:20px 24px 24px; background:var(--white); }

/* alert */
.alert {
    display:flex; align-items:center; gap:8px;
    padding:10px 13px;
    border-radius:9px;
    font-size:12.5px; font-weight:500;
    margin-bottom:14px; line-height:1.45;
}
.alert-error {
    background:#fef2f2; color:#7f1d1d;
    border:1.5px solid #fecaca;
    border-left:4px solid var(--red);
}
.alert-error a { color:#dc2626; font-weight:700; text-decoration:none; }
.alert-error a:hover { text-decoration:underline; }

/* req box */
.req-box {
    background:#f0f9ff;
    border:1.5px solid #bae6fd;
    border-left:4px solid var(--blue);
    border-radius:9px;
    padding:10px 13px;
    font-size:12px; color:#0c4a6e;
    margin-bottom:14px; line-height:1.55;
}
.req-box strong { display:block; margin-bottom:5px; font-size:12px; }
.req-list { list-style:none; display:flex; flex-direction:column; gap:3px; padding-left:2px; }
.req-list li { display:flex; align-items:center; gap:7px; font-size:11.5px; }
.req-list li::before { content:'○'; font-size:9px; color:#7dd3fc; flex-shrink:0; }
.req-list li.met::before { content:'✓'; color:var(--green); font-weight:700; }

/* form groups */
.form-group { margin-bottom:12px; }

.field-label {
    display:block; margin-bottom:5px;
    font-size:11px; font-weight:700;
    color:var(--muted);
    text-transform:uppercase; letter-spacing:.55px;
}

.field-wrap { position:relative; }

.field-icon {
    position:absolute; left:11px; top:50%;
    transform:translateY(-50%);
    font-size:14px; pointer-events:none; opacity:.5;
}

.field-input {
    width:100%;
    padding:10px 40px 10px 36px;
    border:1.5px solid var(--border);
    border-radius:9px;
    font-size:13.5px;
    font-family:'Outfit',sans-serif;
    background:#f8fafc;
    color:var(--text);
    transition:all .2s;
    outline:none;
}
.field-input:focus { border-color:var(--blue); background:var(--white); box-shadow:0 0 0 3px rgba(59,130,246,.1); }
.field-input.valid   { border-color:var(--green); background:#f0fdf4; }
.field-input.invalid { border-color:var(--red);   background:#fef2f2; }

.eye-btn {
    position:absolute; right:10px; top:50%;
    transform:translateY(-50%);
    background:none; border:none; cursor:pointer;
    color:var(--muted-2); padding:3px;
    display:flex; align-items:center; transition:color .2s;
}
.eye-btn:hover { color:var(--blue); }
.eye-btn svg { width:18px; height:18px; fill:none; stroke:currentColor; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }

.field-msg { font-size:11.5px; margin-top:4px; min-height:16px; padding-left:2px; }
.field-msg.ok  { color:var(--green); }
.field-msg.err { color:var(--red); }

/* submit button */
.btn-submit {
    width:100%;
    padding:12px;
    background:var(--green);
    color:var(--white);
    border:none;
    border-radius:10px;
    font-size:14px; font-weight:700;
    font-family:'Outfit',sans-serif;
    cursor:pointer; transition:all .22s;
    box-shadow:0 2px 12px rgba(34,197,94,.32);
    margin-top:16px;
    display:flex; align-items:center; justify-content:center; gap:7px;
}
.btn-submit:hover { background:var(--green-dk); transform:translateY(-1px); box-shadow:0 5px 18px rgba(34,197,94,.42); }
.btn-submit:active { transform:translateY(0); }

/* divider */
.divider {
    display:flex; align-items:center; gap:10px;
    margin:16px 0;
    color:var(--muted-2); font-size:11.5px;
}
.divider::before,.divider::after { content:''; flex:1; height:1px; background:var(--border); }

/* footer */
.footer-link { text-align:center; font-size:12.5px; color:var(--muted); }
.footer-link a { color:var(--blue); text-decoration:none; font-weight:700; }
.footer-link a:hover { text-decoration:underline; }

/* ── Responsive ──────────────────────────── */
@media (max-width:480px) {
    .top-nav   { padding:0 16px; }
    .page-body { padding:14px 12px 20px; }
    .card      { border-radius:14px; }
    .card-head { padding:16px 18px 14px; }
    .card-body { padding:16px 18px 20px; }
    .nav-brand-name { display:none; }
}
@media (max-width:360px) {
    .card-head { padding:14px 14px 12px; }
    .card-body { padding:14px 14px 18px; }
    .field-input { font-size:13px; }
}
    </style>
</head>
<body>

<div class="orb orb-1"></div>
<div class="orb orb-2"></div>

<!-- top nav -->
<nav class="top-nav">
    <a href="/" class="nav-brand">
        <div class="nav-brand-icon">💳</div>
        <span class="nav-brand-name">CardCompass</span>
    </a>
    <a href="/" class="nav-back">← Home</a>
</nav>

<!-- page -->
<div class="page-body">
    <div class="card">

        <!-- header -->
        <div class="card-head">
            <div class="head-icon">💳</div>
            <h1>Create Account</h1>
            <p>Free forever · No credit card required</p>
        </div>

        <!-- body -->
        <div class="card-body">

            <%
                String msg = request.getParameter("msg");
                if ("exists".equals(msg)) {
            %>
            <div class="alert alert-error">
                ⚠️ Email already registered. <a href="LoginPage">Login instead →</a>
            </div>
            <% } else if ("failed".equals(msg)) { %>
            <div class="alert alert-error">❌ Registration failed. Please try again.</div>
            <% } %>

            <!-- password requirements -->
            <div class="req-box">
                <strong>🔑 Password Requirements</strong>
                <ul class="req-list">
                    <li id="req-len">At least 6 characters long</li>
                    <li id="req-mix">Mix of letters and numbers</li>
                    <li id="req-enc">Stored securely with encryption</li>
                </ul>
            </div>

            <%-- form action maps to Spring MVC @PostMapping("/RegisterPage") --%>
            <form action="RegisterPage" method="post" onsubmit="return validateForm()" novalidate>

                <!-- Name -->
                <div class="form-group">
                    <label class="field-label" for="uname">Full Name</label>
                    <div class="field-wrap">
                        <span class="field-icon">👤</span>
                        <input type="text" name="UserName" id="uname"
                               class="field-input" placeholder="Your full name"
                               autocomplete="name" oninput="vName(this)" required>
                    </div>
                    <div class="field-msg" id="m-name"></div>
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label class="field-label" for="uemail">Email Address</label>
                    <div class="field-wrap">
                        <span class="field-icon">✉️</span>
                        <input type="email" name="UserEmail" id="uemail"
                               class="field-input" placeholder="you@example.com"
                               autocomplete="email" oninput="vEmail(this)" required>
                    </div>
                    <div class="field-msg" id="m-email"></div>
                </div>

                <!-- Password -->
                <div class="form-group">
                    <label class="field-label" for="upwd">Password</label>
                    <div class="field-wrap">
                        <span class="field-icon">🔒</span>
                        <input type="password" name="UserPassword" id="upwd"
                               class="field-input" placeholder="Create a strong password"
                               autocomplete="new-password" oninput="vPwd(this)"
                               style="padding-right:38px" required>
                        <button type="button" class="eye-btn" onclick="eyeToggle('upwd',this)" aria-label="Show password">
                            <svg class="on"  viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                            <svg class="off" viewBox="0 0 24 24" style="display:none"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                        </button>
                    </div>
                    <div class="field-msg" id="m-pwd"></div>
                </div>

                <!-- Confirm -->
                <div class="form-group">
                    <label class="field-label" for="ucnf">Confirm Password</label>
                    <div class="field-wrap">
                        <span class="field-icon">🔑</span>
                        <input type="password" name="ConfirmPassword" id="ucnf"
                               class="field-input" placeholder="Re-enter your password"
                               autocomplete="new-password" oninput="vConfirm(this)"
                               style="padding-right:38px" required>
                        <button type="button" class="eye-btn" onclick="eyeToggle('ucnf',this)" aria-label="Show confirm password">
                            <svg class="on"  viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                            <svg class="off" viewBox="0 0 24 24" style="display:none"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                        </button>
                    </div>
                    <div class="field-msg" id="m-cnf"></div>
                </div>

                <button type="submit" class="btn-submit">🚀 Create Account</button>
            </form>

            <div class="divider">or</div>
            <div class="footer-link">
                Already have an account? <a href="LoginPage">Sign in →</a>
            </div>

        </div>
    </div>
</div>

<script>
function eyeToggle(id, btn) {
    var i = document.getElementById(id);
    var on = btn.querySelector('.on'), off = btn.querySelector('.off');
    if (i.type === 'password') { i.type='text';     on.style.display='none';  off.style.display='block'; }
    else                       { i.type='password'; on.style.display='block'; off.style.display='none';  }
}
function msg(id, txt, cls) {
    var el=document.getElementById(id); el.textContent=txt; el.className='field-msg '+(cls||'');
}
function mark(inp, ok) { inp.classList.toggle('valid',ok); inp.classList.toggle('invalid',!ok); }

function vName(inp) {
    var ok = inp.value.trim().length >= 2;
    mark(inp, ok);
    msg('m-name', ok ? '✓ Looks good' : '⚠ Enter at least 2 characters', ok?'ok':'err');
}
function vEmail(inp) {
    var ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(inp.value.trim());
    mark(inp, ok);
    msg('m-email', ok ? '✓ Valid email' : '⚠ Enter a valid email', ok?'ok':'err');
}
function vPwd(inp) {
    var v=inp.value, len=v.length>=6, mix=/[a-zA-Z]/.test(v)&&/[0-9]/.test(v);
    document.getElementById('req-len').classList.toggle('met', len);
    document.getElementById('req-mix').classList.toggle('met', mix);
    mark(inp, len);
    msg('m-pwd', len?(mix?'✓ Strong password':'✓ Add numbers for extra strength'):'⚠ Min 6 characters', len?'ok':'err');
    var c=document.getElementById('ucnf'); if(c.value) vConfirm(c);
}
function vConfirm(inp) {
    var ok = inp.value===document.getElementById('upwd').value && inp.value.length>0;
    mark(inp, ok);
    msg('m-cnf', ok?'✓ Passwords match':'⚠ Passwords do not match', ok?'ok':'err');
}
function validateForm() {
    var n=document.getElementById('uname').value.trim();
    var e=document.getElementById('uemail').value.trim();
    var p=document.getElementById('upwd').value;
    var c=document.getElementById('ucnf').value;
    if(n.length<2)  { msg('m-name','⚠ Enter your full name','err');  document.getElementById('uname').focus();  return false; }
    if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(e)) { msg('m-email','⚠ Enter a valid email','err'); document.getElementById('uemail').focus(); return false; }
    if(p.length<6)  { msg('m-pwd','⚠ Min 6 characters','err');       document.getElementById('upwd').focus();  return false; }
    if(p!==c)       { msg('m-cnf','⚠ Passwords do not match','err'); document.getElementById('ucnf').focus();  return false; }
    return true;
}
</script>
</body>
</html>
