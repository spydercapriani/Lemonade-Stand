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
    
    // Constants
    let costLemons:Int = 2
    let costIce:Int = 1
    
    // Variables
    var oldLemonsPurch = 0
    var oldIcePurch = 0
    var oldLemonsMix = 0
    var oldIceMix = 0
    
    var lemonMix:Int = 0
    var iceMix:Int = 0
    
    var inventory = Supplies(money: 10, lemons: 0, iceCubes: 0)
    
    var totalCost:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateSupplyView()
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
        }
        println("Inventory: Money = \(inventory.money), Lemons = \(inventory.lemons), Ice = \(inventory.iceCubes)")
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
        }
        println("Inventory: Money = \(inventory.money), Lemons = \(inventory.lemons), Ice = \(inventory.iceCubes)")
    }
    
    @IBAction func lemonMixStepperPressed(sender: UIStepper) { // Mixing Lemons
        lblMixLemon.text = Int(sender.value).description
    }
    
    @IBAction func iceMixStepperPressed(sender: UIStepper) { // Mixing Ice Cubes
        lblMixIce.text = Int(sender.value).description
    }
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        
    }
    
    // Helper
    func showMessageAlert(header:String = "Warning", message:String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateSupplyView() {
        lblMoney.text = "$\(inventory.money)"
        lblLemons.text = "\(inventory.lemons)"
        lblIce.text = "\(inventory.iceCubes)"
        
        stepperPurchLemons.value = Double(inventory.lemons)
        stepperPurchIce.value = Double(inventory.iceCubes)
    }
}

