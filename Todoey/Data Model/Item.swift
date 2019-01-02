//
//  Item.swift
//  Todoey
//
//  Created by Laila Espinoza on 1/2/19.
//  Copyright © 2019 Laila Espinoza. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic  var done: Bool = false
    @objc dynamic  var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //inverse relationship
}
