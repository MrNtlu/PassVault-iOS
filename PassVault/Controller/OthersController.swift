//
//  OthersController.swift
//  PassVault
//
//  Created by Burak Fidan on 6.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit

struct otherCellData {
    let text:String!
    let pass: String!
}
class OthersController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var arrayOfData=[otherCellData]()
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBOutlet weak var othersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        othersTable.delegate=self
        othersTable.dataSource=self
        arrayOfData=[otherCellData(text: "test", pass: "testpass\n/ntesttsa\netasdasd\ntesada"),
                     otherCellData(text: "test2", pass: "testpass2"),
                     otherCellData(text: "test3", pass: "testpass3")]
        
        othersTable.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "mailVaultCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=othersTable.dequeueReusableCell(withIdentifier: "mailVaultCell",for:indexPath) as! CustomCell
        cell.idMailText.text=arrayOfData[indexPath.row].text
        cell.passwordText.text=arrayOfData[indexPath.row].pass
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
