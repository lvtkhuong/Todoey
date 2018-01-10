//
//  ViewController.swift
//  Todoey
//
//  Created by Le Ngoc Lan Khue on 1/4/18.
//  Copyright © 2018 lvtkhuong. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var itemArray : Results<Item>?
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    //Mark - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        if let itemTemp = itemArray?[indexPath.row] {
            cell.textLabel?.text = itemTemp.title
            cell.accessoryType = itemTemp.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No item added yet"
        }
        
        return cell
    }
    
    //Mark - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        do {
            try self.realm.write {
                itemArray![indexPath.row].done = !itemArray![indexPath.row].done

            }
        } catch {
            print("Error updating Item in Database \(error)")
        }
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
                do {
                    try self.realm.write {
                        let itemTemp = Item()
                        itemTemp.title = textField.text!
                        self.selectedCategory?.items.append(itemTemp)
                    }
                } catch {
                    print("Error saving Item in Database \(error)")
                }
                self.tableView.reloadData()
            }
   
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
 
    func loadItems() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
            
    }
    
}

//Mark: Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
//        let predicateTemp = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        loadItems(predicate: predicateTemp)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}


    
    
    
    
    
    


