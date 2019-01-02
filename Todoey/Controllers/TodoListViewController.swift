//
//  ViewController.swift
//  Todoey
//
//  Created by Laila Espinoza on 12/28/18.
//  Copyright © 2018 Laila Espinoza. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController{
    
    var items: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK - Tableview Datasource Methods
    
    //cells should display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
           cell.textLabel?.text = items?[indexPath.row].title ?? "No Items Added"
            
           //cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    //sets number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    
    //MARK - Table View Delegate Methods
    
    //delegate didSelectRowAt
    //update item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    //                    realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving doen status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) //does not leave cell grey when clicked, goes back to white
    }
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.items?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    //MARK - Add New Items
    //Create item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen when auser clicks the add item button on alert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textfield.text!
                        currentCategory.items.append(newItem)
                        newItem.dateCreated = Date()
                    }
                }
                catch {
                    print("Error saving context \(error) ")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK - Model Manipulation Methods
    
    //gets data that is in database, Read items
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        items = realm.objects(Item.self)
        tableView.reloadData()
    }
    
    
    
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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
