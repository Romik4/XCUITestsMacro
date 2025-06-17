// The Swift Programming Language
// https://docs.swift.org/swift-book

/// Макрос `@returnSelf` генерирует новую функцию с тем же именем,
/// добавляя `@discardableResult` и `return self`.
@attached(peer, names: arbitrary)
public macro returnSelf() = #externalMacro(
    module: "ReturnSelfMacroMacros",
    type: "ReturnSelfMacro"
)
