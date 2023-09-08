//
//  Shop.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/08.
//

import Foundation
// MARK: - Shop
class Shop: Codable {
    let lastBuildDate: String?
    let total, start, display: Int
    let items: [Item]
    
    enum CodingKeys: String, CodingKey{
        case lastBuildDate,total,start,display,items
    }
}

// MARK: - Item
class Item: Codable {
    var title: String
    var link: String
    var image: String
    var lprice: String
    var mallName: String
    var productId: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, mallName, productId
    }
}
