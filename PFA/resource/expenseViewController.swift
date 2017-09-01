//
//  expenseViewController.swift
//  MoneyPlus
//
//  Created by Hung Le - Vince Pham on 4/6/15.
//  Copyright (c) 2015 Hung Le & Vince Pham. All rights reserved.
//

import UIKit


class expenseViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var expenseTable: UITableView!
    @IBOutlet weak var formattedAmountField: UITextField!
    @IBOutlet weak var paymentFormField: UITextField!
    @IBOutlet weak var viewForInput: UIView!
    @IBOutlet weak var CancelOrDeleteButton: UIButton!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var frequencyPicker: UIPickerView!
    @IBOutlet weak var freqPickerView: UIView!
    @IBOutlet weak var frequencyField: UITextField!
    @IBOutlet weak var paymentFormPickerView: UIView!
    @IBOutlet weak var paymentFormPicker: UIPickerView!
    @IBOutlet weak var newPaymentFormView: UIView!
    @IBOutlet weak var newPaymentFormField: UITextField!
    @IBOutlet weak var rawAmountField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    // the main array that holds the expense entries
    var expenseArray = [Expense]()
    var row: NSInteger = 0 // the row in the table cell on which we are currently working
    var formatter : NumberFormatter = NumberFormatter() // formatter for amount of money
    var dateFormatter: DateFormatter = DateFormatter()  // formatter for date
    var editMode : Bool = false // used to toggle input and edit mode
    let frequencyTypes = ["One-time","Weekly","Bi-weekly","Monthly"] // frequency of the expense
    var paymentForms = ["Cash","New Payment Form..."] // the payment form of the expense
    let userDefaults: UserDefaults? =  UserDefaults.standard // save user data
    
    
    override func viewDidLoad() // Method called after the view loads
    {
        super.viewDidLoad()
        
        if(userDefaults != nil ){
            if let savedPaymentForms = userDefaults?.object(forKey: "paymentForms") as? [String]
            {
                paymentForms = savedPaymentForms // load saved payment forms
            }
        }
        
        // subviews are hidden at first
        //rawAmountField.hidden = true
        datePickerView.isHidden = true
        freqPickerView.isHidden = true
        paymentFormPickerView.isHidden = true
        newPaymentFormView.isHidden = true
        self.viewForInput.isHidden = true
        
        // load the table view
        self.expenseTable.reloadData()
        
        // delegates and sources
        self.formattedAmountField.delegate = self
        self.paymentFormField.delegate = self
        self.expenseTable.delegate = self
        frequencyPicker.dataSource = self
        frequencyPicker.delegate = self
        paymentFormPicker.dataSource = self
        paymentFormPicker.delegate = self
        
        // formatters
        self.formatter.numberStyle = NumberFormatter.Style.decimal
        self.dateFormatter.dateStyle = .short
        
        // Do any additional setup after loading the view.
    }
    
    
    func loadUserDefaults(_ key : String)
    {
        if(userDefaults != nil ){
            //userDefaults?.removeObjectForKey(key)
            if let savedExpenseArrayData = userDefaults?.data(forKey: key)
            {
                expenseArray = NSKeyedUnarchiver.unarchiveObject(with: savedExpenseArrayData) as! [Expense]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        // load the respective arrays depending on whether planning mode is on
        if planningMode
        {
            expenseArray = [Expense]()
            loadUserDefaults("plannedExpenseArray")
            pageTitle.text = "Projected Expenses"
        }
        else
        {
            loadUserDefaults("expenseArray")
            pageTitle.text = "Expenses"
        }
        
        expenseTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Delegates and data sources for UIPickerView
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == frequencyPicker
        {
            return frequencyTypes.count
        }
        else // paymentFormPicker
        {
            return paymentForms.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == frequencyPicker
        {
            return frequencyTypes[row]
        }
        else // paymentFormPicker
        {
            return paymentForms[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == frequencyPicker
        {
            frequencyField.text = frequencyTypes[frequencyPicker.selectedRow(inComponent: 0)]
        }
        else // paymentFormPicker
        {
            paymentFormField.text = paymentForms[paymentFormPicker.selectedRow(inComponent: 0)]
        }
        
    }
    
    
    
    //MARK: - TableView's functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenseArray.count
    }
    
    // Display the tableview
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell
        if let optionalCell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        {
            cell = optionalCell;
        }
        else
        {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL")
        }
        
        row = self.expenseArray.count - 1 - indexPath.row
        var amountString: String = String(expenseArray[row].amount)
        let dateString: String = expenseArray[row].date
        let padValue = amountString.characters.count > 6 ? 0 : 0
        amountString = amountString.padding(toLength: 24 - amountString.characters.count + padValue, withPad:" ", startingAt: 0)
        let displayedString = NSString(format: "$%@         %@", amountString, dateString)
        
        cell.textLabel?.text = displayedString as String
        
        return cell
    }
    
    // ACTION: Called when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (self.viewForInput.isHidden == true) {
            row = self.expenseArray.count - 1 - indexPath.row
            self.toggleEditMode() // the input view is now in edit mode
            self.viewForInput.isHidden = false // unhide the input view
            
            // write values of the selected expense entry to the fields
            self.formattedAmountField.text = String(expenseArray[row].amount)
            self.dateField.text = expenseArray[row].date
            self.paymentFormField.text = expenseArray[row].paymentForm
            self.frequencyField.text = expenseArray[row].frequency
            self.descriptionField.text = expenseArray[row].edescription
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            row = self.expenseArray.count - 1 - indexPath.row
            self.removeExpense()
            self.expenseTable.reloadData() // reload tableview
            self.updateUserDefaults() // update user default
        }
    }
    
    func toggleEditMode() // Toggle the input view between new input view and edit view
    {
        editMode = editMode ? false : true
        CancelOrDeleteButton.titleLabel!.text = (CancelOrDeleteButton.titleLabel!.text == "Cancel") ? "Delete" : "Cancel"
    }
    
    
    
    // Not to concern
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        /*var prefs = NSUserDefaults.standardUserDefaults()
        prefs.synchronize()
        
        //        expenseField.resignFirstResponder()*/
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
        paymentFormField.text = paymentForms[0] // the most recently used payment form
        descriptionField.text = ""
    }
    
    
    
    // ACTION: click save button in input/edit view
    @IBAction func inputFinished(_ sender: UIButton) {

        if(self.formattedAmountField.text == "" || self.formattedAmountField.text == "0.0" ) // will not save unless amount is entered
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
        
        /** 
         * check if the selected payment form is existing or new
         * if new, insert it at index 0 in the payment forms array
         * if existing, move that payment form to index 0 in the array 
         * thus, the most recently used payment form will be the default payment form later on
         **/
        let index: Int = existingPaymentForm()
        if index != -1 // existing payment form
        {
            paymentForms.remove(at: index) // remove the existing payment form and insert it at index 0 later
        }
        // insert the selected payment form at index 0 of the array
        paymentForms.insert(paymentFormField.text!, at: 0)
        
        
        // update user defaults
        self.updateUserDefaults()
        
        // reload the pickers and tableview
        self.paymentFormPicker.reloadAllComponents()
        self.expenseTable.reloadData()
        
        // resign first responder on all fields
        self.exitKeyboard()
        
        // hide the input view
        self.viewForInput.isHidden = true
    }
   
    // function called to add a new expense entry to the array
    func addNewExpense()
    {

        self.expenseArray.append(Expense(amount: Double(formattedAmountField.text!)!, date: dateField.text!, paymentForm: paymentFormField.text!, frequency: frequencyField.text!, edescription: descriptionField.text!))
    }
    
    
    // function called to edit an expense entry in the array
    func editExpense()
    {
        self.expenseArray[row].amount = Double(formattedAmountField.text!)!
        self.expenseArray[row].date = dateField.text!
        self.expenseArray[row].paymentForm = paymentFormField.text!
        self.expenseArray[row].frequency = frequencyField.text!
        self.expenseArray[row].edescription = descriptionField.text!
    }
    
    /* function called to check whether the payment method is existing
     * if no, return -1
     * if yes, return its index in the array
     */
    func existingPaymentForm()->Int
    {
        for i in 0 ..< paymentForms.count
        {
            if paymentForms[i] == paymentFormField.text
            {
                return i
            }
        }
        return -1
    }
    
    
    // ACTION: Click CANCEL in input mode or DELETE in edit mode
    @IBAction func clickCancelOrDeleteButton(_ sender: UIButton) {
        if editMode // in edit mode, the button works as Delete button now
        {
            self.removeExpense() // call a method to remove the expense entry from the array
            self.expenseTable.reloadData() // reload tableview
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
        self.expenseArray.remove(at: row)
    }
    
    // function to update user default
    func updateUserDefaults()
    {
        let savedData = NSKeyedArchiver.archivedData(withRootObject: self.expenseArray)
        userDefaults?.set(savedData, forKey: planningMode ? "plannedExpenseArray" : "expenseArray" )
        userDefaults?.set(self.paymentForms, forKey: "paymentForms")
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
    
    // ACTION: the payment form field is clicked on -> unhide the payment form picker to pick a payment form
    @IBAction func activatePaymentFormPicker(_ sender: UITextField) {
        paymentFormPickerView.isHidden = false
        mainView.bringSubview(toFront: paymentFormPickerView)
        paymentFormPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    // ACTION: a payment form is picked
    @IBAction func paymentFormPicked(_ sender: UIButton) {
        paymentFormPickerView.isHidden = true
        mainView.sendSubview(toBack: paymentFormPickerView)
        if paymentFormField.text == "New Payment Form..." // user opts to enter a new payment form
        {
            newPaymentFormView.isHidden = false // unhide the new payment form view
            mainView.bringSubview(toFront: newPaymentFormView)
            newPaymentFormField.becomeFirstResponder();
        }
    }
    
    // ACTION: a new oayment form is enterd
    @IBAction func paymentFormEntered(_ sender: UIButton) {
        paymentFormField.text = newPaymentFormField.text // write the entered payment form to the payment form field
        newPaymentFormField.text = ""
        newPaymentFormView.isHidden = true
        mainView.sendSubview(toBack: newPaymentFormView)
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
        paymentFormField.resignFirstResponder()
        dateField.resignFirstResponder()
    }
    
}
