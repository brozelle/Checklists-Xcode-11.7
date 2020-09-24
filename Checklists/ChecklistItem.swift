//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Buck Rozelle on 9/23/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked.toggle()
    }
}
