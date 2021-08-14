//
//  CalculatorManager.swift
//  Calculator
//
//  Created by Pedro Ésli Vieira do Nascimento on 12/08/21.
//

import Foundation
import UIKit

class CalculatorManager {
    enum NumberKey: String {
        case zero = "0"
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case comma = ","
    }
    
    enum OperationKey {
        case equal
        case plus
        case minus
        case multiply
        case divide
        case clear
    }
    
    //To know which variable is selected
    private enum VariableState{
        case a
        case b
    }
    
    var displayLabel: UILabel
    var operation: OperationKey? {
        didSet{
            if operation != nil{
                selectedVar = .b
            }
            else{
                selectedVar = .a
            }
        }
    }
    var canAllClear: Bool = false
    
    private let resetString: String = "0"
    private let maxSize:Int = 9
    private var a: String
    private var b: String
    private var canTypeOnA: Bool = false
    private var selectedVar: VariableState = .a
    
    init(displayLabel: UILabel) {
        self.displayLabel = displayLabel
        self.a = resetString
        self.b = resetString
    }
    
    func appendNumberKey(_ numberKey: NumberKey){
        typeOnAAfterResult()
        
        switch selectedVar {
        case .a:
            appendVal(numberKey: numberKey, to: &a)
        case .b:
            appendVal(numberKey: numberKey, to: &b)
        }
    }
    
    private func appendVal(numberKey: NumberKey, to container: inout String){
        //Dont consider "," and "." in the count
        var count = 0
        container.forEach { char in
            if char != "." && char !=  ","{
                count += 1
            }
        }
        if count < maxSize{
            //add comma if needed
            if numberKey == .comma{
                if !container.contains(","){
                    displayLabel.text?.append(",")
                    container.append(",")
                }
            }
            else{
                container = (container + numberKey.rawValue).format()
                displayLabel.text = container
            }
        }
    }
    
    private func typeOnAAfterResult(){
        if canTypeOnA{
            selectedVar = .a
            a = resetString
            canTypeOnA = false
        }
    }
    
    func switchSign(){
        if displayLabel.text!.contains("-"){
            //Remove minus sign
            displayLabel.text?.remove(at: (displayLabel.text?.firstIndex(of: "-"))!)
            if selectedVar == .a{
                a.remove(at: a.firstIndex(of: "-")!)
            }
            else{
                b.remove(at: b.firstIndex(of: "-")!)
            }
        }
        else{
            //Add minus sign
            displayLabel.text?.insert("-", at: displayLabel.text!.startIndex)
            if operation == nil{
                a.insert("-", at: a.startIndex)
            }
            else{
                b.insert("-", at: b.startIndex)
            }
        }
    }
    
    func calculate(){
        guard let op = operation else{
            return
        }
        
        var valueA = a.toDouble()
        let valueB = b.toDouble()
        
        switch op {
        case .plus:
            valueA = valueA + valueB
        case .minus:
            valueA = valueA - valueB
        case .multiply:
            valueA = valueA * valueB
        case .divide:
            valueA = valueA / valueB
        default:
            print("Entered Calculate Default")
        }
        
        //set result
        a = valueA.format()
        displayLabel.text = a
        
        canTypeOnA = true
    }
    
    func calculatePercent(){
        var valueA = a.toDouble()
        //get the value directly from the display
        var valueB = displayLabel.text!.toDouble()
        
        switch operation{
        case .minus, .plus:
            valueB = valueA * (valueB / 100)
            
            b  = valueB.format()
            displayLabel.text = b
        case .multiply, .divide:
            valueB = valueB / 100
            
            b  = valueB.format()
            displayLabel.text = b
        default:
            //No operation selected
            valueA = valueA / 100
            
            a  = valueA.format()
            displayLabel.text = a
        }
    }
    
    func allClear(){
        a = resetString
        b = resetString
        operation = nil
        displayLabel.text = resetString
        canTypeOnA = false
    }
    
    func clear(){
        canAllClear = true
        a = resetString
        displayLabel.text = resetString
    }
}

extension String{
    func format() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 9
        numberFormatter.maximumIntegerDigits = 9
        numberFormatter.groupingSeparator = "."
        numberFormatter.decimalSeparator = ","
        
        //Remove or replace all "." and "," to be able to cast to Double
        let formatted = self.replacingOccurrences(of: ".", with: "")
        let num = numberFormatter.number(from: formatted)!.doubleValue
        return numberFormatter.string(for: num)!
    }
    
    func toDouble() -> Double{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formatted = self.replacingOccurrences(of: ".", with: "")
        return numberFormatter.number(from: formatted)!.doubleValue
    }
}

extension Double{
    func format() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 9
        numberFormatter.maximumIntegerDigits = 9
        numberFormatter.groupingSeparator = "."
        numberFormatter.decimalSeparator = ","
        
        return numberFormatter.string(for: self)!
    }
}
