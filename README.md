# Checktour Monolit

## Быстрый старт

Требования:
- Ruby 3.2+
- PostgreSQL 13+
- Redis (для Sidekiq)

1) Клонируй репозиторий и перейди в папку проекта.
2) Запусти дев-среду одной командой:

```
bin/dev
```

Скрипт:
- установит зависимости (`bundle install`)
- создаст `.env`, если его нет, и подскажет куда вставить токен бота
- подготовит БД (`bin/rails db:prepare`)
- запустит процессы через `foreman`:
  - `web`: Puma (Rails)
  - `worker`: Sidekiq
  - `telegram`: Telegram бот (long-poll)

## Переменные окружения

Создай файл `.env` в корне проекта и добавь:
```
TELEGRAM_BOT_TOKEN=ваш_токен_из_BotFather
REDIS_URL=redis://127.0.0.1:6379/0
SIDEKIQ_CONCURRENCY=5
```
`.gitignore` уже настроен, чтобы не коммитить `.env`.

## Проверка
- Веб: `GET http://localhost:3000/health` → ожидается `ok`.
- Telegram: напиши своему боту в Telegram → ответит `hello world`.

## Ручной запуск (альтернатива)
- Только веб-сервер:
```
bin/rails s
```
- Только бот:
```
bundle exec rake telegram:bot
```
- Всё вместе (Procfile):
```
bundle exec foreman start
```
