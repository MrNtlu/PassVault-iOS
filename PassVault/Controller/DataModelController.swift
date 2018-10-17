//
//  DataModelController.swift
//  PassVault
//
//  Created by Burak Fidan on 12.10.2018.
//  Copyright © 2018 MrNtlu. All rights reserved.
//

import UIKit
import CoreData

class DataModelController {
    
    var tableView:UITableView
    var context:NSPersistentContainer
    
    init(tableView:UITableView,context:NSPersistentContainer) {
        self.tableView=tableView
        self.context=context
    }
    
    static func errorMessage(title:String,message:String)->UIAlertController{
        let alert=UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
    func saveItems(){
        do{
            try context.viewContext.save()
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(request: NSFetchRequest<NSFetchRequestResult>)-> [Any]{
        //let request:NSFetchRequest<Accounts>=Accounts.fetchRequest()
        var returnArray=[Any]()
        do{
            returnArray=try context.viewContext.fetch(request)
        }catch{
            print("Error while loading \(error)")
        }
        return returnArray
    }
    
    func hideThePass(pass:String)->String{
        var password:String=""
        for _ in 1...pass.count{
            password+="*"
        }
        return password
    }
    
    func hideMessageController(indexPath:IndexPath,arrayHidden:[Bool],password:String,passwordLabel:UILabel){
        tableView.beginUpdates()
        if arrayHidden[indexPath.row] {
            passwordLabel.text!=hideThePass(pass:password)
            
        }
        else{
            passwordLabel.text!=password
        }
        tableView.endUpdates()

    }
    
    func starredOrText(passwordText:UILabel,arrayHidden:Bool,passwordString:String){
        if !arrayHidden {
            passwordText.text=hideThePass(pass: passwordString)
        }else{
            passwordText.text=passwordString
        }
    }
    
//    func updateItems(indexPath:Int,idMail:String,password:String){
//        arrayOfData[indexPath].idMail=idMail
//        arrayOfData[indexPath].password=password
//        saveItems()
//    }
}
