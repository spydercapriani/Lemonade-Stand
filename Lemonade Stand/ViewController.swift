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
    @IBOutlet weak var lblConsistency: UILabel!
    
    // Buttons
    @IBOutlet weak var stepperPurchLemons: UIStepper!
    @IBOutlet weak var stepperPurchIce: UIStepper!
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
        lemonade.lemons = inventory.lemons
        lemonade.iceCubes = inventory.iceCubes
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Buttons Pressed Actions
    @IBAction func lemonPurchStepperPressed(sender: UIStepper) { // Purchasing Lemons
        if Int(sender.value) > inventory.lemons {                                       // stepper value has increased (+ Button pressed)
            if (inventory.money - costLemons) < 0 {  // User doesn't have the funds to purchase any more lemons
                showMessageAlert(header: "Not Enough Funds", message: "You don't have the necessary funds to make this purchase")
                println("LemonPurchase: Not Enough Funds")
                sender.value--     // make sure stepper value stays the same
            }else{                                  // User purchase more lemons
                inventory.lemons++              // add lemon to inventory
                inventory.money -= costLemons   // reduce total money
                lemonade.lemons++               // Add lemon to mix
                updateView()
            }
        }else{                                                                          // stepper value has decreased (- Button pressed)
            inventory.lemons--                  // reduce lemon inventory
            inventory.money += costLemons       // refund cost of lemon
            lemonade.lemons--                   // remove lemon from mix
            updateView()
        }
        
    }
    
    @IBAction func icePurchStepperPressed(sender: UIStepper) { // Purchasing Ice Cubes
        if Int(sender.value) > inventory.iceCubes {                                     // stepper value has increased (+ Button pressed)
            if (inventory.money - costIce) < 0 {        // User doesn't have the funds to purchase any more iceCubes
                showMessageAlert(header: "Not Enough Funds", message: "You don't have the necessary funds to make this purchase")
                println("IcePurchase: Not Enough Funds")
                sender.value--                     // make sure stepper value stays the same
            }else{                                      // User purchase more iceCubes
                inventory.iceCubes++               // add ice to inventory
                inventory.money -= costIce         // reduce total money
                lemonade.iceCubes++                // add ice to mix
                updateView()
            }
        }else{                                                                          // stepper value has decreased (- Button pressed)
            inventory.iceCubes--                   // reduce ice inventory
            inventory.money += costIce             // refund cost of ice
            lemonade.iceCubes--                    // remove ice from the mix
            updateView()
        }
    }
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        if lemonade.lemons == 0 {                              // Don't allow user to start without adding at least 1 lemons
            showMessageAlert(message: "You can't make lemonade without lemons!")
        }else {
            let mixRatio:Double = Double(lemonade.iceCubes) / Double(lemonade.lemons)
            println("\nstartDay: Ice = \(lemonade.iceCubes), Lemons: = \(lemonade.lemons), Mix Ratio = \(mixRatio)")
            
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
            println("\nstartDay: Money(Before) = $\(inventory.money)")
            inventory.money += totalSales
            println("startDay: Total Sales = $\(totalSales)")
            println("startDay: Money(after) = $\(inventory.money)\n")
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
    func updateView() {
        // Ensure stepper values are = to what's in inventory
        stepperPurchLemons.value = Double(inventory.lemons)
        stepperPurchIce.value = Double(inventory.iceCubes)
        
        // Update Inventory View Labels to reflect changes made
        lblMoney.text = "$\(inventory.money)"
        lblLemons.text = "\(inventory.lemons)"
        lblIce.text = "\(inventory.iceCubes)"
        let mixRatio = Double(lemonade.iceCubes) / Double(lemonade.lemons)
        if 1 == mixRatio {
            lblConsistency.text = "Equal"
            lblConsistency.textColor = UIColor.yellowColor()
        }else if mixRatio > 1 {
            lblConsistency.text = "Diluted"
            lblConsistency.textColor = UIColor.greenColor()
        }else{
            lblConsistency.text = "Acidic"
            lblConsistency.textColor = UIColor.redColor()
        }
        
        // Test to make sure Player is eligible to play
        if inventory.money < 0 {
            println("updateView: Game Over!")
            resetGame()
        }else{
            if inventory.lemons != 0{ // print only once automatic purchases have been made
                println("\nInventory: Money = \(inventory.money), Ice = \(inventory.iceCubes), Lemons = \(inventory.lemons)")
                println("Mix: Ice = \(lemonade.iceCubes), Lemons = \(lemonade.lemons), Mix Ratio = \(mixRatio)")
            }
        }
        
        
        // Ensure that at least one lemon has been used
        if inventory.lemons > 0{
            btnStartDay.enabled = true
        }else{
            btnStartDay.enabled = false
            inventory.lemons++              // Automatically add Lemon to Inventory
            inventory.money -= costLemons   // Automatically invoice against money
            lemonade.lemons++               // Automatically add lemon to mix
            updateView()
        }
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
        updateView()
    }
}

