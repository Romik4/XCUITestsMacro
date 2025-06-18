import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ReturnSelfMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let functionDecl = declaration.as(FunctionDeclSyntax.self) else {
            return []
        }

        if functionDecl.signature.returnClause != nil {
            return []
        }

        // 1. Создаем атрибут @discardableResult.
        let discardableResultAttributeElement = AttributeSyntax(
            attributeName: IdentifierTypeSyntax(name: .identifier("discardableResult"))
        )

        // 2. Создаем оператор 'return self'
        let returnSyntax: ReturnStmtSyntax = ReturnStmtSyntax(
            returnKeyword: .keyword(.return, trailingTrivia: .space),
            expression: DeclReferenceExprSyntax(baseName: .identifier("self"))
        )

        // 3. Копируем существующее тело функции
        let currentBodyStatements = functionDecl.body?.statements ?? CodeBlockItemListSyntax([])
        var statements = currentBodyStatements
        statements.append(CodeBlockItemSyntax(item: .stmt(StmtSyntax(returnSyntax))))
        let newStatements = statements
        let newFunctionBody = CodeBlockSyntax(statements: newStatements)

        // 4. Копируем существующую сигнатуру функции и добавляем тип возврата 'Self'
        let newSignature = functionDecl.signature.with(
            \.returnClause,
            ReturnClauseSyntax(
                arrow: .arrowToken(),
                type: IdentifierTypeSyntax(name: .identifier("Self"))
            )
        )

        // 5. Создаем НОВУЮ функцию с другим именем чтобы избежать конфликта
        let originalName = functionDecl.name.text
        let newName = TokenSyntax.identifier(originalName + "AndReturnSelf")

        // Управляем атрибутами:
        // Фильтруем атрибуты, исключая @returnSelf чтобы избежать рекурсии
        var newAttributes = AttributeListSyntax([])
        
        for attribute in functionDecl.attributes {
            if let attributeSyntax = attribute.as(AttributeSyntax.self) {
                if attributeSyntax.attributeName.description != "returnSelf" {
                    newAttributes.append(attribute)
                }
            } else {
                newAttributes.append(attribute)
            }
        }
        
        // Добавляем @discardableResult
        newAttributes.append(AttributeListSyntax.Element(discardableResultAttributeElement))

        if let lastAttributeIndex = newAttributes.indices.last {
            let lastAttribute = newAttributes[lastAttributeIndex].as(AttributeSyntax.self)!
            newAttributes[lastAttributeIndex] = AttributeListSyntax.Element(lastAttribute.with(\.trailingTrivia, .newline))
        }
        let newFuncKeyword = TokenSyntax.keyword(.func, leadingTrivia: .spaces(4))
        
        // Создаем новую функцию с измененным именем
        let generatedFunction = functionDecl
            .with(\.attributes, newAttributes)
            .with(\.funcKeyword, newFuncKeyword)
            .with(\.name, newName)
            .with(\.body, newFunctionBody)
            .with(\.signature, newSignature)
            .with(\.leadingTrivia, .spaces(4))

        return [DeclSyntax(generatedFunction)]
    }
}

@main
struct YourMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ReturnSelfMacro.self,
    ]
}
