//
//  AddToDoViewController.swift
//  ToDoList
//
//  Created by Lohen Yumnam on 20/02/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

class AddToDoViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var isEndDatePickerHidden = true
    
    var todo: ToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todo {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            dueDatePickerView.date = todo.dueDate
            notesTextView.text = todo.notes
        } else {
            dueDatePickerView.date = Date().addingTimeInterval(24*60*60)
        }

        updateDueDateLabel(date: dueDatePickerView.date)
        updateSaveButtonState()
        
        
    }
    
    // Changing the hide of the cell to hide and show the date picker
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        
        switch(indexPath) {
        case [1,0]: //Due Date Cell
            return isEndDatePickerHidden ? normalCellHeight : largeCellHeight
        
        case [2,0]: //Notes Cell
            return largeCellHeight
        
        default: return normalCellHeight
        }
    }
    
    // TO respond to user tap
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath) {
        case [1,0]:
            isEndDatePickerHidden = !isEndDatePickerHidden
            dueDateLabel.textColor = isEndDatePickerHidden ? .black : tableView.tintColor
            tableView.beginUpdates()
            tableView.endUpdates()

        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "saveUnwind" else { return }
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        todo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
}
    
    
    
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    
    
    
    // This keyboard will call when there is any changes in textfield
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // this Action will call when we press return on keyboard
    @IBAction func returnPressed(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
    }
}
