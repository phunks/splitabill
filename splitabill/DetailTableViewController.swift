//
//  DetailTableViewController.swift
//  split a bill
//
//  Created by kan manzawa on 2018/01/06.
//  Copyright © 2018 kan manzawa. All rights reserved.
//


import UIKit

enum Operation:String {
    case Add      = "+"
    case Subtract = "-"
    case Divide   = "/"
    case Multiply = "*"
    case NULL     = "Null"
}


class DetailTableViewController: UITableViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var editModelTextField: UITextField!
    
    var data:[String]!
    var price:[String]!
    var index:Int?
    var dataString:String?
    var priceString:String?
    
    // calc
    var displayValue  = ""
    var runningNumber = ""
    var leftValue     = ""
    var rightValue    = ""
    var result        = ""
    var currentOperation:Operation = .NULL
    var fieldEdit:Bool = false
    

    @IBOutlet weak var priceTextField: UILabel!
    
    @IBAction func numberPressed(_ sender: RoundButton) {
        if runningNumber.count <= 8 {
            fieldEdit = true
            runningNumber += "\(sender.tag)"
            if runningNumber.count == 2 {
                runningNumber = runningNumber.regexReplace(pattern: "^0", with: "")
            }
            priceTextField.text = runningNumber
        }
    }
    @IBAction func allClearPressed(_ sender: RoundButton) {
        displayValue  = ""
        runningNumber = ""
        leftValue     = ""
        rightValue    = ""
        result        = ""
        currentOperation = .NULL
        priceTextField.text = "0"
    }
    @IBAction func equalPressed(_ sender: RoundButton) {
        operation(operation: currentOperation)
    }
    @IBAction func addPressed(_ sender: RoundButton) {
        operation(operation: .Add)
    }
    @IBAction func subtractPressed(_ sender: RoundButton) {
        operation(operation: .Subtract)
    }
    @IBAction func multiplyPressed(_ sender: RoundButton) {
        operation(operation: .Multiply)
    }
    @IBAction func dividePressed(_ sender: RoundButton) {
        operation(operation: .Divide)
    }
    
    func operation(operation: Operation) {
        fieldEdit = false
        if currentOperation != .NULL && Double(leftValue) != nil {
            if runningNumber != "" {
                rightValue = runningNumber
                runningNumber = ""
                if currentOperation == .Add {
                    result = "\(Double(leftValue)! + Double(rightValue)!)"
                }else if currentOperation == .Subtract {
                    result = "\(Double(leftValue)! - Double(rightValue)!)"
                }else if currentOperation == .Multiply {
                    result = "\(Double(leftValue)! * Double(rightValue)!)"
                }else if currentOperation == .Divide {
                    result = "\(Double(leftValue)! / Double(rightValue)!)"
                }
                leftValue = result
                if (Double(result)!.truncatingRemainder(dividingBy: 1) == 0) {
                    result = "\(Int(Double(result)!))"
                }
                priceTextField.text = result
            }
            currentOperation = operation
            
        }else {
            leftValue = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editModelTextField.delegate = self
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DetailTableViewController.didSwipe(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DetailTableViewController.didSwipe(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        if index != nil {
            let item   = data[index!]
            let amount = price[index!]
            editModelTextField.text = item
            priceTextField.text     = amount.replacingOccurrences(of: "-", with: "")
            runningNumber = priceTextField.text!
        } else {
            editModelTextField.text = ""
            priceTextField.text     = "0"
        }
    }
    
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left || sender.direction == .right {
            priceTextField.becomeFirstResponder()
            let price = priceTextField.text!
            if fieldEdit == true {
                if price.count > 1 {
                    var txt:String = price.removeLastString()
                    if txt.regexMatch(pattern: "\\.$") {
                        txt = txt.regexReplace(pattern: "[^\\d]+$", with: "")
                    }
                    priceTextField.text = txt
                } else {
                    priceTextField.text = "0"
                }
                runningNumber = priceTextField.text!
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ editModelTextField: UITextField) -> Bool {
        editModelTextField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            editModelTextField.becomeFirstResponder()
        }
        else if indexPath.section == 1 && indexPath.row == 0 {
            editModelTextField.resignFirstResponder()
            priceTextField.becomeFirstResponder()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            dataString = editModelTextField.text
            let txt = priceTextField.text
            
            // 小数点以下切り捨て
            if (txt?.regexMatch(pattern: "e-"))! {
                priceString = "0"
            } else if (txt?.regexMatch(pattern: "\\."))! {
                priceString = String(abs(Int((txt?.regexReplace(pattern: "\\..*", with: ""))!)!) * -1)
            }
        }
    }

}
