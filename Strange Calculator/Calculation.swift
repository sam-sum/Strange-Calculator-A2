//
//  MAPD714 F22
//  Assignment 2
//  Group 8
//  Member: Suen, Chun Fung (Alan) 301277969
//          Sum, Chi Hung (Samuel) 300858503
//          Wong, Po Lam (Lizolet) 301258847
//  Date:   Oct 9, 2022
//
//  ViewController.swift
//  Strange Calculator - A simple calculator with a strange key layout
//  Version 0.3
//

import Foundation

class Calculation {
    static let shared = Calculation()
    private var inputString: String = "0"
    private var result: String = ""
    private var isEndCalcuation = true
    
    private init(){}
    
    func getResult() -> String {
        return result
    }

    func getSteps(_ numChar: Int) -> String {
        return String(inputString.suffix(numChar))
    }
    
    func handleNumberInput(inNum: String, outChar: Int) -> (String, String) {
        // if a calculation has been completed (isEndCalcuation), the input digit will replace the previous steps
        
        // allow digits input only if the previous char is not a %, )
        if !(inputString.last == "%" || inputString.last == ")") {
            switch inNum {
            case "0":
                //not doing anything if the existing steps contains only a zero
                if inputString != "0" {
                    inputString = (isEndCalcuation) ? "0" : inputString.appending(inNum)
                }
                evaluateAnswer()
            case "1", "2", "3", "4", "5", "6", "7", "8", "9":
                inputString = (inputString == "0" || isEndCalcuation) ? inNum : inputString.appending(inNum)
                evaluateAnswer()
            case ".":
                // allow a period input only if the previous char is a number
                if inputString.last == "1" || inputString.last == "2" || inputString.last == "3" || inputString.last == "4" || inputString.last == "5" || inputString.last == "6" || inputString.last == "7" || inputString.last == "8" || inputString.last == "9" || inputString.last == "0" {
                    // allow a period input onces per operand
                    if !hasDecmial() {
                        inputString = inputString.appending(inNum)
                    }
                }
            default:
                print ("func saveNumInput: \(inNum) not handled")
            }
        }
        isEndCalcuation = false
        
        return (String(inputString.suffix(outChar)), result)
    }

    func handleSpecialKeys(inKey: String, outChar: Int) -> (String, String) {
        switch inKey {
        case "AC":
            // clear all pressed
            inputString = "0"
            result = ""
            isEndCalcuation = true
        case "←":
             // back key pressed
            if inputString.last == ")" {
                //handle deletion of a -ve value
                makeLastOperandPositive()
            } else {
                // just remove the last character
                inputString = String(inputString.dropLast())
            }
            if inputString.isEmpty {
                inputString = "0"
                isEndCalcuation = true
            }
            evaluateAnswer()
        default:
            print ("func handleSpecialKeys: \(inKey) not handled")
        }
        return (String(inputString.suffix(outChar)), result)
    }
    
    func handleOperaters(inKey: String, outChar: Int) -> (String, String) {
        switch inKey {
        case "+", "-", "x", "÷":
            if inputString.last == "+" || inputString.last == "-" || inputString.last == "x" || inputString.last == "÷" || inputString.last == "." {
                inputString = String(inputString.dropLast())
            }
            inputString = inputString.appending(inKey)
            isEndCalcuation = false
        case "%":
            // allow a percentage input only if the previous char is a number
            if inputString.last == "1" || inputString.last == "2" || inputString.last == "3" || inputString.last == "4" || inputString.last == "5" || inputString.last == "6" || inputString.last == "7" || inputString.last == "8" || inputString.last == "9" || inputString.last == "0" {
                inputString = inputString.appending(inKey)
            }
            isEndCalcuation = false
            evaluateAnswer()
        case "+/-":
            // add a pair of () to wrap the number as -ve
            // allow to make -ve only if the previous char is a number or %
            if inputString.last == "1" || inputString.last == "2" || inputString.last == "3" || inputString.last == "4" || inputString.last == "5" || inputString.last == "6" || inputString.last == "7" || inputString.last == "8" || inputString.last == "9" || inputString.last == "0" || inputString.last == "%" {
                makeLastOperandNegative()
            } else if inputString.last == ")" {
                // switch the -ve value to +ve
                makeLastOperandPositive()
            }
            isEndCalcuation = false
            evaluateAnswer()
        case "=":
            //clear the steps and replace it with the final answer
            evaluateAnswer()
            isEndCalcuation = true
            inputString = result
            result = ""
        default:
            print ("func handleOperaters: \(inKey) not handled")
        }
        return (String(inputString.suffix(outChar)), result)
    }
    
    private func hasDecmial() -> Bool {
        var found: Bool = false
        for ch in inputString.reversed() {
            if ch == "+" || ch == "-" || ch == "x" || ch == "÷" {
                break
            }
            if ch == "." {
                found = true
            }
        }
        return found
    }
    
    private func makeLastOperandNegative() {
        var extractedString = ""
        var charCount = 0
        // search the inputString backward for a operand and save to a temp var
        for ch in inputString.reversed() {
            if (ch.isASCII && ch.isNumber) || ch == "." || ch == "%" {
                extractedString.append(ch)
                charCount += 1
            } else if ch == "+" || ch == "-" || ch == "x" || ch == "÷" {
                break
            }
        }
        extractedString = String(extractedString.reversed())
        print("func makeLastOperandNegative: extractedString is \(extractedString)")
        
        // drop the last operand from the original inputString and append the -ve value
        inputString = String(inputString.dropLast(charCount)).appending("(-").appending(extractedString).appending(")")
        print("func makeLastOperandNegative: new inputString is \(inputString)")
    }
    
