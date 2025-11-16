# Пакет фронтенда кластеров

## Обзор

Пакет фронтенда кластеров обеспечивает клиентскую реализацию системы кластеров в Universo Platformo. Он управляет пользовательским интерфейсом и клиентской логикой для работы с кластерами, доменами и ресурсами.

## Возможности

- UI управления кластерами
- Интерфейс организации доменов
- Просмотр и управление ресурсами
- Обновления в реальном времени через сетевую синхронизацию

## Структура

```
packages/clusters-frt/base/
├── scenes/              # UI-сцены
│   ├── cluster_list.tscn
│   ├── cluster_detail.tscn
│   ├── domain_list.tscn
│   └── resource_browser.tscn
├── scripts/             # Клиентская логика
│   ├── cluster_manager.gd
│   ├── domain_controller.gd
│   └── resource_handler.gd
├── plugin.cfg           # Конфигурация плагина
├── plugin.gd            # Точка входа плагина
├── README.md            # Английская версия
└── README-RU.md        # Этот файл (русский)
```

## Установка

Этот пакет является частью монорепозитория Universo Platformo Godot и автоматически доступен при открытии проекта.

Чтобы включить плагин:
1. Откройте Настройки проекта → Плагины
2. Найдите "Clusters Frontend" в списке
3. Включите плагин

## Использование

### Создание кластера

```gdscript
var cluster_manager = ClusterManager.new()
var new_cluster = cluster_manager.create_cluster({
    "name": "My Cluster",
    "description": "A sample cluster"
})
```

### Управление доменами

```gdscript
var domain_controller = DomainController.new()
domain_controller.add_domain(cluster_id, {
    "name": "Production",
    "type": "environment"
})
```

### Просмотр ресурсов

```gdscript
var resource_handler = ResourceHandler.new()
var resources = resource_handler.list_resources(domain_id)
```

## Справочник API

### ClusterManager

Основной класс для управления кластерами на стороне клиента.

**Методы:**
- `create_cluster(data: Dictionary) -> Dictionary`
- `get_cluster(cluster_id: String) -> Dictionary`
- `update_cluster(cluster_id: String, data: Dictionary) -> bool`
- `delete_cluster(cluster_id: String) -> bool`
- `list_clusters() -> Array`

### DomainController

Управляет доменами внутри кластеров.

**Методы:**
- `add_domain(cluster_id: String, data: Dictionary) -> Dictionary`
- `get_domain(domain_id: String) -> Dictionary`
- `update_domain(domain_id: String, data: Dictionary) -> bool`
- `delete_domain(domain_id: String) -> bool`
- `list_domains(cluster_id: String) -> Array`

### ResourceHandler

Обрабатывает ресурсы внутри доменов.

**Методы:**
- `add_resource(domain_id: String, data: Dictionary) -> Dictionary`
- `get_resource(resource_id: String) -> Dictionary`
- `update_resource(resource_id: String, data: Dictionary) -> bool`
- `delete_resource(resource_id: String) -> bool`
- `list_resources(domain_id: String) -> Array`

## Интеграция

Этот пакет интегрируется с:
- **Пакетом сервера кластеров**: Backend API для сохранения данных
- **Менеджером базы данных**: Интеграция с Supabase для хранения данных
- **Менеджером сети**: Синхронизация в реальном времени

## Разработка

### Добавление новых функций

1. Создайте новые файлы сцен в `scenes/`
2. Добавьте соответствующие скрипты в `scripts/`
3. Обновите этот README с новой функциональностью
4. Убедитесь, что английская версия (README.md) обновлена идентично

### Тестирование

Запустите основную сцену с включенным этим пакетом для тестирования функциональности кластеров:
```bash
godot --path . scenes/main.tscn
```

## Зависимости

- Godot Engine 4.x
- Universo Platformo Core
- Автозагрузка Database Manager
- Автозагрузка Network Manager

## Участие в разработке

См. главный [CONTRIBUTING.md](../../../CONTRIBUTING.md) проекта для руководства по участию.

## Лицензия

[Информация о лицензии будет добавлена]
