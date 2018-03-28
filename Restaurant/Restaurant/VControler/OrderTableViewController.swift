//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Lohen Yumnam on 24/03/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit
import UserNotifications

class OrderTableViewController: UITableViewController, AddToOrderDelegate {
   
    var menuItems = [MenuItem]()
    var orderMinutes: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding Edit button on NavigationBar
        navigationItem.leftBarButtonItem = editButtonItem

    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)
        
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "₹%.2f", menuItem.price)
        
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                
                // “For table view cells, you'll need to make an additional check. Recall that, in longer lists of data, cells will be recycled and reused as you scroll up and down the table. Since you don't want to put the wrong image into a recycled cell, check which index path the cell is now located. If it's changed, you can skip setting the image view.
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath { return }
                cell.imageView?.image = image
            }
        }

        return cell
    }
    
    func added(menuItem: MenuItem) {
        menuItems.append(menuItem)
        
        let count = menuItems.count
        let indexPath = IndexPath(row: count-1, section: 0)
        
        tableView.insertRows(at: [indexPath], with: .automatic)
        updateBadgeNumber()
    }
    
    // This will add the number of order in the tabBar
    func updateBadgeNumber(){
        let badgeValue = menuItems.count > 0 ? "\(menuItems.count)" : nil
        navigationController?.tabBarItem.badgeValue = badgeValue
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            menuItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateBadgeNumber()
        }
    }
    
    // Increasing the hight for cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func uploadOrder(){
        let menuIDs = menuItems.map{ $0.id}
        MenuController.shared.submitOrder(menuIds: menuIDs) { (minutes) in
            DispatchQueue.main.async {
                if let minutes = minutes {
                    self.orderMinutes = minutes
                    self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                }
            }
        }
    }
    
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        // Reduce - return the total sum of the number
        let orderTotal = menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        
        let formattedOrder = String(format: "₹%.2f", orderTotal)
        
        let alert = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedOrder)", preferredStyle: .alert)
        
        // Creating action button for the alert
        let submit = UIAlertAction(title: "Submit", style: .default) { (action) in self.uploadOrder() }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        // Adding the action button to the alert
        alert.addAction(submit)
        alert.addAction(cancel)
        
        // Showing the alert
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "DismissConfirmation" {
            menuItems.removeAll()
            tableView.reloadData()
            updateBadgeNumber()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationSegue" {
            let orderConfirmationViewController = segue.destination as! OrderConfirmationViewController
            orderConfirmationViewController.minutes = orderMinutes
            
            notification(time: orderMinutes)
        }
    }
    
    func notification(time: Int){
        let timeInSec = (time - 5)*60
        
        let notification = UNMutableNotificationContent()
        notification.title = "Hello Dear"
        notification.body = "Your Order will be here soon"
        notification.sound = UNNotificationSound.default()

        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInSec), repeats: false)
        let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    

}
