//
//  MailVaultController.swift
//  PassVault
//
//  Created by Burak Fidan on 6.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import CoreData

class MailVaultController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //Video 250
    var arrayOfData=[Accounts]()
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer

    @IBOutlet weak var mailTableView: UITableView!
    
    func showAlertDialog()->UIAlertController{
        var idMailTextField=UITextField()
        var passwordTextField=UITextField()
        
        let alert=UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Add Account", style: .default) {
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
        arrayOfData=DataModelController.loadItems(context: context) as! [Accounts]
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=mailTableView.dequeueReusableCell(withIdentifier: "mailVaultCell",for:indexPath) as! CustomCell
        cell.idMailText.text=arrayOfData[indexPath.row].idMail
        cell.passwordText.text=arrayOfData[indexPath.row].password
        cell.tableView=self.mailTableView
        return cell
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
}
