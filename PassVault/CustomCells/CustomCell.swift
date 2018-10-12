//
//  CustomCell.swift
//  PassVault
//
//  Created by Burak Fidan on 6.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var idMailText: UILabel!
    
    @IBOutlet weak var passwordText: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    var tableView:UITableView!
    
    @IBAction func deleteButton(_ sender: UIButton) {
        tableView.beginUpdates()
        
        tableView.endUpdates()
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
