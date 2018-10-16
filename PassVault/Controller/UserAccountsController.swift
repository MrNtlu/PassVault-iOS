//
//  UserAccountsController.swift
//  PassVault
//
//  Created by Burak Fidan on 6.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import CoreData

class UserAccountsController: UIViewController {
    
    var arrayOfData=[UserAccounts]()
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer

    @IBOutlet weak var userAccountsTable: UITableView!
    
    func showAlertDialog()->UIAlertController{
        var idMailTextField=UITextField()
        var passwordTextField=UITextField()
        var descTextField=UITextField()
        
        let alert=UIAlertController(title: title, message: "Add New Account", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Add", style: .default) {
            (action)  in
            if(!(idMailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! && !(descTextField.text?.isEmpty)!){
                let newItem=UserAccounts(context: self.context.viewContext)
                newItem.idMail=idMailTextField.text!
                newItem.password=passwordTextField.text!
                newItem.desc=descTextField.text!
                self.arrayOfData.append(newItem)
                DataModelController.saveItems(context: self.context, tableView: self.userAccountsTable)
            }
            else{
                self.present(DataModelController.errorMessage(title: "Error!", message: "Couldn't save. Please don't leave anything empty."),animated: true,completion: nil)
            }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension UserAccountsController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=userAccountsTable.dequeueReusableCell(withIdentifier: "mailVaultCell",for:indexPath) as! CustomCell
        cell.idMailText.text=arrayOfData[indexPath.row].idMail
        cell.passwordText.text=arrayOfData[indexPath.row].password
        //arrayOfData[indexPath.row].desc="Description"
        cell.delegateCell=self
        cell.indexPath=indexPath
        cell.tableView=self.userAccountsTable
        return cell
    }
}
extension UserAccountsController:CellDelegate{
    func didDeleteTapped(index: IndexPath) {
        let alert=UIAlertController(title: "Are You Sure?", message: "Do you want to delete?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "NO!", style: .default, handler: {
            (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            (action) in
            self.context.viewContext.delete(self.arrayOfData[index.row])
            self.arrayOfData.remove(at: index.row)
            self.userAccountsTable.reloadData()
            DataModelController.saveItems(context: self.context, tableView: self.userAccountsTable)
        }))
        
        present (alert, animated: true, completion: nil)
    }
    
    func didEditTapped(index: IndexPath) {
        var idMailTextField=UITextField()
        var passwordTextField=UITextField()
        var descTextField=UITextField()
        
        let alert=UIAlertController(title: title, message: "Update Account", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Update", style: .default) {
            (action)  in
            let newItem=UserAccounts(context: self.context.viewContext)
            newItem.idMail=idMailTextField.text!
            newItem.password=passwordTextField.text!
            newItem.desc=descTextField.text!
            self.context.viewContext.delete(self.arrayOfData[index.row])
            self.arrayOfData.remove(at: index.row)
            self.arrayOfData.append(newItem)
            DataModelController.saveItems(context: self.context, tableView: self.userAccountsTable)
        }
        alert.addTextField {
            (textfield) in
            
            textfield.text=(self.userAccountsTable.cellForRow(at: index) as! CustomCell).idMailText.text!
            idMailTextField=textfield
        }
        alert.addTextField {
            (textfield) in

            textfield.text=(self.userAccountsTable.cellForRow(at: index) as! CustomCell).passwordText.text!
            passwordTextField=textfield
        }
        
        alert.addTextField {
            (textfield) in
            
            textfield.text=self.arrayOfData[index.row].desc
            descTextField=textfield
        }
        
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present (alert, animated: true, completion: nil)
    }
    
    
}
