//
//  DataModel.swift
//  Checklists
//
//  Created by Buck Rozelle on 9/25/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
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
       func saveChecklists() {
           let encoder = PropertyListEncoder()
           //This block of code catches Swift errors
           do {
           // Encode the arrays
            let data = try encoder.encode(lists)
               // If the encoding was successful, write data to the file.
               try data.write(to: dataFilePath(),
                              options: Data.WritingOptions.atomic)
               // execute if error is thrown
           } catch {
               // print the error
               print("Error encoding item array: \(error.localizedDescription)")
               
           }
           
       }
       
       func loadChecklists() {

           let path = dataFilePath()
           // Attempt to load the contents of the plist file into a new data object.
           if let data = try? Data(contentsOf: path) {
               // load the entire array from the plist file.
               let decoder = PropertyListDecoder()
               do {
                   // load the saved data back into items.
                   lists = try decoder.decode([Checklist].self,
                                              from: data)
               } catch {
                   print("Error decoding item array: \(error.localizedDescription)")
                   
               }
           }
       }
}
