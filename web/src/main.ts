// Точка входа фронта. Vanilla TS, без фреймворков (AGENTS.md §2).

const statusEl = document.querySelector<HTMLParagraphElement>('#status');

async function checkBackend(): Promise<void> {
  try {
    const res = await fetch('/api/health');
    statusEl!.textContent = res.ok
      ? 'Бэкенд доступен'
      : `Бэкенд ответил: HTTP ${res.status}`;
  } catch {
    statusEl!.textContent = 'Бэкенд пока не поднят (HTTP-сервер — в последующих задачах)';
  }
}

void checkBackend();
