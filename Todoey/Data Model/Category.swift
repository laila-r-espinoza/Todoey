//
//  Category.swift
//  Todoey
//
//  Created by Laila Espinoza on 1/2/19.
//  Copyright © 2019 Laila Espinoza. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>() //forward relationship
}
