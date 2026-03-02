# Пакет бэкенда стартовой страницы (Start Backend)

## Обзор

Пакет Start Backend предоставляет серверный компонент для стартовой страницы
Universo Platformo. Он запускает лёгкий HTTP-сервер, который выступает прокси
между фронтендом и Supabase, гарантируя, что учётные данные Supabase никогда
не попадают на клиент.

## Архитектура безопасности

```
[Фронтенд — start-frt]     [Бэкенд — start-srv]       [Supabase Cloud]
  Автозагрузка AuthManager → Автозагрузка BackendServer → REST Auth API
  нет SUPABASE_URL/KEY        хранит все учётные данные   (внешний)
  вызывает 127.0.0.1:8080     проксирует запросы
```

Фронтенд отправляет email/пароль (или access_token) на локальный бэкенд.
Бэкенд перенаправляет их в Supabase, используя `SUPABASE_URL` и `SUPABASE_KEY`,
которые доступны только в конфигурации `.env` на стороне бэкенда.

## Структура

```
packages/start-srv/base/
├── scripts/
│   ├── http_server.gd    # Лёгкий HTTP/1.1-сервер на основе TCPServer
│   └── auth_api.gd       # Маршруты Auth API — проксирует запросы в Supabase
├── plugin.cfg            # Конфигурация плагина
├── plugin.gd             # Точка входа плагина
├── README.md             # Английская версия
└── README-RU.md          # Данный файл
```

## Конечные точки API

Бэкенд слушает на `127.0.0.1:BACKEND_PORT` (по умолчанию `8080`):

| Метод  | Путь                  | Поля тела                   | Описание                    |
|--------|-----------------------|-----------------------------|------------------------------|
| POST   | /api/auth/sign-in     | email, password             | Вход по учётным данным      |
| POST   | /api/auth/sign-up     | email, password             | Создание нового аккаунта    |
| POST   | /api/auth/sign-out    | access_token                | Инвалидация токена сессии   |

Все конечные точки напрямую проксируют запросы в Supabase Auth REST API и
передают ответ обратно вызывающей стороне в неизменном виде.

## Конфигурация

Указывается в `.env` (только переменные бэкенда):

```env
BACKEND_PORT=8080
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key-here
```

Фронтенд читает только `BACKEND_PORT` и строит `http://127.0.0.1:BACKEND_PORT`.

## Использование

Сервер запускается автоматически через автозагрузку `BackendServer`
(`scripts/autoload/backend_server.gd`) при запуске проекта Godot.

Вызов из GDScript (на стороне фронтенда):

```gdscript
# Вход (обрабатывается через AuthManager — не вызывать напрямую)
var http := HTTPRequest.new()
add_child(http)
http.request(
    "http://127.0.0.1:8080/api/auth/sign-in",
    PackedStringArray(["Content-Type: application/json"]),
    HTTPClient.METHOD_POST,
    JSON.stringify({"email": "user@example.com", "password": "secret"})
)
```

На практике всегда используйте `AuthManager.sign_in()` — он оборачивает этот вызов.

## Зависимости

- Godot Engine 4.3+
- Автозагрузка `Config` — читает `.env` для `SUPABASE_URL`, `SUPABASE_KEY`, `BACKEND_PORT`
- Проект Supabase с включённой аутентификацией

## Участие в разработке

Смотрите основной [CONTRIBUTING-RU.md](../../../CONTRIBUTING-RU.md).

## Лицензия

[Информация о лицензии будет добавлена]
