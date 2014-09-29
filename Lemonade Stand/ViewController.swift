//
//  ViewController.swift
//  Lemonade Stand
//
//  Created by Daniel Gilbert on 9/24/14.
//  Copyright (c) 2014 Daniel Gilbert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Labels
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblLemons: UILabel!
    @IBOutlet weak var lblIce: UILabel!
    @IBOutlet weak var lblMixLemon: UILabel!
    @IBOutlet weak var lblMixIce: UILabel!
    
    // Buttons
    @IBOutlet weak var stepperPurchLemons: UIStepper!
    @IBOutlet weak var stepperPurchIce: UIStepper!
    @IBOutlet weak var stepperMixLemon: UIStepper!
    @IBOutlet weak var stepperMixIce: UIStepper!
    @IBOutlet weak var btnStartDay: UIButton!
    
    // Constants
    let costLemons:Int = 2
    let costIce:Int = 1
    
    // Structs
    var inventory = Supplies(money: 10, lemons: 1, iceCubes: 0)
    var lemonade:LemonadeJar = LemonadeJar()
    
    var myCustomers:[Customer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if inventory.money == 0 && inventory.lemons == 0 && inventory.iceCubes == 0{ // Reset Game if User runs out of credits/supplies
            println("Game Over!")
            resetGame()
        }
        
        updateSupplyView()
        lemonade.lemons = 1
        lemonade.iceCubes = 0
        updateMixView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Buttons Pressed Actions
    @IBAction func lemonPurchStepperPressed(sender: UIStepper) { // Purchasing Lemons
        if Int(sender.value) > inventory.lemons {       // stepper value has increased (+ Button pressed)
            if (inventory.money - costLemons) < 0 {
                showMessageAlert(header: "Not Enough Funds", message: "You don't have the necessary funds to make this purchase")
                println("LemonPurchase: Not Enough Funds")
                sender.value--                          // make sure stepper value stays the same
            }else{
                inventory.lemons++                      // add lemon to inventory
                inventory.money -= costLemons           // reduce total money
                updateSupplyView()
            }
        }else{                                          // stepper value has decreased (- Button pressed)
            inventory.lemons--                          // reduce lemon inventory
            inventory.money += costLemons               // refund cost of lemon
            updateSupplyView()
            if lemonade.lemons > inventory.lemons {     // ensure that user isn't capable of mixing supplies they haven't purchased
                lemonade.lemons = inventory.lemons
                updateMixView()
            }
        }
        
    }
    
    @IBAction func icePurchStepperPressed(sender: UIStepper) { // Purchasing Ice Cubes
        if Int(sender.value) > inventory.iceCubes {      // stepper value has increased (+ Button pressed)
            if (inventory.money - costIce) < 0 {
                showMessageAlert(header: "Not Enough Funds", message: "You don't have the necessary funds to make this purchase")
                println("IcePurchase: Not Enough Funds")
                sender.value--                          // make sure stepper value stays the same
            }else{
                inventory.iceCubes++                    // add ice to inventory
                inventory.money -= costIce              // reduce total money
                updateSupplyView()
            }
        }else{                                          // stepper value has decreased (- Button pressed)
            inventory.iceCubes--                        // reduce ice inventory
            inventory.money += costIce                  // refund cost of ice
            updateSupplyView()
            if lemonade.iceCubes > inventory.iceCubes { // ensure that user isn't capable of mixing supplies they haven't purchased
                lemonade.iceCubes = inventory.iceCubes
                updateMixView()
            }
        }
    }
    
    @IBAction func lemonMixStepperPressed(sender: UIStepper) { // Mixing Lemons
        lemonade.lemons = Int(sender.value)                    // update lemonMix variable
        updateMixView()
    }
    
    @IBAction func iceMixStepperPressed(sender: UIStepper) { // Mixing Ice Cubes
        lemonade.iceCubes = Int(sender.value)                // update iceMix variable
        updateMixView()
    }
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        if lemonade.lemons == 0 {                              // Alert user in case they forget to add lemons
            showMessageAlert(message: "You can't make lemonade without lemons!")
        }else {
            println("\nstartDay: Money(Before) = $\(inventory.money)")
            let mixRatio:Double = Double(lemonade.iceCubes) / Double(lemonade.lemons)
            println("startDay: Lemons: = \(lemonade.lemons), Ice = \(lemonade.iceCubes), Mix Ratio = \(mixRatio)")
            
            var totalSales = 0
            myCustomers = LemonadeStand.createCustomers()
            for customer in myCustomers {
                if customer.tastePreference < 0.4 && mixRatio > 1 {                                             // Diluted Customer
                    totalSales += 2
                    println("startDay: Paid $2, Customer enjoys Diluted")
                }else if customer.tastePreference > 0.6 && mixRatio < 1 {                                       // Acidic Customer
                    totalSales += 2
                    println("startDay: Paid $2, Customer enjoys Acidic")
                }else if customer.tastePreference <= 0.6 && customer.tastePreference >= 0.4 && mixRatio == 1 {  // Equal Customer
                    totalSales += 3
                    println("startDay: Paid $3, Customer enjoys Equal, Mix Ratio = \(mixRatio)")
                }else{                                                                                          // Non Customer
                    switch customer.tastePreference {
                    case 0.0...0.3:
                        println("startDay: No Sale, Customer preferred Diluted")
                    case 0.7...1:
                        println("startDay: No Sale, Customer preferred Acidic")
                    default:
                        println("startDay: No Sale, Customer preferred Equal")
                    }
                }
            }
            inventory.money += totalSales
            print("startDay: Total Sales = $\(totalSales), Money(after) = $\(inventory.money)\n")
            if totalSales > 0 {
                showMessageAlert(header: "Congratulations!", message: "You made $\(totalSales) today!")
            }else{
                showMessageAlert(header: "Sorry!", message: "No Sales were made today. Try again tomorrow!")
            }
            
            // Subtract Mixed Supplies from Inventory
            inventory.lemons -= lemonade.lemons
            inventory.iceCubes -= lemonade.iceCubes
        }
        
        // Reset View
        viewDidLoad()
    }
    
    // View Control Functions
    func updateSupplyView() {
        stepperPurchLemons.value = Double(inventory.lemons)
        stepperPurchIce.value = Double(inventory.iceCubes)
        
        stepperMixLemon.maximumValue = Double(inventory.lemons)
        stepperMixIce.maximumValue = Double(inventory.iceCubes)
        
        lblMoney.text = "$\(inventory.money)"
        lblLemons.text = "\(inventory.lemons)"
        lblIce.text = "\(inventory.iceCubes)"
        
        if inventory.money < 0 {        // Game Over
            resetGame()
        }
        
        if inventory.lemons == 0 {
            println("\nInventory(Invalid): Money = \(inventory.money), Lemons = \(inventory.lemons), Ice = \(inventory.iceCubes)")
        }else{
            println("Inventory(Valid): Money = \(inventory.money), Lemons = \(inventory.lemons), Ice = \(inventory.iceCubes)")
        }
    }
    
    func updateMixView() {
        lblMixLemon.text = "\(lemonade.lemons)"
        lblMixIce.text = "\(lemonade.iceCubes)"
        
        stepperMixLemon.value = Double(lemonade.lemons)
        stepperMixIce.value = Double(lemonade.iceCubes)
        
        if inventory.lemons > 0{
            btnStartDay.enabled = true
        }else{
            btnStartDay.enabled = false
            inventory.lemons++                      // add lemon to inventory
            inventory.money -= costLemons           // reduce total money
            updateSupplyView()
            updateMixView()
        }
        var mixRatio:Double = Double(lemonade.iceCubes) / Double(lemonade.lemons)
        println("Mix: Lemons: = \(lemonade.lemons), Ice = \(lemonade.iceCubes), Mix Ratio = \(mixRatio)")
    }
    
    // Helper Functions
    func showMessageAlert(header:String = "Warning", message:String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func resetGame() {
        showMessageAlert(header: "Game Over", message: "You ran out of money and supplies! Play Again?")
        inventory = Supplies(money: 10, lemons: 1, iceCubes: 0)
        updateSupplyView()
    }
}

