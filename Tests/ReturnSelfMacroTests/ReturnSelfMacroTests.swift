import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import ReturnSelfMacroMacros
import XCTest

final class ReturnSelfMacroTests: XCTestCase {

    func testReturnSelfOnVoidFunctionInClass() {
        assertMacroExpansion(
            """
            class MyClass {
                private var value = 0
            
                @returnSelf
                func increment() {
                    value += 1
                }
            }
            """,
            expandedSource: """
            class MyClass {
                private var value = 0
                func increment() {
                    value += 1
                }

                @discardableResult
                    func increment() -> Self {
                        value += 1
                        return self
                }
            }
            """,
            macros: ["returnSelf": ReturnSelfMacro.self]
        )
    }

    func testReturnSelfOnVoidFunctionInStruct() {
        assertMacroExpansion(
            """
            struct MyStruct {
                private var value = 0

                @returnSelf
                mutating func update() {
                    value += 1
                }
            }
            """,
            expandedSource: """
            struct MyStruct {
                private var value = 0
                mutating func update() {
                    value += 1
                }

                @discardableResult

                    mutating     func update() -> Self {
                        value += 1
                        return self
                }
            }
            """,
            macros: ["returnSelf": ReturnSelfMacro.self]
        )
    }

    func testReturnSelfOnNonVoidFunction() {
        assertMacroExpansion(
            """
            class MyClass {
                @returnSelf
                func calculateResult() -> Int {
                    return 42
                }
            }
            """,
            expandedSource: """
            class MyClass {
                func calculateResult() -> Int {
                    return 42
                }
            }
            """,
            macros: ["returnSelf": ReturnSelfMacro.self]
        )
    }
}
