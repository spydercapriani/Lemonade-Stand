//
//  LemonadeStandBrain.swift
//  Lemonade Stand
//
//  Created by Daniel Gilbert on 9/29/14.
//  Copyright (c) 2014 Daniel Gilbert. All rights reserved.
//

import Foundation

class LemonadeStand {
    
    class func createCustomers() -> [Customer] {
        let totalCustomers = Int(arc4random_uniform(9) + 1)
        print("createCustomers: Total Customers = \(totalCustomers)")
        
        var customers:[Customer] = []
        for index in 0...(totalCustomers-1) {
            var aCustomer = Customer()
            aCustomer.tastePreference = Double(Int(arc4random_uniform(11))) / 10.0 // random value between 0.0 and 1
            print("\n\tCustomer[\(index)]'s Preference = \(aCustomer.tastePreference)")
            customers.append(aCustomer)
        }
        println()
        return customers
    }
}