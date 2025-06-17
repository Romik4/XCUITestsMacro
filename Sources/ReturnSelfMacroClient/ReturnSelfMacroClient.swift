import ReturnSelfMacro


class MyClass {
    var counter: Int = 0
    var name: String = "Guest"

    // Пример 1: Простая функция без возвращаемого значения
    // Макрос @returnSelf применит к ней:
    // @discardableResult
    // func incrementCounter() -> Self {
    //     counter += 1
    //     return self
    // }
    @returnSelf
    func incrementCounter() {
        counter += 1
        print("Counter incremented to \(counter)")
    }

    // Пример 2: Еще одна функция без возвращаемого значения, с другим телом
    // Макрос @returnSelf применит к ней:
    // @discardableResult
    // func updateName(newName: String) -> Self {
    //     self.name = newName
    //     print("Name updated to \(name)")
    //     return self
    // }
    @returnSelf
    func updateName(newName: String) {
        self.name = newName
        print("Name updated to \(name)")
    }

    // Пример 3: Функция, которая уже имеет возвращаемое значение
    // Макрос НЕ должен ее модифицировать.
    func calculateSum(a: Int, b: Int) -> Int {
        return a + b
    }

    // Вывод текущего состояния
    func printState() {
        print("Current state: Counter = \(counter), Name = \(name)")
    }
}
