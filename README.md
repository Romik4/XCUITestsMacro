# ReturnSelfMacro

[![Swift](https://img.shields.io/badge/Swift-6.1+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20macCatalyst-lightgrey.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

ReturnSelfMacro - это Swift макрос, который автоматически генерирует версии функций с возвращаемым значением `Self` для методов без возвращаемого значения. Это позволяет создавать fluent API (цепочки вызовов методов) без написания дополнительного кода.

## 🚀 Возможности

- **Автоматическая генерация**: Создает новые функции с `@discardableResult` и возвратом `self`
- **Безопасность**: Работает только с функциями без возвращаемого значения
- **Совместимость**: Поддерживает классы и структуры (включая `mutating` функции)
- **Простота использования**: Достаточно добавить аннотацию `@returnSelf`
- **Уникальные имена**: Генерирует функции с суффиксом `AndReturnSelf` для избежания конфликтов

## 📋 Требования

- Swift 6.1+
- Xcode 15.0+
- macOS 10.15+, iOS 13+, tvOS 13+, watchOS 6+, macCatalyst 13+

## 📦 Установка

### Swift Package Manager

Добавьте зависимость в ваш `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Romik4/XCUITestsMacro.git", from: "1.0.0")
]
```

Или в Xcode:
1. File → Add Package Dependencies
2. Введите URL репозитория
3. Выберите версию

## 🎯 Использование

### Базовый пример

```swift
import ReturnSelfMacro

class User {
    var name: String = ""
    var age: Int = 0
    
    @returnSelf
    func setName(_ name: String) {
        self.name = name
    }
    
    @returnSelf
    func setAge(_ age: Int) {
        self.age = age
    }
    
    func printInfo() {
        print("Name: \(name), Age: \(age)")
    }
}

// Использование с цепочкой вызовов
let user = User()
    .setNameAndReturnSelf("John")
    .setAgeAndReturnSelf(25)
    .printInfo()
```

### Работа со структурами

```swift
import ReturnSelfMacro

struct Configuration {
    var host: String = "localhost"
    var port: Int = 8080
    var timeout: TimeInterval = 30.0
    
    @returnSelf
    mutating func setHost(_ host: String) {
        self.host = host
    }
    
    @returnSelf
    mutating func setPort(_ port: Int) {
        self.port = port
    }
    
    @returnSelf
    mutating func setTimeout(_ timeout: TimeInterval) {
        self.timeout = timeout
    }
}

// Использование
var config = Configuration()
    .setHostAndReturnSelf("api.example.com")
    .setPortAndReturnSelf(443)
    .setTimeoutAndReturnSelf(60.0)
```

### Что происходит под капотом

Когда вы используете `@returnSelf`, макрос автоматически генерирует новую функцию с суффиксом `AndReturnSelf`:

**Исходный код:**
```swift
@returnSelf
func incrementCounter() {
    counter += 1
}
```

**Сгенерированный код:**
```swift
@discardableResult
func incrementCounterAndReturnSelf() -> Self {
    counter += 1
    return self
}
```

**Важно**: Оригинальная функция остается неизменной, макрос создает дополнительную функцию для fluent API.

## ⚠️ Ограничения

- Макрос работает только с функциями, которые **не имеют возвращаемого значения** (Void)
- Функции с уже определенным типом возврата игнорируются
- Макрос создает **новую функцию** с суффиксом `AndReturnSelf`, не изменяя существующую
- Для fluent API используйте сгенерированные функции с суффиксом

## 🧪 Тестирование

Запустите тесты с помощью Swift Package Manager:

```bash
swift test
```

### Примеры тестов

Проект включает тесты для различных сценариев:

1. **Функции в классах** - проверка генерации для обычных методов
2. **Mutating функции в структурах** - проверка работы с изменяемыми методами
3. **Функции с возвращаемым значением** - проверка игнорирования таких функций

## 🏗️ Архитектура проекта

```
ReturnSelfMacro/
├── Sources/
│   ├── ReturnSelfMacro/           # Публичный API макроса
│   ├── ReturnSelfMacroMacros/     # Реализация макроса
│   └── ReturnSelfMacroClient/     # Примеры использования
├── Tests/
│   └── ReturnSelfMacroTests/      # Тесты
└── Package.swift                  # Конфигурация пакета
```

### Компоненты

- **ReturnSelfMacro**: Публичный интерфейс макроса
- **ReturnSelfMacroMacros**: Реализация логики генерации кода
- **ReturnSelfMacroClient**: Примеры использования и демонстрация

## 🔧 Разработка

### Локальная разработка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/Romik4/XCUITestsMacro.git
cd ReturnSelfMacro
```

2. Откройте проект в Xcode:
```bash
open Package.swift
```

3. Запустите тесты:
```bash
swift test
```

### Структура макроса

Макрос реализован как `PeerMacro`, который:
1. Анализирует функцию без возвращаемого значения
2. Создает новую функцию с суффиксом `AndReturnSelf`
3. Добавляет `@discardableResult` атрибут
4. Добавляет возврат `self` в конец тела функции
5. Устанавливает тип возврата как `Self`
6. Исключает атрибут `@returnSelf` из сгенерированной функции для избежания рекурсии

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. См. файл [LICENSE](LICENSE) для получения дополнительной информации.

## 🤝 Вклад в проект

Мы приветствуем вклад в развитие проекта! Пожалуйста:

1. Форкните репозиторий
2. Создайте ветку для новой функции (`git checkout -b feature/amazing-feature`)
3. Зафиксируйте изменения (`git commit -m 'Add amazing feature'`)
4. Отправьте в ветку (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## 📞 Поддержка

Если у вас есть вопросы или предложения, создайте [Issue](https://github.com/Romik4/XCUITestsMacro/issues) в репозитории.

---

**Примечание**: Этот макрос использует Swift Syntax для анализа и генерации кода. Убедитесь, что у вас установлена совместимая версия Swift и Xcode.
