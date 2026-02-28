# Пакет стартовой страницы (Start Frontend)

## Обзор

Пакет Start Frontend предоставляет стартовую страницу для Universo Platformo. Он реализует аналог React-пакета `start-frontend/base`, адаптированный для Godot 4.6 и GDScript.

## Возможности

- **Стартовая страница для гостей** — лендинг для неавторизованных пользователей с формами входа и регистрации
- **Стартовая страница для авторизованных** — страница приветствия для вошедших пользователей с кнопкой выхода
- **Аутентификация Supabase** — подключение к Supabase через HTTP REST API (через автозагрузку `AuthManager`)
- **Сохранение сессии** — сессия сохраняется локально и восстанавливается при следующем запуске

## Структура

```
packages/start-frt/base/
├── scenes/
│   ├── guest_start_page.tscn        # Лендинг для неавторизованных
│   └── authenticated_start_page.tscn  # Страница для авторизованных
├── scripts/
│   ├── guest_start_page.gd          # Логика гостевой страницы (вход / регистрация)
│   └── authenticated_start_page.gd  # Логика страницы авторизованных (выход)
├── plugin.cfg                       # Конфигурация плагина
├── plugin.gd                        # Точка входа плагина
├── README.md                        # Английская версия
└── README-RU.md                     # Данный файл
```

## Архитектура

Маршрутизация стартовой страницы управляется `scenes/main.tscn` и `scenes/main.gd`, которые:

1. Показывают экран загрузки во время проверки состояния аутентификации
2. Отображают `GuestStartPage` для неавторизованных пользователей
3. Отображают `AuthenticatedStartPage` для авторизованных пользователей
4. Реагируют на сигнал `AuthManager.auth_state_changed` для переключения представлений

Автозагрузка `AuthManager` (`scripts/autoload/auth_manager.gd`) управляет всей аутентификацией Supabase:
- Вход через `POST /auth/v1/token?grant_type=password`
- Регистрация через `POST /auth/v1/signup`
- Выход через `POST /auth/v1/logout`
- Хранение сессии в `user://session.json`

## Установка

Этот пакет является частью монорепозитория Universo Platformo Godot. Сцены стартовой страницы загружаются из `scenes/main.tscn`.

### Настройка учётных данных Supabase

1. Скопируйте `.env.example` в `.env` в корне проекта
2. Укажите URL вашего проекта Supabase и анонимный ключ:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key-here
```

### Включение плагина (опционально)

1. Откройте Настройки проекта → Плагины
2. Найдите "Start Frontend" в списке
3. Включите плагин

## Использование

### Вход

`GuestStartPage` обрабатывает вход автоматически при отправке формы. Вы также можете вызвать `AuthManager` напрямую:

```gdscript
AuthManager.sign_in("user@example.com", "password123")
AuthManager.signed_in.connect(func(user): print("Вошёл: ", user.get("email")))
AuthManager.sign_in_failed.connect(func(error): print("Ошибка: ", error))
```

### Регистрация

```gdscript
AuthManager.sign_up("newuser@example.com", "password123")
```

### Выход

```gdscript
AuthManager.sign_out()
AuthManager.signed_out.connect(func(): print("Вышел"))
```

### Проверка состояния аутентификации

```gdscript
if AuthManager.is_authenticated:
    var user = AuthManager.get_user()
    print("Вошёл как: ", user.get("email"))
```

## Интеграция

Пакет интегрируется с:
- **Автозагрузка AuthManager** — `scripts/autoload/auth_manager.gd`
- **Автозагрузка Config** — читает `SUPABASE_URL` и `SUPABASE_KEY` из `.env`
- **Автозагрузка DatabaseManager** — интеграция с базой данных Supabase
- **Главная сцена** — `scenes/main.tscn` / `scenes/main.gd`

## Зависимости

- Godot Engine 4.3+
- Проект Supabase с включённой аутентификацией
- `SUPABASE_URL` и `SUPABASE_KEY`, настроенные в `.env`

## Участие в разработке

Смотрите основной [CONTRIBUTING-RU.md](../../../CONTRIBUTING-RU.md) для руководства по участию.

## Лицензия

[Информация о лицензии будет добавлена]
