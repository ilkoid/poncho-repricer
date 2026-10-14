#!/bin/bash
# create-test-db.sh — создание тестовой БД poncho-repricer (по умолчанию repricer_data_test).
# Запуск вручную:  ./create-test-db.sh [имя_бд]
# Креды берутся из .env (cp .env.example .env). Пишет лог в logs/ (AGENTS.md §8),
# чтобы агент мог разобрать результат запуска. Продовые БД (*_prod) создавать отказывается.

set -euo pipefail
cd "$(dirname "$0")"

DB_NAME="${1:-repricer_data_test}"
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/create-test-db-$(date +%Y%m%d-%H%M%S).log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

if [ -f .env ]; then
  # shellcheck disable=SC1091
  source .env
else
  log "ОШИБКА: .env не найден (cp .env.example .env, заполнить PGHOST/PGUSER/PG_PWD)"
  exit 1
fi

: "${PGHOST:?PGHOST не задан в .env}"
: "${PGPORT:=15432}"
: "${PGUSER:?PGUSER не задан в .env}"
: "${PG_PWD:?PG_PWD не задан в .env}"

command -v psql >/dev/null || { log "ОШИБКА: psql не найден (brew install libpq или postgresql-client)"; exit 1; }

# Имя БД — только буквы/цифры/подчёркивание; прод создавать этим скриптом нельзя.
case "$DB_NAME" in
  *_prod) log "ОШИБКА: '$DB_NAME' выглядит как продовая БД — скрипт только для тестовых"; exit 1 ;;
esac
if ! echo "$DB_NAME" | grep -Eq '^[A-Za-z0-9_]+$'; then
  log "ОШИБКА: недопустимое имя БД '$DB_NAME' (только [A-Za-z0-9_])"
  exit 1
fi

# Секреты в лог не пишем — только параметры подключения без пароля.
log "Старт: создание тестовой БД '$DB_NAME' на ${PGHOST}:${PGPORT} (user=${PGUSER})"
export PGPASSWORD="$PG_PWD"

EXISTS=$(psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d postgres -tAc \
  "SELECT 1 FROM pg_database WHERE datname = '${DB_NAME}'")
if [ "$EXISTS" = "1" ]; then
  log "ОК: БД '$DB_NAME' уже существует — ничего не делаю"
  exit 0
fi

if psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d postgres \
  -c "CREATE DATABASE \"${DB_NAME}\"" >>"$LOG_FILE" 2>&1; then
  log "ОК: БД '$DB_NAME' создана"
else
  log "ОШИБКА: не удалось создать БД (детали выше в этом же логе)"
  exit 1
fi
