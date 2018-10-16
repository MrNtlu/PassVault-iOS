//
//  OthersController.swift
//  PassVault
//
//  Created by Burak Fidan on 6.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import CoreData

class OthersController: UIViewController {
    
    var arrayOfData=[Others]()
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    @IBOutlet weak var othersTable: UITableView!
    
    func showAlertDialog()->UIAlertController{
        var descTextField=UITextField()
        var passwordTextField=UITextField()

        let alert=UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Add Account", style: .default) {
            (action)  in
            let newItem=Others(context: self.context.viewContext)
            newItem.desc=descTextField.text!
            newItem.password=passwordTextField.text!
            self.arrayOfData.append(newItem)
            DataModelController.saveItems(context: self.context, tableView: self.othersTable)
        }
        alert.addTextField {
            (textfield) in
            
            textfield.placeholder="Description"
            descTextField=textfield
        }
        alert.addTextField {
            (textfield) in
            
            textfield.placeholder="Password"
            passwordTextField=textfield
        }
        
        alert.addAction(action)
        return alert
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        present (showAlertDialog(), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        othersTable.delegate=self
        othersTable.dataSource=self
        
        othersTable.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "mailVaultCell")
        let request:NSFetchRequest<Others>=Others.fetchRequest()
        arrayOfData=DataModelController.loadItems(context: context,request: request as! NSFetchRequest<NSFetchRequestResult>) as! [Others]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension OthersController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=othersTable.dequeueReusableCell(withIdentifier: "mailVaultCell",for:indexPath) as! CustomCell
        cell.idMailText.text=arrayOfData[indexPath.row].desc
        cell.passwordText.text=arrayOfData[indexPath.row].password
        cell.delegateCell=self
        cell.indexPath=indexPath
        cell.tableView=self.othersTable
        return cell
    }
}
extension OthersController:CellDelegate{
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
            self.othersTable.reloadData()
            DataModelController.saveItems(context: self.context, tableView: self.othersTable)
        }))
        
        present (alert, animated: true, completion: nil)
    }
    
    func didEditTapped(index: IndexPath) {
        var descTextField=UITextField()
        var passwordTextField=UITextField()
        
        let alert=UIAlertController(title: title, message: "Update Account", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Update", style: .default) {
            (action)  in
            let newItem=Others(context: self.context.viewContext)
            newItem.desc=descTextField.text!
            newItem.password=passwordTextField.text!
            self.context.viewContext.delete(self.arrayOfData[index.row])
            self.arrayOfData.remove(at: index.row)
            self.arrayOfData.append(newItem)
            DataModelController.saveItems(context: self.context, tableView: self.othersTable)
        }
        
        alert.addTextField {
            (textfield) in
            
            textfield.text=(self.othersTable.cellForRow(at: index) as! CustomCell).idMailText.text!
            descTextField=textfield
        }

        alert.addTextField {
            (textfield) in
            
            textfield.text=(self.othersTable.cellForRow(at: index) as! CustomCell).passwordText.text!
            passwordTextField=textfield
        }
        
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present (alert, animated: true, completion: nil)
    }
    
    
}
