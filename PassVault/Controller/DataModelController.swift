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
    
    static func saveItems(context:NSPersistentContainer,tableView:UITableView){
        do{
            try context.viewContext.save()
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    static func loadItems(context:NSPersistentContainer)-> [Any]{
        let request:NSFetchRequest<Accounts>=Accounts.fetchRequest()
        var returnArray=[Any]()
        do{
            returnArray=try context.viewContext.fetch(request)
        }catch{
            print("Error while loading \(error)")
        }
        return returnArray
    }
    
//    func updateItems(indexPath:Int,idMail:String,password:String){
//        arrayOfData[indexPath].idMail=idMail
//        arrayOfData[indexPath].password=password
//        saveItems()
//    }
}
