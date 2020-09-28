 //
//  Checklist.swift
//  Checklists
//
//  Created by Buck Rozelle on 9/24/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }

}
