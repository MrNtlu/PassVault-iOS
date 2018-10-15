//
//  UserAccountsController.swift
//  PassVault
//
//  Created by Burak Fidan on 6.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import CoreData

class UserAccountsController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var arrayOfData=[UserAccounts]()
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer

    @IBOutlet weak var userAccountsTable: UITableView!
    
    func showAlertDialog()->UIAlertController{
        var idMailTextField=UITextField()
        var passwordTextField=UITextField()
        var descTextField=UITextField()
        
        let alert=UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Add Account", style: .default) {
            (action)  in
            let newItem=UserAccounts(context: self.context.viewContext)
            newItem.idMail=idMailTextField.text!
            newItem.password=passwordTextField.text!
            newItem.desc=descTextField.text!
            self.arrayOfData.append(newItem)
            DataModelController.saveItems(context: self.context, tableView: self.userAccountsTable)
        }
        alert.addTextField {
            (textfield) in
            
            textfield.placeholder="ID/Mail"
            idMailTextField=textfield
        }
        alert.addTextField {
            (textfield) in
            
            textfield.placeholder="Password"
            passwordTextField=textfield
        }
        alert.addTextField {
            (textfield) in
            
            textfield.placeholder="Description"
            descTextField=textfield
        }
        
        alert.addAction(action)
        return alert
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        present (showAlertDialog(), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAccountsTable.delegate=self
        userAccountsTable.dataSource=self
        
        userAccountsTable.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "mailVaultCell")
        let request:NSFetchRequest<UserAccounts>=UserAccounts.fetchRequest()
        arrayOfData=DataModelController.loadItems(context: context,request: request as! NSFetchRequest<NSFetchRequestResult>) as! [UserAccounts]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=userAccountsTable.dequeueReusableCell(withIdentifier: "mailVaultCell",for:indexPath) as! CustomCell
        cell.idMailText.text=arrayOfData[indexPath.row].idMail
        cell.passwordText.text=arrayOfData[indexPath.row].password
        //arrayOfData[indexPath.row].desc="Description"
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
