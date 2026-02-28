const appState = {
    data: null,
    currentDay: null,
    currentPhase: null
};

async function init() {
    appState.data = STUDY_DATA;
    renderSidebar();
    if (appState.data && appState.data.phases && appState.data.phases[0].days.length > 0) {
        const first = appState.data.phases[0].days[0];
        loadDay(appState.data.phases[0].id, first.id);
    }
}

function renderSidebar() {
    const nav = document.getElementById('sidebar-nav');
    nav.innerHTML = '';

    appState.data.phases.forEach(phase => {
        const group = document.createElement('div');
        group.className = 'nav-group';

        const title = document.createElement('div');
        title.className = 'nav-group-title';
        title.textContent = phase.name;
        group.appendChild(title);

        phase.days.forEach(day => {
            const item = document.createElement('a');
            item.className = 'nav-item';
            item.textContent = day.title;
            item.onclick = () => loadDay(phase.id, day.id);
            group.appendChild(item);
        });

        nav.appendChild(group);
    });
}

function loadDay(phaseId, dayId) {
    const phase = appState.data.phases.find(p => p.id === phaseId);
    if (!phase) return;
    const day = phase.days.find(d => d.id === dayId);
    if (!day) return;
    appState.currentDay = day;

    // Update active state in sidebar
    document.querySelectorAll('.nav-item').forEach(el => {
        el.classList.remove('active');
        if (el.textContent === day.title) el.classList.add('active');
    });

    const area = document.getElementById('content-area');
    area.innerHTML = `
        <h2>${day.title}</h2>
        <div class="tabs">
            ${day.vocab ? '<button id="btn-vocab" class="tab-btn active" onclick="showSection(event, \'vocab\')">核心词汇</button>' : ''}
            ${day.dialogue ? `<button id="btn-dialogue" class="tab-btn ${!day.vocab ? 'active' : ''}" onclick="showSection(event, 'dialogue')">对话练习</button>` : ''}
            ${day.test ? `<button id="btn-test" class="tab-btn ${!day.vocab && !day.dialogue ? 'active' : ''}" onclick="showSection(event, 'test')">自我测试</button>` : ''}
        </div>
        
        <div id="vocab" class="section-content ${day.vocab ? 'active' : ''}">${day.vocab || ''}</div>
        <div id="dialogue" class="section-content ${!day.vocab && day.dialogue ? 'active' : ''}">${day.dialogue || ''}</div>
        <div id="test" class="section-content ${!day.vocab && !day.dialogue && day.test ? 'active' : ''}">${day.test || ''}</div>

        ${day.audio ? `
        <div id="audio-player" class="audio-section" style="display: ${day.dialogue && !day.vocab ? 'block' : 'none'};">
            <p>🎧 听力练习：</p>
            <audio controls src="${day.audio}"></audio>
        </div>
        ` : ''}
    `;

    document.querySelector('.main-content').scrollTo({ top: 0, behavior: 'smooth' });
}

function showSection(event, sectionId) {
    document.querySelectorAll('.section-content').forEach(s => s.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));

    document.getElementById(sectionId).classList.add('active');
    if (event) event.currentTarget.classList.add('active');

    // Show audio only for dialogue
    const audio = document.getElementById('audio-player');
    if (audio) audio.style.display = (sectionId === 'dialogue') ? 'block' : 'none';
}

window.onload = init;
