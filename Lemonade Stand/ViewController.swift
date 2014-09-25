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
    
    // Variables
    var inventory = Supplies(money: 10, lemons: 1, iceCubes: 0)
    var lemonMix:Int = 1
    var iceMix:Int = 0
    var mixRatio:Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if inventory.money == 0 && inventory.lemons == 0 && inventory.iceCubes == 0{ // Reset Game if User runs out of credits/supplies
            showMessageAlert(header: "Game Over", message: "You ran out of money and supplies! Play Again?")
            inventory = Supplies(money: 10, lemons: 1, iceCubes: 0)
        }
        
        updateSupplyView()
        lemonMix = 1
        iceMix = 0
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
            if lemonMix > inventory.lemons {            // ensure that user isn't capable of mixing supplies they haven't purchased
                lemonMix = inventory.lemons
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
            if iceMix > inventory.iceCubes {            // ensure that user isn't capable of mixing supplies they haven't purchased
                iceMix = inventory.iceCubes
                updateMixView()
            }
        }
    }
    
    @IBAction func lemonMixStepperPressed(sender: UIStepper) { // Mixing Lemons
        lemonMix = Int(sender.value)                    // update lemonMix variable
        updateMixView()
    }
    
    @IBAction func iceMixStepperPressed(sender: UIStepper) { // Mixing Ice Cubes
        iceMix = Int(sender.value)                      // update iceMix variable
        updateMixView()
    }
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        
        if lemonMix == 0 {                              // Alert user in case they forget to add lemons
            showMessageAlert(message: "You can't make lemonade without lemons!")
        }
        
        // Subtract Mixed Supplies from Inventory
        inventory.lemons -= lemonMix
        inventory.iceCubes -= iceMix
        
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
        
        println("Inventory: Money = \(inventory.money), Lemons = \(inventory.lemons), Ice = \(inventory.iceCubes)")
    }
    
    func updateMixView() {
        lblMixLemon.text = "\(lemonMix)"
        lblMixIce.text = "\(iceMix)"
        
        stepperMixLemon.value = Double(lemonMix)
        stepperMixIce.value = Double(iceMix)
        
        if inventory.lemons > 0{
            btnStartDay.enabled = true
        }else{
            btnStartDay.enabled = false
            inventory.lemons++                      // add lemon to inventory
            inventory.money -= costLemons           // reduce total money
            updateSupplyView()
            updateMixView()
        }
        println("Mix: Lemons: = \(lemonMix), Ice = \(iceMix)")
    }
    
    // Helper Functions
    func showMessageAlert(header:String = "Warning", message:String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}

