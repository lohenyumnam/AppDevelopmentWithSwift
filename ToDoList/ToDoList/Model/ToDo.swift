//
//  ToDo.swift
//  ToDoList
//
//  Created by Lohen Yumnam on 19/02/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

struct ToDo: Codable{
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    static func loadToDos() -> [ToDo]?  {
        // geting data from the disk
        guard let codedToDos = try? Data(contentsOf: ArchiveURL) else {return nil}
        
        // Initialising **PropertyListDecoder** to decode the PropertyList file
        let propertyListDecoder = PropertyListDecoder()
        
        // returning the array of ToDo object after decoding from codedToDos
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
    
    static func saveToDos(_ todos: [ToDo]) {
        // Initialising **PropertyListDecoder** to encode the PropertyList file
        let propertyListEncoder = PropertyListEncoder()
        
        // now edcoding the **todos**
        let codedToDos = try? propertyListEncoder.encode(todos)
        
        // Now saving the data to the disk
        try? codedToDos?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    //Inside ToDo type definition
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
 
    static func loadSampleToDo() -> [ToDo]{
        let todo1 = ToDo(title: "ToDo one", isComplete: false, dueDate: Date(), notes: "Note 1")
        let todo2 = ToDo(title: "ToDo two", isComplete: false, dueDate: Date(), notes: "Note 2")
        let todo3 = ToDo(title: "ToDo three", isComplete: false, dueDate: Date(), notes: "Note 3")
        
        return [todo1, todo2, todo3]
    }
}
