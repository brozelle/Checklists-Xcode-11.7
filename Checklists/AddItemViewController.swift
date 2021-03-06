//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Buck Rozelle on 9/23/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(controller: ItemDetailViewControllerler)
    
    func addItemViewController(controller: ItemDetailViewControllerler,
                               didFinishAdding item: ChecklistItem)
    func addItemViewController(controller: ItemDetailViewControllerler,
                               didFinishEditing item: ChecklistItem)
}


class ItemDetailViewControllerler: UITableViewController, UITextFieldDelegate {

    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
      weak var delegate: AddItemViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK:- Actions
    
    @IBAction func cancel() {
        //Had to add controller per error message.
        delegate?.addItemViewControllerDidCancel(controller: self)
        
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            //Had to add controller per error message.
            delegate?.addItemViewController(controller: self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            //Had to add controller per error message.
            delegate?.addItemViewController(controller: self, didFinishAdding: item)
        
            print("Contents of the text field: \(textField.text!)")
        }
    }
    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    // MARK:- Text Field Delegates
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        
        /*if newText.isEmpty {
            doneBarButton.isEnabled = false
            } else {
                doneBarButton.isEnabled = true
            }*/
            return true
        }
    }

