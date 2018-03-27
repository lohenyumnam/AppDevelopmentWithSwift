//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Lohen Yumnam on 24/03/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    // Since the detail screen will never be presented without a MenuItem object in place, you can define the property as an implicitly unwrapped optional
    var menuItem: MenuItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    func updateUI(){
        titleLabel.text = menuItem.name
        priceLabel.text = String(format: "₹%.2f", menuItem.price)
        descriptionLabel.text = menuItem.description
    }
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        // A quick bounce Animation
        UIView.animate(withDuration: 0.3) {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
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
