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
    @IBOutlet weak var lblLemonsInv: UILabel!
    @IBOutlet weak var lblIceInv: UILabel!
    @IBOutlet weak var lblPurchLemons: UILabel!
    @IBOutlet weak var lblPurchIce: UILabel!
    @IBOutlet weak var lblMixLemon: UILabel!
    @IBOutlet weak var lblMixIce: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Buttons Pressed Actions
    
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        
    }
    

}

