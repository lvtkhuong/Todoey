//
//  Item.swift
//  Todoey
//
//  Created by Le Ngoc Lan Khue on 1/9/18.
//  Copyright © 2018 lvtkhuong. All rights reserved.
//

import Foundation
import RealmSwift
class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
