//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Le Ngoc Lan Khue on 1/8/18.
//  Copyright © 2018 lvtkhuong. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categoryArray : Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryData()
        tableView.rowHeight = 80

     
    }

    //Mark: Tableview data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No category added yet"
      
        return cell
    }
    
    //Mark: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray?[indexPath.row]
            }
        }
        
        
    }
    //Mark: Add new categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryTextField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new category"
            categoryTextField = alertTextField
        }
        let action = UIAlertAction(title: "Add category", style: .default) { (alertAction) in
            if categoryTextField.text != nil && categoryTextField.text! != "" {
                let newCategory = Category()
                newCategory.name = categoryTextField.text!
                self.saveCategoryData(category: newCategory)
                self.tableView.reloadData()
            }
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
  
    //Mark: Data manipulation methods
    
    func saveCategoryData(category : Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error write newCategory in to Database \(error)")
        }
    }
    func loadCategoryData(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    //Mark: Delete data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryDeletion = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryDeletion.items)
                    self.realm.delete(categoryDeletion)
                }
            } catch {
                print("Error deleting Item from Database \(error)")
            }

        }
    }
}


