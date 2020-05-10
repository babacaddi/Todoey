//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    //OPTION (1): UserDefaults
//    // WANT TO PERSIST DATA IN UserDefaults
//    // REMEMBER UserDefaults.standard is a Singleton. That is only one copy of this object, aka 'static'
//    let defaults = UserDefaults.standard
    
    //OPTION (2): Persist in FileManager
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //-----(2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //Test hardcode list items
//        let newItem1 = Item()
//        newItem1.title = "item 1"
//        itemArray.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "item 2"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "item 3"
//        itemArray.append(newItem3)
        
        //OPTION (1)
//        //RETRIEVE DATA FROM UserDefaults
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        //OPTION (2)
        // RETRIEVE DATA FROM FileManager
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print ("Error decoding item array, \(error)")
            }
        }
        //-----(2)
        
        
    }

    // MARK: - TableView Datasource Methods
    //RETURN NUMBER OF ROWS TO DISPLAY
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    //THIS IS CALLED AS MANY TIMES AS THERE ARE ROWS TO DISPLAY
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //add or remove checkmark if row is clicked
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        
        //OPTION (2)
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        //----(2)
        
        tableView.reloadData()
        
        //default behavior is row is 'selected' when clicked; change it by calling deselectRow()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    // this is "+" in the navigation bar
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            //OPTION (1)
//            //PERSIST DATA IN UserDefault
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //OPTION (2)
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            } catch {
                print("Error encoding item array, \(error)")
            }
            //-----(2)
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField //will use textField in UIAlertAction(...)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

}

