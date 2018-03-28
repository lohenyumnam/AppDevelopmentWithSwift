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



}
