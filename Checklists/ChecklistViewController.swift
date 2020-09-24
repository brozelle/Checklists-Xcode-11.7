//
//  ViewController.swift
//  Checklists
//
//  Created by Buck Rozelle on 9/22/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    
    var items = [ChecklistItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
        
        //load items
        loadChecklistItems()
        
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
        
}
    
    //Fetch the file save path
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
        
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent(
            "Checklists.plist")
}
    
    // MARK:- Saving/Loading data to a file
    func saveChecklistItems() {
        
        let encoder = PropertyListEncoder()
        //This block of code catches Swift errors
        do {
        // Encode the arrays
            let data = try encoder.encode(items)
            // If the encoding was successful, write data to the file.
            try data.write(to: dataFilePath(),
                           options: Data.WritingOptions.atomic)
            // execute if error is thrown
        } catch {
            // print the error
            print("Error encoding item array: \(error.localizedDescription)")
            
        }
        
    }
    
    func loadChecklistItems() {

        let path = dataFilePath()
        // Attempt to load the contents of the plist file into a new data object.
        if let data = try? Data(contentsOf: path) {
            // load the entire array from the plist file.
            let decoder = PropertyListDecoder()
            do {
                // load the saved data back into items.
                items = try decoder.decode([ChecklistItem].self,
                                           from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
                
            }
            
        }
        
    }
    
    // MARK:- AddItemViewController Delegates
     func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex,
                                  section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths,
                             with: .automatic)
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    func itemDetailViewController(controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem",
                                                 for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
        
    }
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    // MARK:- Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }
    
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
    }
    
}

