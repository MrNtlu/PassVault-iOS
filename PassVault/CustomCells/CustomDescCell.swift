//
//  CustomDescCell.swift
//  PassVault
//
//  Created by Burak Fidan on 17.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit

class CustomDescCell: UITableViewCell {

    @IBOutlet weak var idMailText: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var passwordText: UILabel!
    
    @IBOutlet weak var descText: UILabel!
    
    var delegateCell:CellDelegate?
    var indexPath:IndexPath?
    
    var tableView:UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func editButton(_ sender: Any) {
        delegateCell?.didEditTapped(index: indexPath!)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        delegateCell?.didDeleteTapped(index: indexPath!)
    }
    
}
