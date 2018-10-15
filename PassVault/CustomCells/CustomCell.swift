//
//  CustomCell.swift
//  PassVault
//
//  Created by Burak Fidan on 6.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    func didDeleteTapped(index: IndexPath)
    func didEditTapped(index: IndexPath)
}

class CustomCell: UITableViewCell {
    @IBOutlet weak var idMailText: UILabel!
    
    @IBOutlet weak var passwordText: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    //Protocol Inits
    var delegateCell:CellDelegate?
    var indexPath:IndexPath?
    
    var tableView:UITableView!
    
    @IBAction func deleteButton(_ sender: UIButton) {
        delegateCell?.didDeleteTapped(index: indexPath!)
    }
    
    
    @IBAction func editButton(_ sender: Any) {
        delegateCell?.didEditTapped(index: indexPath!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
