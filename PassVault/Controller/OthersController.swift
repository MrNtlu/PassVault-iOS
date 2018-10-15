//
//  OthersController.swift
//  PassVault
//
//  Created by Burak Fidan on 6.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import CoreData

class OthersController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var arrayOfData=[Others]()
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBOutlet weak var othersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        othersTable.delegate=self
        othersTable.dataSource=self
        
        othersTable.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "mailVaultCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=othersTable.dequeueReusableCell(withIdentifier: "mailVaultCell",for:indexPath) as! CustomCell
        cell.idMailText.text=arrayOfData[indexPath.row].desc
        cell.passwordText.text=arrayOfData[indexPath.row].password
        cell.tableView=self.othersTable
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
