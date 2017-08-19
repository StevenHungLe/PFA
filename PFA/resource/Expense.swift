//
//  Expense.swift
//  MoneyPlus
//
//  Created by Steven Le on 3/26/17.
//  Copyright © 2017 Hung Le & Vince Pham. All rights reserved.
//

import Foundation

class Expense: NSObject, NSCoding
{
    var amount: Double
    var date: String
    var paymentForm: String
    var frequency: String
    var edescription: String
    
    init( amount:Double, date:String, paymentForm:String, frequency: String, edescription: String)
    {
        self.amount = amount
        self.date = date
        self.paymentForm = paymentForm
        self.frequency = frequency
        self.edescription = edescription
    }
    
    required init(coder aDecoder:NSCoder)
    {
        self.amount = aDecoder.decodeDouble(forKey: "amount")
        self.date = aDecoder.decodeObject(forKey: "date") as! String
        self.paymentForm = aDecoder.decodeObject(forKey: "paymentForm") as! String
        self.frequency = aDecoder.decodeObject(forKey: "frequency") as! String
        self.edescription = aDecoder.decodeObject(forKey: "edescription") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.amount, forKey: "amount")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.paymentForm, forKey:"paymentForm")
        aCoder.encode(self.frequency, forKey:"frequency")
        aCoder.encode(edescription, forKey:"edescription")
    }
}
