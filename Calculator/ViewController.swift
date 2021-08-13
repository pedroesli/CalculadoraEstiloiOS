//
//  ViewController.swift
//  Calculator
//
//  Created by Pedro Ésli Vieira do Nascimento on 11/08/21.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController, UIInputViewAudioFeedback {
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    weak var prevSelectedOperatorButton: UIButton?
    weak var selectedOperatorButton: UIButton?
    
    var calculatorManager: CalculatorManager!
    
    var enableInputClicksWhenVisible: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculatorManager = CalculatorManager(displayLabel: displayLabel)
    }
    
    //MARK: Clear Key
    @IBAction func clearPressed(_ sender: UIButton) {
        SystemSound.playClickSound()
        
        if calculatorManager.canAllClear{
            calculatorManager.allClear()
        }
        else{
            calculatorManager.clear()
            clearButton.setTitle("AC", for: .normal)
        }
    }
    
    
    //MARK: Operators Keys
    @IBAction func plusPressed(_ sender: UIButton) {
        basicMathOperatorButtonPressed(sender: sender, operationKey: .plus)
    }
    
    @IBAction func minusPressed(_ sender: UIButton) {
        basicMathOperatorButtonPressed(sender: sender, operationKey: .minus)
    }
    
    @IBAction func multiplyPressed(_ sender: UIButton) {
        basicMathOperatorButtonPressed(sender: sender, operationKey: .multiply)
    }
    
    @IBAction func dividePressed(_ sender: UIButton) {
        basicMathOperatorButtonPressed(sender: sender, operationKey: .divide)
    }
    
    @IBAction func percentPressed(_ sender: UIButton) {
        calculatorManager.operation = .percent
        SystemSound.playClickSound()
    }
    
    @IBAction func equalPressed(_ sender: UIButton) {
        calculatorManager.calculate()
        SystemSound.playClickSound()
    }
    
    @IBAction func plusMinusPressed(_ sender: UIButton) {
        calculatorManager.switchSign()
        SystemSound.playClickSound()
    }
    
    //MARK: Number Keys
    @IBAction func commaPressed(_ sender: UIButton) {
        numberButtonPressed(numberKey: .comma)
    }
    
    @IBAction func zeroPressed(_ sender: UIButton) {
        numberButtonPressed(numberKey: .zero)
    }
    
    @IBAction func onePressed(_ sender: UIButton) {
        numberButtonPressed(numberKey: .one)
    }
    
    @IBAction func twoPressed(_ sender: UIButton) {
        numberButtonPressed(numberKey: .two)
    }
    
    @IBAction func threePressed(_ sender: UIButton) {
        numberButtonPressed(numberKey: .three)
    }
    
    @IBAction func fourPressed(_ sender: UIButton) {
        numberButtonPressed(numberKey: .four)
    }
    
    @IBAction func fivePressed(_ sender: UIButton) {
        numberButtonPressed(numberKey: .five)
    }
    
    @IBAction func sixPressed(_ sender: UIButton) {
        numberButtonPressed(numberKey: .six)
    }
    
    @IBAction func sevenPressed(_ sender: UIButton) {
        numberButtonPressed(numberKey: .seven)
    }
    
    @IBAction func eightPressed(_ sender: UIButton) {
        numberButtonPressed(numberKey: .eight)
    }
    
    @IBAction func ninePressed(_ sender: UIButton) {
        numberButtonPressed(numberKey: .nine)
    }
    
}

//MARK: Button Pressed Methods
extension ViewController{
    func numberButtonPressed(numberKey: CalculatorManager.NumberKey){
        animateToOrange(button: selectedOperatorButton)
        calculatorManager.appendNumberKey(numberKey)
        clearButton.setTitle("C", for: .normal)
        calculatorManager.canAllClear = false
        SystemSound.playClickSound()
    }
    
    func basicMathOperatorButtonPressed(sender: UIButton, operationKey: CalculatorManager.OperationKey){
        selectedOperatorButton = sender
        animateToWhite(button: sender)
        calculatorManager.operation = operationKey
        SystemSound.playClickSound()
    }
}

//MARK: Button animation
extension ViewController{
    func animateOnPress(button: UIButton){
        let oldColor = button.backgroundColor
        let newColor = UIColor.systemGray
        
        UIView.animate(withDuration: 0.1) {
            button.backgroundColor = newColor
        } completion: { completed in
            if completed {
                UIView.animate(withDuration: 0.3) {
                    button.backgroundColor = oldColor
                }
            }
        }
    }
    
    func animateToWhite(button: UIButton?){
        guard let buttonToAnimate = button else{
            return
        }
        
        if prevSelectedOperatorButton == buttonToAnimate{
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            buttonToAnimate.backgroundColor = UIColor.white
            buttonToAnimate.tintColor = UIColor.systemOrange
            
            if let prevButton = self.prevSelectedOperatorButton{
                self.animateToOrange(button: prevButton)
            }
        }
        
        prevSelectedOperatorButton = buttonToAnimate
    }
    
    func animateToOrange(button: UIButton?){
        guard let buttonToAnimate = button else{
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            buttonToAnimate.backgroundColor = UIColor.systemOrange
            buttonToAnimate.tintColor = UIColor.white
        }
        
        prevSelectedOperatorButton = nil
    }
}

//MARK: Button config
extension UIButton{
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        //layer.cornerRadius = 0.5 * bounds.size.height
    }
}

struct SystemSound {
    //For more info on system sound ids: https://github.com/TUNER88/iOSSystemSoundsLibrary
    static func playClickSound(){
        AudioServicesPlaySystemSound(1104)
    }
}
