//
//  UserAccountsController.swift
//  PassVault
//
//  Created by Burak Fidan on 6.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import CoreData

class UserAccountsController: UIViewController,UIGestureRecognizerDelegate {
    
    var arrayOfData=[UserAccounts]()
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var arrayHidden=[Bool]()
    var mainController:DataModelController?

    @IBOutlet weak var userAccountsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAccountsTable.delegate=self
        userAccountsTable.dataSource=self
        userAccountsTable.register(UINib(nibName: "CustomDescCell", bundle: nil), forCellReuseIdentifier: "userAccountsCell")
        let request:NSFetchRequest<UserAccounts>=UserAccounts.fetchRequest()
        mainController=DataModelController.init(tableView: self.userAccountsTable, context: self.context)
        arrayOfData=mainController!.loadItems(request: request as! NSFetchRequest<NSFetchRequestResult>) as! [UserAccounts]
        setupLongPressGesture()
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.userAccountsTable.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.userAccountsTable)
            if let indexPath = userAccountsTable.indexPathForRow(at: touchPoint) {
                UIPasteboard.general.string=self.arrayOfData[indexPath.row].password!
                mainController!.showToast(message: "Copied",view: self.view)
            }
        }
    }
    
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
                self.mainController!.saveItems()
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
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        return alert
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        present (showAlertDialog(), animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension UserAccountsController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainController!.hideMessageController(indexPath: indexPath,arrayHidden: self.arrayHidden,password: self.arrayOfData[indexPath.row].password!,passwordLabel: (self.userAccountsTable.cellForRow(at: indexPath) as! CustomDescCell).passwordText)
        self.arrayHidden[indexPath.row] = !(self.arrayHidden[indexPath.row])
        userAccountsTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayOfData.count != arrayHidden.count && arrayOfData.count>arrayHidden.count {
            arrayHidden.append(false)
        }
        
        let cell=userAccountsTable.dequeueReusableCell(withIdentifier: "userAccountsCell",for:indexPath) as! CustomDescCell
        cell.idMailText.text=arrayOfData[indexPath.row].idMail
        if !arrayHidden[indexPath.row] {
            cell.passwordText.text=mainController!.hideThePass(pass: arrayOfData[indexPath.row].password!)
        }else{
            cell.passwordText.text=arrayOfData[indexPath.row].password!
        }
        cell.descText.text=arrayOfData[indexPath.row].desc
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
            self.mainController!.saveItems()
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
            self.mainController!.saveItems()
        }
        alert.addTextField {
            (textfield) in
            
            textfield.text=(self.userAccountsTable.cellForRow(at: index) as! CustomDescCell).idMailText.text!
            idMailTextField=textfield
        }
        alert.addTextField {
            (textfield) in

            textfield.text=self.arrayOfData[index.row].password
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
