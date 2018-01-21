//
//  MainTableViewController.swift
//  split a bill
//
//  Created by kan manzawa on 2018/01/06.
//  Copyright © 2018 kan manzawa. All rights reserved.
//

import UIKit

class Member {
    var name : String
    var pay  : Int
    var debt : Int
    var log  : [String]
    
    init(name: String, pay: Int, debt: Int, log: [String]) {
        self.name   = name
        self.pay    = pay
        self.debt   = debt
        self.log    = log
    }
}

class MainTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    // バリデート追加
    // ・数値チェック
    // ・重複チェック
    // ・Nullチェック
    // edit-> Nullの場合にエントリ削除？
    
    var tableData = [String]()
    var detailData = [String]()

    
    // 保存用インスタンス
    let userDefaults = UserDefaults.standard
    let defaultsKey:String = "UserDefaultKey"

    // 履歴を保存する
    func saveHistory(result: [[String]]) {
        let defaults = UserDefaults.standard
        defaults.set(result, forKey: defaultsKey)
        defaults.synchronize()
    }
    
    // 履歴を取得する
    func readHistory() -> [[String]]  {
        let defaults = UserDefaults.standard
        if let hist:[[String]] = defaults.object(forKey: defaultsKey) as? [[String]] {
            return hist
        } else {
            return [["Aさん", "Bさん", "Cさん", "Dさん", "Eさん"],
                    ["-2800", "-12310", "-3290", "-990", "0"]]
        }
    }

    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
        let detailViewController = segue.source as! DetailTableViewController
        let editedData = detailViewController.dataString
        let changedPrice = detailViewController.priceString
        let index = detailViewController.index
        
        if index != nil {
            tableData[index!] = editedData!
            detailData[index!] = changedPrice!
        } else {
            tableData.append(editedData!)
            detailData.append(changedPrice!)
        }
        saveHistory(result: [ tableData, detailData ])
        tableView.reloadData()
    }

    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.delegate = self as? UINavigationControllerDelegate
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DetailTableViewController.didSwipe(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DetailTableViewController.didSwipe(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        
        if tableData.count == 0 {
            tableData  = readHistory()[0]
            detailData = readHistory()[1]
        } else {
            saveHistory(result: [ tableData, detailData ])
        }
    }

    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .right {
            print("Right")
        }
        else if sender.direction == .left {
            print("Left")
        }
    }
    
    func addTapped() -> (Array<String>) {
        var resultData = [String]()
        var member = [Member]()
        var twoDimArray: [[String]] = [ tableData, detailData ]
        
        for x in 0 ..< tableData.count {
            member.append(Member(name:twoDimArray[0][x],pay:Int(twoDimArray[1][x])!,debt:0,log:[]))
        }

        member.sort(by: {$0.pay < $1.pay})
        var sumVal = 0
        
        for s in member {
            sumVal = sumVal + s.pay
        }
        
        let mcnt = member.count
        for s in member {
            s.debt = (s.pay - (sumVal / mcnt)) * -1
        }
        
        var k = 0
        var m = mcnt - 1
        
        while true {
            if k == m || member[m].debt == 0 {
                break
            } else if member[k].debt + member[m].debt >= 0 {
                // absは出力する際の＋表示
                member[m].log.append(Swift.abs(member[m].debt).JPYString + "->" + member[k].name)
                member[k].log.append(member[m].name + "(" + Swift.abs(member[m].debt).JPYString + ")")
                
                member[k].debt = member[k].debt + member[m].debt
                if member[k].debt >= 0 {
                    member[m].debt = 0
                    m = m - 1
                } else {
                    member[m].debt = member[k].debt + member[m].debt
                    member[k].debt = 0
                    k = k + 1
                }
            } else if member[k].debt != 0 && member[k].debt + member[m].debt < 0 {
                member[m].log.append(Swift.abs(member[k].debt).JPYString + "->" + member[k].name)
                member[k].log.append(member[m].name + "(" + Swift.abs(member[k].debt).JPYString + ")")
                
                member[m].debt = member[k].debt + member[m].debt
                if member[m].debt <= 0 {
                    member[k].debt = 0
                    k = k + 1
                } else {
                    member[k].debt = member[k].debt + member[m].debt
                    member[m].debt = 0
                    m = m - 1
                }
            } else {
                k = k + 1
            }
        }
        
        resultData.append("支出合計: \(Swift.abs(sumVal).JPYString)、 一人あたり: \(Swift.abs(sumVal / mcnt).JPYString)、 端数: \((sumVal % mcnt).JPYString)")
        
        for s in member {
            resultData.append(s.name + " " + s.pay.JPYString + " | " + s.log.joined(separator: " |"))
        }
        return resultData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as UITableViewCell

        // Configure the cell...
        
        cell.textLabel?.text = tableData[indexPath.row]
        cell.detailTextLabel?.text = Int(detailData[indexPath.row])?.JPYString
        
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableData.remove(at: indexPath.row)
            detailData.remove(at: indexPath.row)
            saveHistory(result: [ tableData, detailData ])
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            
            let path = tableView.indexPathForSelectedRow
            let detailViewController = segue.destination as! DetailTableViewController
            detailViewController.index = path?.row
            detailViewController.data = tableData
            detailViewController.price = detailData
            
        } else if segue.identifier == "result" {
            let resultViewController = segue.destination as! ResultViewController
            if tableData.count != 0 {
                resultViewController.resultData = addTapped()
            }
            
        } else if segue.identifier == "add" {
            let detailViewController = segue.destination as! DetailTableViewController
            detailViewController.data = tableData
            detailViewController.price = detailData
        }
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

}
