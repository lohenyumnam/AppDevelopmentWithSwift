//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Lohen Yumnam on 24/03/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

protocol AddToOrderDelegate {
    func added(menuItem: MenuItem)
}

class MenuItemDetailViewController: UIViewController {
    // Since the detail screen will never be presented without a MenuItem object in place, you can define the property as an implicitly unwrapped optional
    var menuItem: MenuItem!
    
    var delegate: AddToOrderDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupDelegate()
    }

    func updateUI(){
        titleLabel.text = menuItem.name
        priceLabel.text = String(format: "₹%.2f", menuItem.price)
        descriptionLabel.text = menuItem.description
    }
    
    func setupDelegate(){
        if let navController = tabBarController?.viewControllers?.last as? UINavigationController{
            if let orderTableViewController = navController.viewControllers.first as? OrderTableViewController{
                delegate = orderTableViewController
            }
        }
        
    }
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        // A quick bounce Animation
        UIView.animate(withDuration: 0.3) {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        delegate?.added(menuItem: menuItem)
    }

}