    private func makeLastOperandPositive() {
        var extractedString = ""
        var charCount = 0
        // search the inputString backward for a operand in () and save to a temp var
        for ch in inputString.reversed() {
            if (ch.isASCII && ch.isNumber) || ch == "." || ch == "%" {
                extractedString.append(ch)
                charCount += 1
            } else if ch == "+" || ch == "-" || ch == "x" || ch == "÷" {
                break
            }
        }
        charCount += 3  //add 3 more characters (, -, ) to the counter
        extractedString = String(extractedString.reversed())
        print("func makeLastOperandNegative: extractedString is \(extractedString)")
        
        // drop the last operand from the original inputString and append the +ve value
        inputString = String(inputString.dropLast(charCount)).appending(extractedString)
        print("func makeLastOperandNegative: new inputString is \(inputString)")
    }
    
    private func evaluateAnswer() {
        // play safe to discard calls if the inputString is incomplete
        let char = inputString.last
        if char == "+" || char == "-" || char == "x" || char == "÷" || char == "."  {
            return
        }
        // tokenize the input string from left to right
        var tokens: [String] = tokenizeInputString()
        print("func evaluateAnswer: tokens array is \(tokens)")
        
        // evaluate the tokens from left to right and only handle x, ÷
        // by repeating the loop from the beginning after a pair of operands are calculated
        var counter = 1
        while counter < tokens.count  {
            var foundOperator = false
            while counter < tokens.count{
                switch tokens[counter] {
                case "x":   // multiply
                    let answer: Double = (Double(tokens[counter - 1]) ?? 0.0) * (Double(tokens[counter + 1]) ?? 0.0)
                    tokens = replaceTokens(originalTokens: tokens, newToken: String(format: "%.10f", answer), index: counter)
                    foundOperator = true
                case "÷":   // divide
                    let answer: Double = (Double(tokens[counter - 1]) ?? 0.0) / (Double(tokens[counter + 1]) ?? 0.0)
                    tokens = replaceTokens(originalTokens: tokens, newToken: String(format: "%.10f", answer), index: counter)
                    foundOperator = true
                default:    // do nothing
                    break
                }
                counter += 1
                print("func evaluateAnswer: New tokens array is \(tokens)")
                break
            }
            if foundOperator == true {      // at least did 1 calculation, loop again all tokens
                counter = 1
            }
        }

        // evaluate the tokens from left to right and only handle +, -
        // by repeating the loop from the beginning after a pair of operands are calculated
        counter = 1
        while counter < tokens.count  {
            var foundOperator = false
            while counter < tokens.count{
                switch tokens[counter] {
                case "+":   // add
                    let answer: Double = (Double(tokens[counter - 1]) ?? 0.0) + (Double(tokens[counter + 1]) ?? 0.0)
                    tokens = replaceTokens(originalTokens: tokens, newToken: String(format: "%.10f", answer), index: counter)
                    foundOperator = true
                case "-":   // subract
                    let answer: Double = (Double(tokens[counter - 1]) ?? 0.0) - (Double(tokens[counter + 1]) ?? 0.0)
                    tokens = replaceTokens(originalTokens: tokens, newToken: String(format: "%.10f", answer), index: counter)
                    foundOperator = true
                default:    // do nothing
                    break
                }
                counter += 1
                print("func evaluateAnswer: New tokens array is \(tokens)")
                break
            }
            if foundOperator == true {      // at least did 1 calculation, loop again all tokens
                counter = 1
            }
        }
        //update result label only if the final value is numeric
        updateResult(tokens)
    }
    
    private func tokenizeInputString() -> [String] {
        var workingTokens = [String]()
        var extractedString = ""
        var isHandlingbrackets = false
        
        for ch in inputString {
            if ch == "(" {
                // handle all char in the ()
                isHandlingbrackets = true
            } else if ch == ")" {
                // finished all char in ()
                isHandlingbrackets = false
            } else if isHandlingbrackets || (ch != "+" && ch != "-" && ch != "x" && ch != "÷") {
                extractedString.append(ch)
            } else {
                // found an operator. now to save the working operand
                workingTokens.append(extractedString)
                extractedString = ""
                workingTokens.append(String(ch))
            }
        }
        // handle the last operand
        if !extractedString.isEmpty {
            workingTokens.append(extractedString)
        }
        // transform the percentage values into decmials
        var idx = 0
        for aToken in workingTokens {
            if aToken.last == "%" {
                workingTokens[idx] = String(format: "%.10f", (Double(aToken.dropLast()) ?? 0)  / 100.0)
            }
            idx += 1
        }
        return workingTokens
    }
    
    private func replaceTokens(originalTokens: [String], newToken: String, index: Int) -> [String] {
        // remove a pair of operands an their operator. Than add back the result into the original position
        var newTokens = originalTokens
        newTokens.remove(at: index - 1)
        newTokens.remove(at: index - 1)
        newTokens.remove(at: index - 1)
        newTokens.insert(newToken, at: index - 1)
        
        return newTokens
    }
    
    private func updateResult(_ inTokens: [String]) {
        //update the result label only if it is an valid evaluation
        if inTokens.count == 1 {
            if let number = Double(inTokens[0]) {
                if Double(Int(number)) == number {
                    // the result is an integer, remove the trailing zero
                    result = String(Int(number))
                } else {
                    result = String(number)
                }
            }
        }
    }
}
