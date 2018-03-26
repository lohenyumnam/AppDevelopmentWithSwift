//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by Lohen Yumnam on 24/03/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    
    var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        MenuController.shared.fetchCategories{ (categories) in
            if let categories = categories {
                self.updateUI(with: categories)
            }
        }
    }
    
    func updateUI(with categories: [String]){
        // network request is always called on a background thread—and so is your fetchCategories closure. To update the UI immediately, you'll need to return to the main thread.
        // As the updateUI is being called from the closure of fetchCategories's which is the "complition" closure, which is also inside the closure of the URLSession. we need to send the code to Main Queue
        DispatchQueue.main.async {
            self.categories = categories
            self.tableView.reloadData()
        }
    }

    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].capitalized

        return cell
    }
    
   // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuSegue"{
            let menuTableViewController = segue.destination as! MenuTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuTableViewController.category = categories[index]
        }
    }
 

}
