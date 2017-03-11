//: [Previous](@previous)

import Foundation

// Given an expression like this
// ( 1 + 2 ) * 5

// Parse and execute it!

enum MathOperator: String {
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
}

// Note we need to use indirect here because we are including the enum itself
// in our associated values for the expression case
indirect enum MathExpression {
    case numericLiteral(Int)
    case expression(MathExpression,MathOperator,MathExpression)

    func evaluate() -> Int {
        switch self {
        case let .numericLiteral(value):
            return value
        case let .expression(left, op, right):
            switch op {
            case .add:
                return left.evaluate() + right.evaluate()
            case .subtract:
                return left.evaluate() - right.evaluate()
            case .multiply:
                return left.evaluate() * right.evaluate()
            case .divide:
                return left.evaluate() / right.evaluate()
            }
        }
    }
}

let expression = "(1 + 2) * 5"

let one = MathExpression.numericLiteral(1)
let two = MathExpression.numericLiteral(2)
let five = MathExpression.numericLiteral(5)
let onePlusTwo = MathExpression.expression(one, .add, two)
let result = onePlusTwo.evaluate()
result

let resultTimesFive = MathExpression.expression(onePlusTwo, .multiply, five)
resultTimesFive.evaluate()

enum ExpressionToken {
    case openParens
    case number(Int)
    case closeParens
    case op(String)

    // This function kinda sucks and it can be improved quite a bit. But not the point
    // of this playground, so yeah.
    static func parse(expressionString: String) -> Queue<ExpressionToken> {

        let operators = ["+","-","*","/"]
        let numbers = ["0","1","2","3","4","5","6","7","8","9"]

        let tokens = Queue<ExpressionToken>()
        for token in expressionString.components(separatedBy: .whitespaces) {
            var literal = ""
            for character in token.characters {
                if character == "(" {
                    if literal != "", let literalNumber = Int(literal) {
                        tokens.enqueue(.number(literalNumber))
                        literal = ""
                    }
                    tokens.enqueue(.openParens)
                } else if character == ")" {
                    if literal != "", let literalNumber = Int(literal) {
                        tokens.enqueue(.number(literalNumber))
                        literal = ""
                    }
                    tokens.enqueue(.closeParens)
                } else if operators.contains(String(character)) {
                    if literal != "", let literalNumber = Int(literal) {
                        tokens.enqueue(.number(literalNumber))
                        literal = ""
                    }
                    tokens.enqueue(.op(String(character)))
                } else if numbers.contains(String(character)) {
                    literal += String(character)
                }
            }

            if literal != "", let literalNumber = Int(literal) {
                tokens.enqueue(.number(literalNumber))
            }
        }
        return tokens
    }
}

let testParsing = ExpressionToken.parse(expressionString: "1")
let testParsing2 = ExpressionToken.parse(expressionString: "(1 + 2)")
let testParsing3 = ExpressionToken.parse(expressionString: "(1+2)")
let testParsing4 = ExpressionToken.parse(expressionString: "(13+25)")
let testParsing5 = ExpressionToken.parse(expressionString: "((1+2)*( 5+(6/2) ))")

extension MathExpression {

    init(tokens: Queue<ExpressionToken>) {
        
        guard !tokens.isEmpty else {
            preconditionFailure("Trying to parse empty array of tokens")
        }

        guard let first = tokens.dequeue() else {
            preconditionFailure("Should never get here")
        }
        if tokens.isEmpty {
            guard case let .number(value) = first else {
                preconditionFailure("Error parsing single item")
            }
            self = .numericLiteral(value)
            return
        }

        // if first token is openParens, we need to recurse
        switch first {
        case .openParens:

            print("left:")
            print(tokens)
            let leftSide = MathExpression(tokens: tokens)
            guard let op = tokens.dequeue(), case let .op(value) = op else {
                preconditionFailure("Expecting operator token, but found something else instead")
            }

            guard let operatorValue = MathOperator(rawValue: value) else {
                preconditionFailure("Operator token invalid")
            }

            print("right:")
            print(tokens)
            let rightSide = MathExpression(tokens: tokens)
            self = .expression(leftSide, operatorValue, rightSide)

            // remove the close parens
            tokens.dequeue()
        case .closeParens:
            preconditionFailure("Close parens is out of order!")
        case .number(let value):
            self = .numericLiteral(value)

        case .op(_):
            preconditionFailure("Got an operator out of order!")
        }
    }
}

let expression1 = MathExpression(tokens: testParsing).evaluate()
let expression2 = MathExpression(tokens: testParsing2).evaluate()
let expression3 = MathExpression(tokens: testParsing3).evaluate()
let expression4 = MathExpression(tokens: testParsing4).evaluate()
let expression5 = MathExpression(tokens: testParsing5).evaluate()


//: [Previous](@previous) | [Next](@next)
