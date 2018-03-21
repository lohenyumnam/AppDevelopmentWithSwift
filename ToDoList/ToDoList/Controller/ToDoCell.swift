//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Lohen Yumnam on 20/02/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

@objc protocol ToDoCellDelegate: class {
    func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: ToDoCellDelegate?
    
    @IBAction func completeButtonTapped() {
        delegate?.checkmarkTapped(sender: self)
    }

}
