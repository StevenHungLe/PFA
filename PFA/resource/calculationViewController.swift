//
//  calculationViewController.swift
//  MoneyPlus
//
//  Created by Hung Le on 5/6/15.
//  Copyright (c) 2015 Hung Le & Vince Pham. All rights reserved.
//

import UIKit

class calculationViewController: UIViewController, UITableViewDelegate {

    var expenseArray    = [Expense]()
    var incomeArray = [Income]()
    var allowanceperWeek = "N/A"
    var projectedsurplus = "N/A"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var totalExpense: UILabel!
    
    @IBOutlet weak var totalIncome: UILabel!
    
    @IBOutlet weak var deficitOrSurplus: UILabel!
    
    @IBOutlet weak var deficitOrSurplusLabel: UILabel!
    
    @IBOutlet weak var totalExpenseLabel: UILabel!
    
    @IBOutlet weak var totalIncomeLabel: UILabel!
    
    @IBOutlet weak var financialPlanning: UIButton!
    
    @IBOutlet weak var financialPlanningButtonBar: UIView!
    
    @IBOutlet weak var allowancePerWeekLabel: UILabel!
    
    @IBOutlet weak var allowancePerWeek: UILabel!
    
    @IBOutlet weak var projectedSurplus: UILabel!
    
    @IBOutlet weak var projectedSurplusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedValue = UserDefaults.standard.object(forKey: "allowanceperWeek") as! NSString?
        {
            allowanceperWeek = savedValue as String
        }
        
        if let savedValue = UserDefaults.standard.object(forKey: "projectedsurplus") as! NSString?
        {
            projectedsurplus = savedValue as String
        }
                // Do any additional setup after loading the view.
    }

    func financialOverview()
    {
        titleLabel.text = planningMode ? "Projected Financial Plan" : "Financial Overview"
        var expenseTotal: Double = 0
        var incomeTotal: Double = 0
        var difference: Double = 0
        
        var i = 0
        var multiplier: Double = 1.0
        for expense in expenseArray
        {
            if expense.frequency == "Weekly"
            {
                multiplier = 4.0
            }
            else if expense.frequency == "Bi-weekly"
            {
                multiplier = 2.0
            }
            else
            {
                multiplier = 1.0
            }
            expenseTotal += expense.amount * multiplier
            i += 1
        }
        
        for income in incomeArray
        {
            if income.frequency == "Weekly"
            {
                multiplier = 4.0
            }
            else if income.frequency == "Bi-weekly"
            {
                multiplier = 2.0
            }
            else
            {
                multiplier = 1.0
            }
            incomeTotal += income.amount * multiplier
        }
        
        difference = incomeTotal - expenseTotal
        
        self.totalExpense.text = "$\(expenseTotal)"
        self.totalIncome.text = "$\(incomeTotal)"
        self.deficitOrSurplus.text = difference > 0 ? "$\(difference)" : "$(\(-difference))"
        self.deficitOrSurplusLabel.text = difference > 0 ? "Surplus:" : "Deficit:"
        
        if planningMode
        {
            allowancePerWeek.text = "$\(round(100.0 * difference/4.0)/100.0)"
        }
        else
        {
            allowancePerWeek.text = allowanceperWeek
            projectedSurplus.text = projectedsurplus
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userDefaults = UserDefaults.standard as UserDefaults?
        {
            
            
            if let savedExpenseArrayData = userDefaults.data(forKey: planningMode ? "plannedExpenseArray" : "expenseArray") as Data!
            {
                expenseArray = NSKeyedUnarchiver.unarchiveObject(with: savedExpenseArrayData) as! [Expense]
            }
            
            if let savedIncomeArrayData = userDefaults.data(forKey: planningMode ? "plannedIncomeArray" : "incomeArray") as Data!
            {
                incomeArray = NSKeyedUnarchiver.unarchiveObject(with: savedIncomeArrayData) as! [Income]
            }
            
        }
        financialOverview()

    }
    @IBAction func togglePlanningMode(_ sender: UIButton) {
        planningMode = planningMode ? false : true // toggle planning mode
        financialPlanningButtonBar.isHidden = planningMode ? false : true
        projectedSurplus.isHidden = planningMode ? true : false
        projectedSurplusLabel.isHidden = planningMode ? true : false
        financialPlanning.setTitle( planningMode ? "End Planning Session" : "Financial Planning" , for: UIControlState())
        viewWillAppear(true)
    }
    
    @IBAction func applyPlan(_ sender: UIButton) {

        allowanceperWeek = allowancePerWeek.text!
        projectedsurplus = deficitOrSurplus.text!
        UserDefaults.standard.set(allowanceperWeek, forKey: "allowanceperWeek")
        UserDefaults.standard.set(projectedsurplus, forKey: "projectedsurplus")
        togglePlanningMode(sender)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
