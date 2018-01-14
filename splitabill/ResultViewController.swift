//
//  ResultViewController.swift
//  edit data demo
//
//  Created by pnk on 2018/01/06.
//  Copyright © 2018 Apoorv Mote. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var ResultTextField: UITextView!
    
    var resultData:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        ResultTextField.delegate = self
        ResultTextField.text = resultData?.joined(separator: "\n\n")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewShouldBeginEditing(_ ResultTextField: UITextView) -> Bool {
        //カーソルは表示し、キーボードのみ非表示
        ResultTextField.inputView = UIView()
        //キーボードとカーソルを非表示にする場合はfalseを返す
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
