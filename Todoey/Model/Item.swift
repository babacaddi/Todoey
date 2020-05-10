//
//  Item.swift
//  Todoey
//
//  Created by jauw on 5/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//IN ORDER TO INHERIT FROM Encodable or Decodable, THIS CLASS MUST ONLY CONTAIN STANDARD DATA TYPES
// Codable == Encodable, Decodable
class Item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
