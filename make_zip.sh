#!/usr/bin/env bash
# make_zip.sh — создаёт папку good-girl с файлами и архив good-girl.zip
set -e

mkdir -p good-girl/src/css

cat > good-girl/index.html <<'EOF'
<!doctype html>
<html lang="ru">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Тени новой школы — Сезон 1, Глава 1</title>
  <style>
    :root{
      --bg:#071225; --panel:#0e1720; --accent:#7fb6ff; --danger:#ff6b6b;
      --muted:#9aa6b2; --glass:rgba(255,255,255,0.03);
    }
    html,body{height:100%;margin:0;font-family:Inter,Segoe UI,Roboto,Arial; background:linear-gradient(180deg,#021021, #071225 60%); color:#e6eef8;}
    .wrap{max-width:1100px;margin:28px auto;padding:18px; display:grid; grid-template-columns: 360px 1fr; gap:18px;}
    .card{background:linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01)); border-radius:12px; padding:18px; box-shadow:0 6px 24px rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.02);}    
    aside.card{height:800px; overflow:auto;}
    main.card{height:800px; position:relative; overflow:hidden;}
    h1{margin:0;font-size:18px}
    .meta{color:var(--muted); font-size:13px;margin-top:6px}
    .stats{margin-top:14px}
    .stat{display:flex;align-items:center;gap:8px;margin-bottom:12px}
    .label{width:120px;color:var(--muted);font-size:14px}
    .bar{flex:1;height:12px;background:var(--glass);border-radius:8px;overflow:hidden;position:relative}
    .bar > i{position:absolute;left:0;top:0;bottom:0;background:linear-gradient(90deg,var(--accent),#ffa4b3);width:0}
    .val{width:44px;text-align:right;color:var(--muted)}
    .log{margin-top:12px;color:var(--muted); font-size:13px; max-height:290px; overflow:auto; padding-right:6px}
    button{padding:10px 12px;border-radius:8px;border:none;background:#0f2233;color:#eaf3ff;cursor:pointer}
    button.ghost{background:transparent;border:1px solid rgba(255,255,255,0.04); color:var(--muted)}
    .choices{display:flex;flex-direction:column;gap:10px;margin-top:16px}
    .scene-title{font-weight:600;margin-bottom:8px}
    .dialog{white-space:pre-line; line-height:1.6; font-size:15px; color:#f3fbff; padding-right:8px}
    .overlay-dim{position:absolute;inset:0;background:rgba(0,0,0,0.45);display:flex;align-items:center;justify-content:center;z-index:50}
    .panic-ui{display:flex;flex-direction:column;gap:12px;align-items:center}
    .breath-buttons{display:flex;gap:10px}
    .breath-btn{padding:10px 14px;border-radius:10px;border:1px solid rgba(255,255,255,0.06); background:linear-gradient(180deg,#0e2a44,#0c2436); color:#eaf3ff}
    .small{font-size:13px;color:var(--muted)}
    .phone{background:#071b2a;border-radius:10px;padding:12px;color:#dff0ff}
    .app-list{display:grid;grid-template-columns:repeat(2,1fr);gap:8px;margin-top:10px}
    .app{background:rgba(255,255,255,0.02);padding:8px;border-radius:8px;font-size:13px;color:var(--muted)}
    .center{display:flex;align-items:center;justify-content:center}
    .shake{animation:shake 0.6s ease-in-out}
    @keyframes shake{0%{transform:translateX(0)}20%{transform:translateX(-6px)}40%{transform:translateX(6px)}60%{transform:translateX(-4px)}80%{transform:translateX(4px)}100%{transform:translateX(0)}}
    .heartbeat{animation:beat 1s infinite}
    @keyframes beat{0%{transform:scale(1)}30%{transform:scale(1.06)}60%{transform:scale(1)}100%{transform:scale(1)}}
    footer{margin-top:12px;color:var(--muted); font-size:13px}
    @media(max-width:980px){ .wrap{grid-template-columns:1fr} aside.card{order:2} main.card{order:1; height:auto} }
  </style>
</head>
<body>
  <div class="wrap" role="application" aria-label="Тени новой школы — Сезон 1 Гл.1">
    <aside class="card" aria-hidden="false">
      <h1>Шкалы эмоций</h1>
      <div class="meta">Значения меняются в зависимости от ваших выборов.</div>

      <div class="stats" id="stats">
        <div class="stat"><div class="label">Страх</div><div class="bar"><i id="bar-fear"></i></div><div class="val" id="val-fear">62%</div></div>
        <div class="stat"><div class="label">Тревога</div><div class="bar"><i id="bar-anx"></i></div><div class="val" id="val-anx">48%</div></div>
        <div class="stat"><div class="label">Уверенность</div><div class="bar"><i id="bar-conf"></i></div><div class="val" id="val-conf">6%</div></div>
        <div class="stat"><div class="label">Соц. энергия</div><div class="bar"><i id="bar-social"></i></div><div class="val" id="val-social">22%</div></div>
      </div>

      <div style="margin-top:10px">
        <button id="saveBtn" class="ghost">Сохранить в localStorage</button>
        <button id="loadBtn" class="ghost" style="margin-left:8px">Загрузить</button>
        <button id="resetBtn" class="ghost" style="margin-left:8px">Сброс</button>
      </div>

      <div class="log" id="log" aria-live="polite"></div>
      <footer>Клавиши: 1-5 — быстрый выбор / В дыхании — клавиши I/H/E</footer>
    </aside>

    <main class="card" id="main">
      <div id="sceneRoot" style="padding:6px 8px;">
        <!-- сцены рендерятся сюда -->
      </div>
    </main>
  </div>

  <script>
    // (скрипт опущён для краткости — при желании вставьте полный index.html из корня)
    document.addEventListener('DOMContentLoaded', ()=> {
      console.log('Prototype loaded. Replace with full index.html if needed.');
    });
  </script>
</body>
</html>
EOF

cat > good-girl/DESIGN.md <<'EOF'
# Тени новой школы — Полный геймдизайн и интерфейс (Сезон 1)

(Документ: вставьте полный текст DESIGN.md — файл уже приложен отдельно)
EOF

cat > good-girl/game-config.json <<'EOF'
{
  "initialStats": {
    "fear": 62,
    "anxiety": 48,
    "confidence": 6,
    "socialEnergy": 22,
    "willpower": 20
  },
  "musicTracks": [
    { "id": "rainy_calm", "title": "Rainy Calm", "effect": { "calm": 15 } },
    { "id": "dark_thoughts", "title": "Dark Thoughts", "effect": { "calm": -10 } },
    { "id": "hopeful_morning", "title": "Hopeful Morning", "effect": { "willpower": 10 } }
  ],
  "apps": [
    "Messages", "Gallery", "Evidence", "Map", "Music", "Diary", "SOS", "SPEAK", "Mail", "EmotionsSettings", "Breathe"
  ],
  "panic": {
    "triggerAnxiety": 80,
    "triggerVulnerability": 75,
    "breathCyclesRequired": 3,
    "perFailPenalty": { "anxiety": 12, "fear": 8 },
    "perSuccessReward": { "anxiety": -20, "fear": -8, "willpower": 3 }
  },
  "reputation": { "base": 50 }
}
EOF

cat > good-girl/src/css/ui-variables.css <<'EOF'
:root{
  --bg:#E1E8F0;
  --panel:#AEC6FF;
  --danger:#FF8591;
  --neutral:#FFDCA7;
  --support:#C8F7DC;
  --glass: rgba(255,255,255,0.6);
  --text:#0b2233;
  --radius:12px;
  --button-shadow: 0 6px 18px rgba(10,20,30,0.12);
  --transition-fast: 120ms cubic-bezier(.2,.8,.2,1);
  --transition-smooth: 260ms cubic-bezier(.2,.8,.2,1);
}

/* Basic components */
body {
  background: var(--bg);
  color: var(--text);
  font-family: Inter, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
  margin: 0;
  -webkit-font-smoothing:antialiased;
}
EOF

cat > good-girl/README.md <<'EOF'
# Тени новой школы — Проект

Это репозиторий прототипа и геймдизайна визуальной новеллы "Тени новой школы".
EOF

# create zip
zip -r good-girl.zip good-girl >/dev/null
echo "good-girl.zip created"
