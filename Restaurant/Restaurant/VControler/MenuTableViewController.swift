//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Lohen Yumnam on 24/03/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    // Since this view controller will never be displayed without category data, we can make the property an implicitly unwrapped optional.
    var category: String!
    var menuItems = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting the title as the category name
        title = category.capitalized
        MenuController.shared.fetchMenuItems(categoryName: category) { (menuItems) in
            if let menuItems = menuItems{
                self.updateUI(with: menuItems)
            }
        }
    }
    
    func updateUI(with menuItems: [MenuItem]){
        DispatchQueue.main.async {
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)
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
    
    // Increasing the hight for cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuDetailSegue"{
            let menuItemDetailViewController = segue.destination as! MenuItemDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            
            menuItemDetailViewController.menuItem = menuItems[index]
        }
    }
    

}
