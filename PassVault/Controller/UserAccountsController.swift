//
//  UserAccountsController.swift
//  PassVault
//
//  Created by Burak Fidan on 6.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit

struct userCellData {
    let text:String!
    let pass: String!
}
class UserAccountsController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var arrayOfData=[userCellData]()
    
    @IBOutlet weak var userAccountsTable: UITableView!
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAccountsTable.delegate=self
        userAccountsTable.dataSource=self
        arrayOfData=[userCellData(text: "test", pass: "testpass\n/ntesttsa"),
                     userCellData(text: "test2", pass: "testpass2"),
                     userCellData(text: "test3", pass: "testpass3")]
        
        userAccountsTable.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "mailVaultCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=userAccountsTable.dequeueReusableCell(withIdentifier: "mailVaultCell",for:indexPath) as! CustomCell
        cell.idMailText.text=arrayOfData[indexPath.row].text
        cell.passwordText.text=arrayOfData[indexPath.row].pass
        cell.tableView=self.userAccountsTable
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
