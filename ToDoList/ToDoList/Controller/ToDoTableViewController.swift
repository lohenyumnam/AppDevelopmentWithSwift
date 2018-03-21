//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Lohen Yumnam on 19/02/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {

    var toDos = [ToDo]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding the Edit Button on left side of View Controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let saveTODos = ToDo.loadToDos(){
            toDos = saveTODos
        } else {
            toDos =  ToDo.loadSampleToDo()
        }
    }
    
    // This will tell the tableView How many row will be there in a section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    // This will display what is it going to be in cell for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") as? ToDoCell else {
                    fatalError("Could not dequeue a cell")
        }

        cell.delegate = self
        
        let todo = toDos[indexPath.row]
        cell.titleLabel?.text = todo.title
        cell.isCompleteButton.isSelected = todo.isComplete
        return cell
    }
    
    // this will enable edting for each row
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // This will Delete the row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //Verify that the Delete button triggered the method call
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(toDos)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let todoViewController = segue.destination as! AddToDoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = toDos[indexPath.row]
            todoViewController.todo = selectedTodo
        }
    }
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = toDos[indexPath.row]
            todo.isComplete = !todo.isComplete
            toDos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(toDos)
        }
    }
    
    
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! AddToDoViewController
        
        if let todo = sourceViewController.todo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow { // if the cell is already selected no new data will create insted it will be updated
                toDos[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: toDos.count, section: 0)
                toDos.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
       ToDo.saveToDos(toDos)
    }
}
