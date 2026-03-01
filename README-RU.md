# Universo Platformo Godot

**Реализация Universo Platformo на основе Godot Engine 4 и GDScript.**

## Обзор

Universo Platformo Godot — это полнофункциональная реализация концепции Universo Platformo
на Godot 4, предоставляющая модульную платформу для приложений метавселенной, многопользовательских
приложений и совместных цифровых пространств. Компоненты фронтенда и бэкенда написаны на GDScript.

Этот проект следует архитектурным паттернам
[Universo Platformo React](https://github.com/teknokomo/universo-platformo-react),
адаптированным для экосистемы Godot.

## Ключевые возможности

- **Полнофункциональный GDScript**: Клиентский UI и бэкенд-сервер написаны на GDScript
- **Бэкенд как прокси к Supabase**: Фронтенд никогда не обращается к Supabase напрямую;
  все операции аутентификации проходят через встроенный GDScript-бэкенд
- **Модульная архитектура пакетов**: Функции организованы в пакеты `-frt` (фронтенд) и `-srv`
  (бэкенд) в директории `packages/`
- **Стартовые страницы**: Лендинг для гостей (вход / регистрация) и страница приветствия,
  маршрутизация через автозагрузку `AuthManager` по состоянию Supabase-аутентификации
- **Сохранение сессии**: Сессия авторизации хранится локально в `user://session.json`
- **Двуязычная документация**: Полная документация на английском и русском языках

## Архитектура

Весь доступ к Supabase осуществляется через локальный бэкенд-сервер. Фронтенд (`start-frt`)
взаимодействует только с бэкендом (`start-srv`), который хранит учётные данные Supabase:

```
[Фронтенд — start-frt]         [Бэкенд — start-srv]         [Supabase Cloud]
  Автозагрузка AuthManager →  BackendServer + AuthAPI    →   REST Auth API
  нет SUPABASE_URL/KEY          хранит SUPABASE_URL/KEY       (внешний)
  вызывает http://127.0.0.1:8080  проксирует в Supabase
```

Бэкенд запускается как автозагрузка `BackendServer`, которая запускает лёгкий HTTP-сервер,
принимающий запросы от фронтенда на `127.0.0.1:8080` (настраивается через `BACKEND_PORT`).

## Структура проекта

```
universo-platformo-godot/
├── packages/
│   ├── start-frt/base/          # Фронтенд стартовой страницы
│   │   ├── scenes/              #   Сцены гостевой и авторизованной страниц
│   │   └── scripts/             #   Скрипты контроллеров страниц
│   ├── start-srv/base/          # Бэкенд стартовой страницы
│   │   └── scripts/             #   HTTP-сервер + прокси Auth API к Supabase
│   ├── clusters-frt/base/       # Кластеры фронтенд (заглушка плагина)
│   └── clusters-srv/base/       # Кластеры бэкенд (заглушка плагина)
├── scenes/
│   └── main.tscn                # Главная сцена — точка входа с маршрутизацией
├── scripts/
│   └── autoload/
│       ├── config.gd            #   Читает .env и config.json
│       ├── database_manager.gd  #   Интерфейс базы данных (Supabase)
│       ├── network_manager.gd   #   Многопользовательская сеть Godot ENet
│       ├── backend_server.gd    #   Запускает локальный HTTP-бэкенд
│       └── auth_manager.gd      #   Состояние авторизации фронтенда (через бэкенд)
├── .env.example                 # Шаблон переменных окружения
├── config.json                  # Конфигурация функций приложения
└── project.godot                # Конфигурация проекта Godot
```

## Пакеты

### start-frt — Фронтенд стартовой страницы

Лендинг для гостей с формами входа и регистрации по email/паролю. Страница приветствия
авторизованного пользователя с информацией и кнопкой выхода. `scenes/main.tscn` управляет
маршрутизацией через `AuthManager.is_authenticated` и сигнал `auth_state_changed`.

### start-srv — Бэкенд стартовой страницы

Лёгкий HTTP/1.1-сервер (`http_server.gd`) на `127.0.0.1:BACKEND_PORT`.
Обработчик Auth API (`auth_api.gd`) проксирует вход, регистрацию и выход в Supabase,
используя учётные данные из `.env`. **Только этот пакет обращается к `SUPABASE_URL`/`SUPABASE_KEY`.**

### clusters-frt / clusters-srv — Кластеры

Заглушки плагинов для функции Кластеров. Фронтенд управляет UI кластеров; бэкенд обрабатывает
данные и API кластеров. Полная реализация запланирована в следующих итерациях.

## Технологический стек

| Компонент          | Технология                                    |
|--------------------|-----------------------------------------------|
| Движок             | Godot 4.3+ (GDScript)                         |
| UI фронтенда       | Сцены Godot и узлы Control                    |
| Бэкенд-сервер      | Пользовательский HTTP-сервер GDScript (TCPServer) |
| База данных / Auth | Supabase (PostgreSQL + GoTrue Auth)           |
| Прокси авторизации | GDScript HTTPRequest → Supabase REST API      |
| Хранение сессии    | Локальный файл `user://session.json`          |
| Многопользовательский | Godot ENet высокоуровневый API               |

## Начало работы

### Предварительные требования

- [Godot Engine 4.3+](https://godotengine.org/download/) (рекомендуется последняя стабильная)
- Git
- Проект [Supabase](https://supabase.com) с включённой аутентификацией

### Установка

1. Клонируйте репозиторий:

```bash
git clone https://github.com/teknokomo/universo-platformo-godot.git
cd universo-platformo-godot
```

2. Скопируйте шаблон окружения и настройте:

```bash
cp .env.example .env
```

Отредактируйте `.env`, указав ваши значения:

```env
BACKEND_PORT=8080
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key-here
```

3. Откройте проект в редакторе Godot:

```bash
godot --editor project.godot
```

### Запуск

Нажмите **F5** в редакторе Godot или запустите из командной строки:

```bash
godot --path . res://scenes/main.tscn
```

Приложение запускает HTTP-бэкенд и стартовую страницу фронтенда.
Без настроенного `.env` бэкенд выводит предупреждение, а формы авторизации
возвращают ошибку «Backend not configured» при отправке.

## Статус проекта

- [x] Структура репозитория и настройка проекта Godot
- [x] Система автозагрузок (Config, DatabaseManager, NetworkManager)
- [x] Бэкенд HTTP-сервер (BackendServer, HTTPServer, AuthAPI)
- [x] Прокси авторизации Supabase (вход, регистрация, выход через бэкенд)
- [x] Фронтенд-менеджер авторизации (все вызовы только через бэкенд)
- [x] Стартовая страница: лендинг для гостей с формой входа / регистрации
- [x] Стартовая страница: приветствие авторизованного пользователя с выходом
- [x] Заглушки пакетов Кластеров (clusters-frt, clusters-srv)
- [ ] Полная реализация Кластеров
- [ ] Пакеты Метавселенных, Пространств, Уников
- [ ] Сцена для запуска в режиме сервера без графики

## Связанные проекты

- [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react) —
  эталонная реализация на React/Express
- Документация: `docs.universo.pro` (скоро)

## Лицензия

[Информация о лицензии будет добавлена]

## Сообщество и поддержка

- **Issues**: [GitHub Issues](https://github.com/teknokomo/universo-platformo-godot/issues)
- **Обсуждения**: [GitHub Discussions](https://github.com/teknokomo/universo-platformo-godot/discussions)
- **Документация**: Скоро на `docs.universo.pro`
