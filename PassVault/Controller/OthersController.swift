//
//  OthersController.swift
//  PassVault
//
//  Created by Burak Fidan on 6.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import CoreData

class OthersController: UIViewController,UIGestureRecognizerDelegate {
    
    var arrayOfData=[Others]()
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var arrayHidden=[Bool]()
    var mainController:DataModelController?
    
    
    @IBOutlet weak var othersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        othersTable.delegate=self
        othersTable.dataSource=self
        othersTable.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "mailVaultCell")
        let request:NSFetchRequest<Others>=Others.fetchRequest()
        mainController=DataModelController.init(tableView: self.othersTable, context: self.context)
        arrayOfData=mainController!.loadItems(request: request as! NSFetchRequest<NSFetchRequestResult>) as! [Others]
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.othersTable.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.othersTable)
            if let indexPath = othersTable.indexPathForRow(at: touchPoint) {
                UIPasteboard.general.string=self.arrayOfData[indexPath.row].password!
                mainController!.showToast(message: "Copied",view: self.view)
            }
        }
    }
    
    func showAlertDialog()->UIAlertController{
        var descTextField=UITextField()
        var passwordTextField=UITextField()

        let alert=UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Add Account", style: .default) {
            (action)  in
            if (!(descTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)!){
                let newItem=Others(context: self.context.viewContext)
                newItem.desc=descTextField.text!
                newItem.password=passwordTextField.text!
                self.arrayOfData.append(newItem)
                self.mainController!.saveItems()
            }
            else{
                self.present (DataModelController.errorMessage(title: "Error!", message: "Couldn't save. Please don't leave anything empty."), animated: true, completion: nil)
            }
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
extension OthersController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainController!.hideMessageController(indexPath: indexPath,arrayHidden: self.arrayHidden,password: self.arrayOfData[indexPath.row].password!,passwordLabel: (self.othersTable.cellForRow(at: indexPath) as! CustomCell).passwordText)
        self.arrayHidden[indexPath.row] = !(self.arrayHidden[indexPath.row])
        othersTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayOfData.count != arrayHidden.count && arrayOfData.count>arrayHidden.count {
            arrayHidden.append(false)
        }
        
        let cell=othersTable.dequeueReusableCell(withIdentifier: "mailVaultCell",for:indexPath) as! CustomCell
        cell.idMailText.text=arrayOfData[indexPath.row].desc
        if !arrayHidden[indexPath.row] {
            cell.passwordText.text=mainController!.hideThePass(pass: arrayOfData[indexPath.row].password!)
        }else{
            cell.passwordText.text=arrayOfData[indexPath.row].password!
        }
        cell.idMailLabel.text="Desc.:"
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
            self.mainController!.saveItems()
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
            self.mainController!.saveItems()
        }
        
        alert.addTextField {
            (textfield) in
            
            textfield.text=(self.othersTable.cellForRow(at: index) as! CustomCell).idMailText.text!
            descTextField=textfield
        }

        alert.addTextField {
            (textfield) in
            
            textfield.text=self.arrayOfData[index.row].password
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
