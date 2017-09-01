//
//  incomeViewController.swift
//  PFA
//
//  Created by Steven Le
//  Copyright (c) 2017 Steven Le. All rights reserved.


import UIKit


class incomeViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var incomeTable: UITableView!
    @IBOutlet weak var formattedAmountField: UITextField!
    @IBOutlet weak var viewForInput: UIView!
    @IBOutlet weak var CancelOrDeleteButton: UIButton!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var frequencyPicker: UIPickerView!
    @IBOutlet weak var freqPickerView: UIView!
    @IBOutlet weak var frequencyField: UITextField!
    @IBOutlet weak var rawAmountField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    
    var incomeArray = [Income]()
    var row: NSInteger = 0 // the row in the table cell on which we are currently working
    var formatter : NumberFormatter = NumberFormatter() // formatter for amount of money
    var dateFormatter: DateFormatter = DateFormatter()  // formatter for date
    var editMode : Bool = false // used to toggle input and edit mode
    let frequencyTypes = ["One-time","Weekly","Bi-weekly","Monthly"] // frequency of the expense
    let userDefaults: UserDefaults? =  UserDefaults.standard // save user data
    
    override func viewDidLoad() // Method called after the view loads
    {
        super.viewDidLoad()
        
        incomeArray = [Income]()
        
        // subviews are hidden at first
        rawAmountField.isHidden = true
        datePickerView.isHidden = true
        freqPickerView.isHidden = true
        self.viewForInput.isHidden = true
        
        // delegates and sources
        self.formattedAmountField.delegate = self
        self.incomeTable.delegate = self
        frequencyPicker.dataSource = self
        frequencyPicker.delegate = self
        
        // formatters
        self.formatter.numberStyle = NumberFormatter.Style.decimal
        self.dateFormatter.dateStyle = .short
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if planningMode
        {
            loadUserDefaults("plannedIncomeArray")
            pageTitle.text = "Projected Incomes"
        }
        else
        {
            loadUserDefaults("incomeArray")
            pageTitle.text = "Incomes"
        }

        incomeTable.reloadData()
    }
    
    func loadUserDefaults(_ key : String)
    {
        if let savedIncomeArrayData = userDefaults?.data(forKey: key)
        {
            incomeArray = NSKeyedUnarchiver.unarchiveObject(with: savedIncomeArrayData) as! [Income]
        }
    }
    
    //MARK: - Delegates and data sources for UIPickerView
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencyTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequencyTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        frequencyField.text = frequencyTypes[frequencyPicker.selectedRow(inComponent: component)]
    }
    
    
    //MARK: - TableView's functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.incomeArray.count
    }
    
    // Display the tableview
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL")
        }
        
        row = self.incomeArray.count - 1 - indexPath.row // later entry on top
        var amountString = String(incomeArray[row].amount)
        let dateString = incomeArray[row].date
        let padValue = amountString.characters.count > 6 ? 0 : 0
        amountString = amountString.padding(toLength: 24 - amountString.characters.count + padValue, withPad:" ", startingAt: 0)
        let displayedString = NSString(format: "$%@         %@", amountString, dateString)
        
        cell!.textLabel?.text = displayedString as String
        
        return cell!
    }
    
    // ACTION: Called when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (self.viewForInput.isHidden == true) {
            row = incomeArray.count - 1 - indexPath.row
            self.toggleEditMode() // the input view is now in edit mode
            self.viewForInput.isHidden = false // unhide the input view
            
            // write values of the selected expense entry to the fields
            self.formattedAmountField.text = String(incomeArray[row].amount)
            self.dateField.text = incomeArray[row].date
            self.frequencyField.text = incomeArray[row].frequency
            self.descriptionField.text = incomeArray[row].idescription
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            row = self.incomeArray.count - 1 - indexPath.row
            self.removeExpense()
            self.incomeTable.reloadData() // reload tableview
            self.updateUserDefaults() // update user default
        }
    }
    
    func toggleEditMode() // Toggle the input view between new input view and edit view
    {
        editMode = editMode ? false : true
        CancelOrDeleteButton.setTitle( editMode ? "Delete" : "Cancel", for: UIControlState())
    }
    
    
    
    // ACTION: Clicked the add Button to add a new expense
    @IBAction func addBtnClicked(_ sender: AnyObject)
    {
        self.viewForInput.isHidden = false // unhide the input view
        formattedAmountField.becomeFirstResponder()
        resetFields() // reset all fields to default values
    }
    
    // reset all fields to default values
    func resetFields ()
    {
        rawAmountField.text = ""
        self.formattedAmountField.text = ""
        dateField.text = dateFormatter.string(from: Date()) // today
        frequencyField.text = "One-time" // default is One-time payment
        descriptionField.text = ""
    }
    
    
    
    // ACTION: click save button in input/edit view
    @IBAction func inputFinished(_ sender: UIButton) {
        
        if(self.formattedAmountField.text == "" || self.formattedAmountField.text == "0.0") // will not save unless amount is entered
        {
            return
        }
        
        if editMode == false // click save in input mode
        {
            self.addNewExpense() // call a method to add new expense to the data array
        }
        else // click save in edit mode
        {
            self.editExpense() // call a method to edit the expense in the data array
            
            self.toggleEditMode() // toggle back to input mode
        }
        
        
        // update user defaults
        self.updateUserDefaults()
        
        // reload the pickers and tableview
        self.incomeTable.reloadData()
        
        // resign first responder on all fields
        self.exitKeyboard()
        
        // hide the input view
        self.viewForInput.isHidden = true
    }
    
    // function called to add a new expense entry to the array
    func addNewExpense()
    {
        self.incomeArray.append(Income(amount: Double(formattedAmountField.text!)!, date: dateField.text!, frequency: frequencyField.text!, idescription: descriptionField.text!))
    }
    
    
    // function called to edit an expense entry in the array
    func editExpense()
    {
        self.incomeArray[row].amount = Double(formattedAmountField.text!)!
        self.incomeArray[row].date = dateField.text!
        self.incomeArray[row].frequency = frequencyField.text!
        self.incomeArray[row].idescription = descriptionField.text!
    }
    
    
    // ACTION: Click CANCEL in input mode or DELETE in edit mode
    @IBAction func clickCancelOrDeleteButton(_ sender: UIButton) {
        if editMode // in edit mode, the button works as Delete button now
        {
            self.removeExpense() // call a method to remove the expense entry from the array
            self.incomeTable.reloadData() // reload tableview
            self.toggleEditMode() // toggle back to input mode
            self.updateUserDefaults() // update user default
        }
        
        // the code below is executed in either input mod or edit mode
        self.exitKeyboard() // resign first responders
        self.viewForInput.isHidden = true // hide the input view
    }
    
    // function called to remove an expense entry in the array
    func removeExpense()
    {
        self.incomeArray.remove(at: row)
    }
    
    // function to update user default
    func updateUserDefaults()
    {
        let savedData = NSKeyedArchiver.archivedData(withRootObject: self.incomeArray)
        
        userDefaults?.set(savedData, forKey: planningMode ? "plannedIncomeArray" : "incomeArray" )
        userDefaults?.synchronize()
    }
    
    // ACTION: the date field is clicked on -> unhide the datepicker to pick a date
    @IBAction func activateDatePicker(_ sender: UITextField) {
        datePickerView.isHidden = false
        mainView.bringSubview(toFront: datePickerView)
    }
    
    // ACTION: a date is picked from the date picker
    @IBAction func datePicked(_ sender: UIButton) {
        datePickerView.isHidden = true
        dateField.text = self.dateFormatter.string(from: datePicker.date) // write the picked date in the date field
        mainView.sendSubview(toBack: datePickerView)
    }
    
    // ACTION: the frequency field is clicked on -> unhide the frequency picker to pick a frequency
    @IBAction func activateFreqPicker(_ sender: UITextField) {
        freqPickerView.isHidden = false
        mainView.bringSubview(toFront: freqPickerView)
    }
    
    // ACTION: a frequency is picked from the frequency picker
    @IBAction func frequencyPicked(_ sender: UIButton) {
        freqPickerView.isHidden = true
        mainView.sendSubview(toBack: freqPickerView)
    }
    
    
    // ACTION: amount is being entered into the amount field
    // send first responder to the raw-Amount field so decimal number formatting can be handled
    @IBAction func amountEditingChanged(_ sender: UITextField) {
        rawAmountField.text = formattedAmountField.text
        rawAmountField.becomeFirstResponder()
        rawAmountEdited(rawAmountField)
    }
    
    // ACTION: amount field is touched
    @IBAction func touchedAmountField(_ sender: UITextField) {
        // reset the whole field if this is edit mode, this is to ensure number formatting will not be messed up
        formattedAmountField.text = ""
    }
    
    // ACTION: raw mount is being edited
    // divide the raw amount by 100 then write the divided value to the aformatted amount field
    @IBAction func rawAmountEdited(_ sender: UITextField) {
        if let rawAmount = (rawAmountField.text as NSString!).longLongValue as Int64?
        {
            //formattedAmountField.text = formatter.stringFromNumber((Double(rawAmount))/100.0)
            formattedAmountField.text = "\((Double(rawAmount))/100.0)"
        }
        else
        {
            formattedAmountField.text = ""
        }
    }
    
    // function to resign first responder of all fields-> keyboards are dismissed
    @IBAction func exitKeyboard() {
        formattedAmountField.resignFirstResponder()
        descriptionField.resignFirstResponder()
        rawAmountField.resignFirstResponder()
        frequencyField.resignFirstResponder()
        dateField.resignFirstResponder()
    }
    
}
