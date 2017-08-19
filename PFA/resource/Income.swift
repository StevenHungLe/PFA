//
//  Income.swift
//  MoneyPlus
//
//  Created by Steven Le on 3/26/17.
//  Copyright © 2017 Hung Le & Vince Pham. All rights reserved.
//

import Foundation

class Income: NSObject, NSCoding
{
    var amount: Double
    var date: String
    var frequency: String
    var idescription: String
    
    init( amount:Double, date:String, frequency: String, idescription: String)
    {
        self.amount = amount
        self.date = date
        self.frequency = frequency
        self.idescription = idescription
    }
    
    required init(coder aDecoder:NSCoder)
    {
        self.amount = aDecoder.decodeDouble(forKey: "amount")
        self.date = aDecoder.decodeObject(forKey: "date") as! String
        self.frequency = aDecoder.decodeObject(forKey: "frequency") as! String
        self.idescription = aDecoder.decodeObject(forKey: "idescription") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.amount, forKey: "amount")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.frequency, forKey:"frequency")
        aCoder.encode(self.idescription, forKey:"idescription")
    }
}
