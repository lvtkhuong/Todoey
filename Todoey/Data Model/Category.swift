//
//  Category.swift
//  Todoey
//
//  Created by Le Ngoc Lan Khue on 1/9/18.
//  Copyright © 2018 lvtkhuong. All rights reserved.
//

import Foundation
import RealmSwift
class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
