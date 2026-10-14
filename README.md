# Poncho Repricer

Репрайсер для маркетплейсов **Wildberries** и **Ozon**: управление ценообразованием
(в перспективе — и продвижением).

## Стек

- Бэкенд: Go 1.26, stdlib-first.
- Фронтенд: TypeScript (vanilla, без фреймворков) + vite — `web/`.
- Хранилище: PostgreSQL (`pgx/v5`).

## Связанные проекты — главный источник переиспользования

- [poncho-ai](https://github.com/ilkoid/poncho-ai) — клиент WB API (`pkg/wb`),
  домены-загрузчики, PostgreSQL-слой, загрузчик конфигурации, а также
  swagger-спецификации WB и Ozon API (`docs/`).
- [poncho-oz](https://github.com/ilkoid/poncho-oz) — клиент Ozon Seller API (`pkg/oz`).

Код соседей импортируется как Go-модули (локально подставляется через `go.work`),
а не копируется. Дублирование кода недопустимо — см. [AGENTS.md](./AGENTS.md).

## Быстрый старт

```bash
cp .env.example .env            # заполнить ключи (значения — как в poncho-ai/.env)
./create-test-db.sh             # создать тестовую БД repricer_data_test (лог: logs/)
cd cmd/repricer && go run .     # скелет: загрузка и диагностика конфигурации
cd web && npm install && npm run dev
```

## Статус

Инициализация: скелет сервиса и конвенции разработки. Бизнес-логика репрайсера —
в последующих задачах.
