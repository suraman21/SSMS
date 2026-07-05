<?php
/**
 * ============================================================
 * School AI Chatbot Widget
 * ============================================================
 * Injects a floating AI chat button + slide-out panel into any dashboard.
 * Include this file at the bottom of dashboard.php — works for ALL roles.
 * 
 * Security:
 * - Role-based data access (teachers can't see finance, etc.)
 * - No sensitive user data exposed (passwords, emails, etc.)
 * - CSRF protected
 * ============================================================
 */
if (empty($_SESSION['admin_id'])) return;

$_aiUserRole = $_SESSION['admin_role'] ?? '';
$_aiUserName = $_SESSION['admin_full_name'] ?? $_SESSION['admin_username'] ?? 'User';
$_aiCsrf = generateCsrfToken();
?>
<!-- AI Chatbot Widget -->
<style>
/* ── AI Chatbot Floating Button ── */
#ai-fab{position:fixed;bottom:24px;right:24px;z-index:9990;width:52px;height:52px;border-radius:16px;background:linear-gradient(135deg,#10b981,#3b82f6);color:#fff;border:none;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:1.3rem;box-shadow:0 6px 24px rgba(16,185,129,.35);transition:all .2s}
#ai-fab:hover{transform:scale(1.08);box-shadow:0 8px 32px rgba(16,185,129,.45)}
#ai-fab .fab-badge{position:absolute;top:-2px;right:-2px;width:14px;height:14px;border-radius:50%;background:#22c55e;border:2px solid #0a0e17;display:none}
#ai-fab.has-key .fab-badge{display:block}

/* ── Slide-out Panel ── */
#ai-panel{position:fixed;top:0;right:-420px;bottom:0;width:400px;max-width:90vw;z-index:9995;background:#0f1629;border-left:1px solid #1e293b;display:flex;flex-direction:column;transition:right .3s cubic-bezier(.4,0,.2,1);box-shadow:-8px 0 40px rgba(0,0,0,.4)}
#ai-panel.open{right:0}
#ai-overlay{position:fixed;inset:0;background:rgba(0,0,0,.3);z-index:9993;opacity:0;pointer-events:none;transition:opacity .3s}
#ai-overlay.open{opacity:1;pointer-events:auto}

