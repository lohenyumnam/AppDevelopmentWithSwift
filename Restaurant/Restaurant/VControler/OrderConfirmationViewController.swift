//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Lohen Yumnam on 27/03/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    var minutes: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        timeRemainingLabel.text = "Thank you for your order! your wait time is approximately \(minutes!) minutes."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
