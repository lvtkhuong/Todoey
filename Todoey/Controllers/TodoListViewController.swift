//
//  ViewController.swift
//  Todoey
//
//  Created by Le Ngoc Lan Khue on 1/4/18.
//  Copyright © 2018 lvtkhuong. All rights reserved.
//

import UIKit
import RealmSwift
import  ChameleonFramework

class TodoListViewController : SwipeTableViewController {
    
    let realm = try! Realm()
    var itemArray : Results<Item>?
        var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    var catColor : String = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        navBar.barTintColor = UIColor.init(hexString: catColor)
        navBar.tintColor = ContrastColorOf(navBar.barTintColor!, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBar.barTintColor!, returnFlat: true)]
        title = selectedCategory?.name
        searchBar.barTintColor = navBar.barTintColor
    }
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor.init(hexString: "1D9BF6") else { fatalError("")}
        navigationController?.navigationBar.barTintColor = originalColor
    }
    
    //Mark - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let itemTemp = itemArray?[indexPath.row] {
            cell.textLabel?.text = itemTemp.title
            cell.accessoryType = itemTemp.done ? .checkmark : .none
            cell.backgroundColor = UIColor.init(hexString: catColor)?.darken(byPercentage: CGFloat(indexPath.row + 1) / CGFloat(itemArray!.count))
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
         
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
    //Mark: Delete data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemDeletion = self.itemArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemDeletion)
                }
            } catch {
                print("Error deleting Item from Database \(error)")
            }
        }
    }
    
}

//Mark: Search bar methods

extension TodoListViewController : UISearchBarDelegate {
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



    
    
    
    
    
    