/* Panel header */
.aip-header{display:flex;align-items:center;justify-content:space-between;padding:.65rem .8rem;border-bottom:1px solid #1e293b;background:#111827;flex-shrink:0}
.aip-header-left{display:flex;align-items:center;gap:.5rem}
.aip-header-left .aip-icon{width:28px;height:28px;border-radius:8px;background:linear-gradient(135deg,#10b981,#3b82f6);display:flex;align-items:center;justify-content:center;font-size:.75rem;color:#fff}
.aip-header-left h3{font-size:.85rem;font-weight:600;color:#e2e8f0;font-family:'Segoe UI',system-ui,sans-serif}
.aip-header-left .aip-badge{font-size:.55rem;padding:.1rem .3rem;border-radius:99px;background:rgba(16,185,129,.15);color:#10b981;font-weight:600}
.aip-close{background:none;border:none;color:#64748b;font-size:1rem;cursor:pointer;padding:.3rem;border-radius:.3rem;transition:all .15s}
.aip-close:hover{background:rgba(255,255,255,.05);color:#e2e8f0}

/* Messages area */
.aip-messages{flex:1;overflow-y:auto;padding:.8rem;scroll-behavior:smooth}
.aip-msg{margin-bottom:.8rem;animation:aipIn .25s ease}
@keyframes aipIn{from{opacity:0;transform:translateY(6px)}to{opacity:1;transform:none}}
.aip-msg.user{display:flex;justify-content:flex-end}
.aip-msg.user .aip-bubble{background:rgba(59,130,246,.1);border:1px solid rgba(59,130,246,.2);border-radius:.6rem .6rem .15rem .6rem;max-width:85%;padding:.5rem .7rem;font-size:.8rem;line-height:1.6;color:#e2e8f0}
.aip-msg.ai .aip-bubble{background:rgba(16,185,129,.06);border:1px solid rgba(16,185,129,.15);border-radius:.6rem .6rem .6rem .15rem;max-width:90%;padding:.5rem .7rem;font-size:.8rem;line-height:1.6;color:#cbd5e1}

/* Markdown in AI bubbles */
.aip-bubble h1,.aip-bubble h2,.aip-bubble h3{margin:.4rem 0 .2rem;font-weight:700;color:#e2e8f0}
.aip-bubble h2{font-size:.85rem;color:#34d399}
.aip-bubble h3{font-size:.82rem;color:#60a5fa}
.aip-bubble p{margin:.2rem 0}
.aip-bubble strong{color:#e2e8f0}
.aip-bubble ul,.aip-bubble ol{padding-left:1rem;margin:.2rem 0}
.aip-bubble li{margin-bottom:.15rem}
.aip-bubble code{background:rgba(0,0,0,.3);padding:.1rem .25rem;border-radius:.2rem;font-size:.75rem}
.aip-bubble table{border-collapse:collapse;width:100%;margin:.3rem 0;font-size:.72rem}
.aip-bubble th,.aip-bubble td{padding:.25rem .35rem;border:1px solid #2d3a4f;text-align:left}
.aip-bubble th{background:rgba(255,255,255,.04)}
.aip-bubble hr{border:none;border-top:1px solid #1e293b;margin:.4rem 0}

.aip-copy-btn{background:none;border:1px solid #2d3a4f;color:#64748b;padding:.15rem .4rem;border-radius:.25rem;font-size:.62rem;cursor:pointer;margin-top:.3rem;font-family:inherit;transition:all .15s}
.aip-copy-btn:hover{color:#e2e8f0;background:rgba(255,255,255,.04)}

/* Quick suggestions */
.aip-suggestions{display:flex;flex-wrap:wrap;gap:.3rem;padding:.3rem .8rem;border-bottom:1px solid #1e293b;flex-shrink:0}
.aip-sug{padding:.3rem .55rem;border:1px solid #2d3a4f;background:#1e293b;color:#94a3b8;border-radius:99px;font-size:.68rem;cursor:pointer;transition:all .15s;font-family:inherit;white-space:nowrap}
.aip-sug:hover{border-color:#10b981;color:#e2e8f0;background:rgba(16,185,129,.1)}

/* Typing indicator */
.aip-typing{display:none;align-items:center;gap:.3rem;padding:.3rem 0;color:#64748b;font-size:.72rem}
.aip-typing.active{display:flex}
.aip-typing-dots{display:flex;gap:2px}
.aip-typing-dots span{width:5px;height:5px;border-radius:50%;background:#10b981;animation:aipBlink 1.4s infinite}
.aip-typing-dots span:nth-child(2){animation-delay:.2s}
.aip-typing-dots span:nth-child(3){animation-delay:.4s}
@keyframes aipBlink{0%,80%,100%{opacity:.3}40%{opacity:1}}

/* Input area */
.aip-input-area{padding:.5rem .8rem;border-top:1px solid #1e293b;background:#111827;flex-shrink:0}
.aip-input-row{display:flex;gap:.4rem;align-items:flex-end}
#aipInput{flex:1;padding:.5rem .6rem;background:#1e293b;border:1px solid #2d3a4f;border-radius:.5rem;color:#e2e8f0;font-size:.8rem;font-family:inherit;resize:none;min-height:36px;max-height:100px;line-height:1.4}
#aipInput:focus{outline:none;border-color:#10b981}
#aipInput::placeholder{color:#475569}
.aip-send{width:32px;height:32px;border-radius:.4rem;border:none;background:linear-gradient(135deg,#10b981,#3b82f6);color:#fff;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.8rem;flex-shrink:0;transition:all .15s}
.aip-send:hover{opacity:.85}
.aip-send:disabled{opacity:.3;cursor:not-allowed}

/* Setup message */
.aip-setup{padding:1rem;text-align:center;color:#64748b;font-size:.78rem;line-height:1.6}
.aip-setup a{color:#3b82f6;text-decoration:none}
.aip-setup a:hover{text-decoration:underline}

/* Welcome */
.aip-welcome{display:flex;flex-direction:column;align-items:center;justify-content:center;padding:1.5rem 1rem;text-align:center;flex:1}
.aip-welcome-icon{width:40px;height:40px;border-radius:12px;background:linear-gradient(135deg,#10b981,#3b82f6);display:flex;align-items:center;justify-content:center;font-size:1.1rem;color:#fff;margin-bottom:.6rem}
.aip-welcome h4{font-size:.9rem;color:#e2e8f0;margin-bottom:.3rem}
.aip-welcome p{font-size:.75rem;color:#64748b;max-width:280px;line-height:1.5}

@media(max-width:480px){#ai-panel{width:100%;max-width:100%}}
</style>

<!-- Floating Button -->
<button id="ai-fab" onclick="aipToggle()" title="AI Assistant">
    <i class="fa-solid fa-robot" id="ai-fab-icon"></i>
    <div class="fab-badge"></div>
</button>

<!-- Overlay -->
<div id="ai-overlay" onclick="aipClose()"></div>

<!-- Slide-out Panel -->
<div id="ai-panel">
    <div class="aip-header">
        <div class="aip-header-left">
            <div class="aip-icon"><i class="fa-solid fa-robot"></i></div>
            <h3>AI Assistant</h3>
            <span class="aip-badge">FREE</span>
        </div>
        <button class="aip-close" onclick="aipClose()"><i class="fa-solid fa-xmark"></i></button>
    </div>
    
    <div class="aip-suggestions" id="aipSuggestions"></div>
    
    <div class="aip-messages" id="aipMessages">
        <div class="aip-welcome" id="aipWelcome">
            <div class="aip-welcome-icon"><i class="fa-solid fa-robot"></i></div>
            <h4>AI Assistant</h4>
            <p>Ask me about your school data. I can analyze and generate insights based on your role.</p>
        </div>
        <div class="aip-typing" id="aipTyping">
            <div class="aip-typing-dots"><span></span><span></span><span></span></div>
            <span>Thinking...</span>
        </div>
    </div>
    
    <div class="aip-input-area">
        <div id="aipSetupMsg" class="aip-setup" style="display:none"></div>
        <div class="aip-input-row" id="aipInputRow">
            <textarea id="aipInput" rows="1" placeholder="Ask about your data..." onkeydown="aipKey(event)" oninput="aipResize(this)"></textarea>
            <button class="aip-send" id="aipSendBtn" onclick="aipSend()"><i class="fa-solid fa-paper-plane"></i></button>
        </div>
    </div>
</div>

<script>
(function(){
    const CSRF = '<?= $_aiCsrf ?>';
    const API = '/admin/api_ai.php';
    const ROLE = '<?= $_aiUserRole ?>';
    let hasKey = false, busy = false;

    // Role-based suggestions
    const roleSuggestions = {
        super_admin: ['📊 School overview','👥 Member stats','💰 Finance health','📋 Monthly report'],
        school_admin: ['📊 School overview','👥 Member stats','📋 Monthly report'],
        info_dept: ['👥 Member demographics','📞 Data quality check','🆕 Registration trends'],
        edu_dept: ['🏫 Class enrollment','📖 Teacher ratios','📊 Education status'],
        finance_dept: ['💰 Income vs expenses','📊 Budget summary','⏳ Pending payments'],
        material_dept: ['📦 Material overview','📊 Department stats'],
        teacher: ['📊 My class overview','📖 Student performance tips'],
        attendance_taker: ['📊 Attendance overview','📅 Today\'s summary']
    };

    // Initialize
    window.addEventListener('DOMContentLoaded', async () => {
        // Load suggestions
        const sugs = roleSuggestions[ROLE] || roleSuggestions.teacher;
        const sugContainer = document.getElementById('aipSuggestions');
        sugs.forEach(s => {
            const btn = document.createElement('button');
            btn.className = 'aip-sug';
            btn.textContent = s;
            btn.onclick = () => { document.getElementById('aipInput').value = s.replace(/^[^\s]+\s/, ''); aipSend(); };
            sugContainer.appendChild(btn);
        });

        // Check API status
        try {
            const r = await fetch(API + '?action=check_status');
            const d = await r.json();
            hasKey = d.has_api_key;
            if (hasKey) document.getElementById('ai-fab').classList.add('has-key');
            else {
                const setup = document.getElementById('aipSetupMsg');
                const isSA = ROLE === 'super_admin';
                setup.style.display = 'block';
                setup.innerHTML = isSA
                    ? 'AI not configured. <a href="/admin/dashboards/ai_assistant.php">Set up API key</a>'
                    : 'AI not configured yet. Ask Super Admin to set it up.';
                document.getElementById('aipInputRow').style.display = 'none';
            }
        } catch(e) {}

        // Load last few messages
        try {
            const r = await fetch(API + '?action=get_history&limit=10');
            const d = await r.json();
            if (d.status === 'success' && d.messages.length > 0) {
                document.getElementById('aipWelcome').style.display = 'none';
                d.messages.forEach(m => addMsg(m.role, m.message, m.role==='assistant'));
            }
        } catch(e) {}
    });

    // Toggle panel
    window.aipToggle = () => {
        const p = document.getElementById('ai-panel');
        const o = document.getElementById('ai-overlay');
        const isOpen = p.classList.contains('open');
        p.classList.toggle('open');
        o.classList.toggle('open');
        if (!isOpen) {
            document.getElementById('aipInput').focus();
            scrollBot();
        }
    };
    window.aipClose = () => {
        document.getElementById('ai-panel').classList.remove('open');
        document.getElementById('ai-overlay').classList.remove('open');
    };

    // Send message
    window.aipKey = (e) => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); aipSend(); } };
    window.aipResize = (el) => { el.style.height = 'auto'; el.style.height = Math.min(el.scrollHeight, 100) + 'px'; };

    window.aipSend = async () => {
        const input = document.getElementById('aipInput');
        const msg = input.value.trim();
        if (!msg || busy || !hasKey) return;

        document.getElementById('aipWelcome').style.display = 'none';
        addMsg('user', msg, false);
        input.value = ''; aipResize(input);
        showTyping(); busy = true;
        document.getElementById('aipSendBtn').disabled = true;

        try {
            const form = new FormData();
            form.append('action', 'chat');
            form.append('message', msg);
            form.append('csrf_token', CSRF);
            const r = await fetch(API, { method: 'POST', body: form });
            const d = await r.json();
            hideTyping();
            if (d.status === 'success') addMsg('assistant', d.response, true);
            else addMsg('assistant', '❌ ' + (d.message || 'Error'), false);
        } catch(e) {
            hideTyping();
            addMsg('assistant', '❌ Connection error', false);
        }
        busy = false;
        document.getElementById('aipSendBtn').disabled = false;
    };

    // Render markdown (lightweight)
    function renderMd(t) {
        return t
            .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
            .replace(/```\w*\n([\s\S]*?)```/g,'<pre><code>$1</code></pre>')
            .replace(/`([^`]+)`/g,'<code>$1</code>')
            .replace(/\*\*([^*]+)\*\*/g,'<strong>$1</strong>')
            .replace(/\*([^*]+)\*/g,'<em>$1</em>')
            .replace(/^### (.+)$/gm,'<h3>$1</h3>')
            .replace(/^## (.+)$/gm,'<h2>$1</h2>')
            .replace(/^# (.+)$/gm,'<h1>$1</h1>')
            .replace(/^---$/gm,'<hr>')
            .replace(/^\- (.+)$/gm,'<li>$1</li>')
            .replace(/\n{2,}/g,'</p><p>')
            .replace(/\n/g,'<br>');
    }

    function addMsg(role, text, useMd) {
        const container = document.getElementById('aipMessages');
        const typing = document.getElementById('aipTyping');
        const div = document.createElement('div');
        div.className = 'aip-msg ' + (role === 'user' ? 'user' : 'ai');
        const content = useMd ? renderMd(text) : text.replace(/\n/g,'<br>');
        let extra = '';
        if (role === 'assistant') {
            extra = '<button class="aip-copy-btn" onclick="navigator.clipboard.writeText(this.parentElement.querySelector(\'.aip-bubble\').innerText);this.textContent=\'Copied!\';setTimeout(()=>this.textContent=\'Copy\',1500)">Copy</button>';
        }
        div.innerHTML = '<div class="aip-bubble">' + content + '</div>' + extra;
        container.insertBefore(div, typing);
        scrollBot();
    }

    function showTyping() { document.getElementById('aipTyping').classList.add('active'); scrollBot(); }
    function hideTyping() { document.getElementById('aipTyping').classList.remove('active'); }
    function scrollBot() { const c = document.getElementById('aipMessages'); c.scrollTop = c.scrollHeight; }
})();
</script>
