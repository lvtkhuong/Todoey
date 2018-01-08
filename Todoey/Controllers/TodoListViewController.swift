//
//  ViewController.swift
//  Todoey
//
//  Created by Le Ngoc Lan Khue on 1/4/18.
//  Copyright © 2018 lvtkhuong. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
//    var itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        } else {
            let newItem = Item()
            newItem.title = "Find Mike"
            itemArray.append(newItem)
            
            let newItem2 = Item()
            newItem2.title = "Buy Eggos"
            itemArray.append(newItem2)
            
            let newItem3 = Item()
            newItem3.title = "Destory Demogorgon"
            itemArray.append(newItem3)
        }
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
        
    }
    
    //Mark - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    //Mark - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //Mark - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != nil && textField.text! != "" {
                let itemTemp = Item()
                itemTemp.title = textField.text!
                self.itemArray.append(itemTemp)
                self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
                self.tableView.reloadData()
            }
            
           
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    
    
}

