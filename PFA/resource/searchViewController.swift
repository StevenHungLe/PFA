//
//  searchViewController.swift
//  MoneyPlus
//
//  Created by Hung Le on 5/8/15.
//  Copyright (c) 2015 Hung Le & Vince Pham. All rights reserved.
//

import Foundation
import UIKit

class searchViewController: UIViewController, UITableViewDelegate {
    /*
    
    @IBOutlet weak var searchTable: UITableView!
    
    @IBOutlet weak var searchKeyField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var paymentFormLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var frequencyLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var searchResultLabel: UILabel!
    
    @IBOutlet weak var searchModeButton: UIButton!
    
    let AMOUNT      = 0
    let DATE        = 1
    let PAYMENTFORM = 2
    let FREQUENCY   = 3
    let DESCRIPTION = 4
    
    var resultArray: [Expense]
    
    var row = 0
    
    var dateFormatter = DateFormatter()
    
    var arrayToSearch = 0
    
    let userDefaults: UserDefaults? =  UserDefaults.standard // save user data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTable.delegate = self
        
        searchTable.reloadData()
        // Do any additional setup after loading the view.
        
        self.dateFormatter.dateStyle = .short
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resultArray = [Expense]()
        searchTable.reloadData()
        searchResultLabel.text = ""
    }
    
    //MARK: - TableView's functions
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.resultArray[0] as AnyObject).count
    }
    
    // Display the tableview
    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell!
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL")
        }
        
        row = (self.resultArray[0] as AnyObject).count - 1 - indexPath.row
        var amountString: NSString = resultArray[0][row] as NSString
        var dateString: NSString = (dateFormatter.stringFromDate( resultArray[1][row] as Date) as NSString)
        let padValue = amountString.length > 6 ? 0 : 0
        amountString = amountString.padding(toLength: 25 - amountString.length + padValue, withPad:" ", startingAt: 0) as NSString
        let displayedString = NSString(format: "Amount: $%@      Date: %@", amountString, dateString)
        
        cell!.textLabel?.text = displayedString as NSString
        
        return cell
    }
    
    // ACTION: Called when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (self.detailView.isHidden == true) {
            row = (self.resultArray[AMOUNT] as AnyObject).count - 1 - indexPath.row
            self.detailView.isHidden = false // unhide the input view
            
            // write values of the selected expense entry to the fields
            self.amountLabel.text = (resultArray[AMOUNT][row] as NSString)
            self.dateLabel.text = dateFormatter.stringFromDate(resultArray[DATE][row] as Date)
            self.paymentFormLabel.text = resultArray[PAYMENTFORM][row] as NSString
            self.frequencyLabel.text = resultArray[FREQUENCY][row] as NSString
            self.descriptionTextView.text = resultArray[DESCRIPTION][row] as NSString
            
            /*row = self.expenseArray[AMOUNT].count - 1 - indexPath.row
            self.detailView.hidden = false // unhide the input view
            
            // write values of the selected expense entry to the fields
            self.amountLabel.text = (expenseArray[AMOUNT][row] as NSString)
            self.dateLabel.text = dateFormatter.stringFromDate(expenseArray[DATE][row] as NSDate)
            self.paymentFormLabel.text = expenseArray[PAYMENTFORM][row] as NSString
            self.frequencyLabel.text = expenseArray[FREQUENCY][row] as NSString
            self.descriptionTextView.text = expenseArray[DESCRIPTION][row] as NSString*/
            
        }
        
    }
    
    @IBAction func startSearch(_ sender: UIButton) {
        resultArray = [Expense]()
        if let expenseArray = UserDefaults.standard.object(forKey: "expenseArray") as! [Expense]?
        {
            /*
            for index in 0...expenseArray
            expenseArray[0] = (expenseArray[0] as AnyObject).mutableCopy()
            expenseArray[1] = (expenseArray[1] as AnyObject).mutableCopy()
            expenseArray[2] = (expenseArray[2] as AnyObject).mutableCopy()
            expenseArray[3] = (expenseArray[3] as AnyObject).mutableCopy()
            expenseArray[4] = (expenseArray[4] as AnyObject).mutableCopy()
             */
            /*
            for i in 0  ..< expenseArray.count
            {
                if expenseArray[arrayToSearch][i] as NSString == searchKeyField.text
                {
                    (resultArray[AMOUNT] as AnyObject).addObject(expenseArray[AMOUNT][i] as String)
                    (resultArray[DATE] as AnyObject).addObject(expenseArray[DATE][i] as NSDate)
                    (resultArray[PAYMENTFORM] as AnyObject).addObject(expenseArray[PAYMENTFORM][i] as String)
                    (resultArray[FREQUENCY] as AnyObject).addObject(expenseArray[FREQUENCY][i] as String)
                    (resultArray[DESCRIPTION] as AnyObject).addObject(expenseArray[DESCRIPTION][i] as String)
                }
            }
            searchTable.reloadData()
            searchResultLabel.text = "Number of matches: " + "\((resultArray[0] as AnyObject).count)"
            searchKeyField.resignFirstResponder()
 */
        }
    }
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        self.detailView.isHidden = true
    }
    
    
    @IBAction func switchSearchMode(_ sender: UIButton) {
        arrayToSearch = arrayToSearch == AMOUNT ? PAYMENTFORM : AMOUNT
        searchModeButton.setTitle( arrayToSearch == AMOUNT ? "Search Payment Form" : "Search Amount", for: UIControlState())
        searchKeyField.placeholder = arrayToSearch == AMOUNT ? "Amount" : "Payment Form"
        searchKeyField.keyboardType = arrayToSearch == AMOUNT ? .decimalPad : .default
        searchKeyField.text = ""
        
    }
    
    /*func loadUserDefaults(key : String)
    {
    
    if(userDefaults != nil ){
    //userDefaults?.removeObjectForKey(key)
    if var savedExpenseArray = userDefaults?.objectForKey(key) as? NSMutableArray
    {
    expenseArray[0] = savedExpenseArray[0].mutableCopy()
    expenseArray[1] = savedExpenseArray[1].mutableCopy()
    expenseArray[2] = savedExpenseArray[2].mutableCopy()
    expenseArray[3] = savedExpenseArray[3].mutableCopy()
    expenseArray[4] = savedExpenseArray[4].mutableCopy()
    
    }
    }
    }*/
}
 */
}
