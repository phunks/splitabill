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
    

    @IBOutlet weak var priceTextField: UILabel!
    
    @IBAction func numberPressed(_ sender: RoundButton) {
        if runningNumber.count <= 8 {
            runningNumber += "\(sender.tag)"
            if runningNumber.count == 2 {
                let regex:NSRegularExpression = try! NSRegularExpression(pattern: "^0", options: NSRegularExpression.Options.caseInsensitive)
                let range = NSMakeRange(0, (runningNumber.count))
                let modString = regex.stringByReplacingMatches(in: runningNumber, options: [], range: range, withTemplate: "")
                runningNumber = modString
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
        
        if sender.direction == .right {
            print("Right")
        }
        else if sender.direction == .left {
            print("Left")
            priceTextField.becomeFirstResponder()
            //let price = priceTextField.text
            //priceTextField.text = price?.prefix(through: str((price?.count)! - 1))
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
            let regex = try! NSRegularExpression(pattern: "\\..*", options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, (txt?.count)!)
            let modString = regex.stringByReplacingMatches(in: txt!, options: [], range: range, withTemplate: "")
            priceString = String(abs(Int(modString)!) * -1)
        }
    }

}
