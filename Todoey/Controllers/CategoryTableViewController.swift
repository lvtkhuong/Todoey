//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Le Ngoc Lan Khue on 1/8/18.
//  Copyright © 2018 lvtkhuong. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryData()

     
    }

    //Mark: Tableview data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
        cell.textLabel?.text = categoryArray[indexPath.row].name
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
                destinationVC.selectedCategory = categoryArray[indexPath.row]
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
                let newCategory = Category(context: self.context)
                newCategory.name = categoryTextField.text!
                self.categoryArray.append(newCategory)
                self.saveCategoryData()
                self.tableView.reloadData()
            }
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
  
    //Mark: Data manipulation methods
    
    func saveCategoryData(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    func loadCategoryData(request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
        
    }
   
    
    
    
    
  
}
