//
//  MailVaultController.swift
//  PassVault
//
//  Created by Burak Fidan on 6.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import CoreData

class MailVaultController: UIViewController{
    
    var arrayOfData=[Accounts]()
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer

    @IBOutlet weak var mailTableView: UITableView!
    
    func showAlertDialog()->UIAlertController{
        var idMailTextField=UITextField()
        var passwordTextField=UITextField()
        
        let alert=UIAlertController(title: title, message: "Add New Account", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Add", style: .default) {
            (action)  in
            let newItem=Accounts(context: self.context.viewContext)
            newItem.idMail=idMailTextField.text!
            newItem.password=passwordTextField.text!
            self.arrayOfData.append(newItem)
            DataModelController.saveItems(context: self.context, tableView: self.mailTableView)
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
        
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        return alert
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        present (showAlertDialog(), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mailTableView.delegate=self
        mailTableView.dataSource=self
        mailTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "mailVaultCell")
        let request:NSFetchRequest<Accounts>=Accounts.fetchRequest()
        arrayOfData=DataModelController.loadItems(context: context,request: request as! NSFetchRequest<NSFetchRequestResult>) as! [Accounts]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mailTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MailVaultController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=mailTableView.dequeueReusableCell(withIdentifier: "mailVaultCell",for:indexPath) as! CustomCell
        cell.idMailText.text=arrayOfData[indexPath.row].idMail
        cell.passwordText.text=arrayOfData[indexPath.row].password
        cell.tableView=self.mailTableView
        cell.delegateCell=self
        cell.indexPath=indexPath
        return cell
    }
}
extension MailVaultController:CellDelegate{
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
            self.mailTableView.reloadData()
            DataModelController.saveItems(context: self.context, tableView: self.mailTableView)
        }))
        
        present (alert, animated: true, completion: nil)
    }

    func didEditTapped(index: IndexPath) {
        var idMailTextField=UITextField()
        var passwordTextField=UITextField()
        
        let alert=UIAlertController(title: title, message: "Update Account", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Update", style: .default) {
            (action)  in
            let newItem=Accounts(context: self.context.viewContext)
            newItem.idMail=idMailTextField.text!
            newItem.password=passwordTextField.text!
            self.context.viewContext.delete(self.arrayOfData[index.row])
            self.arrayOfData.remove(at: index.row)
            self.arrayOfData.insert(newItem, at: index.row)
            DataModelController.saveItems(context: self.context, tableView: self.mailTableView)
        }
        alert.addTextField {
            (textfield) in
            
            textfield.text=(self.mailTableView.cellForRow(at: index) as! CustomCell).idMailText.text!
            idMailTextField=textfield
        }
        alert.addTextField {
            (textfield) in
            
            textfield.text=(self.mailTableView.cellForRow(at: index) as! CustomCell).passwordText.text!
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
    
//    func saveItems(){
//        do{
//            try context.save()
//        }catch{
//            print("Error saving context \(error)")
//        }
//        self.mailTableView.reloadData()
//    }
//
//    func loadItems(){
//        let request:NSFetchRequest<Accounts>=Accounts.fetchRequest()
//        do{
//            arrayOfData=try context.fetch(request)
//        }catch{
//            print("Error while loading \(error)")
//        }
//    }
    
//    func updateItems(indexPath:Int,idMail:String,password:String){
//        arrayOfData[indexPath].idMail=idMail
//        arrayOfData[indexPath].password=password
//        saveItems()
//    }

