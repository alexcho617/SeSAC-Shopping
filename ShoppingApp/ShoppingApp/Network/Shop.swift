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
    var items: [Item]
    
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
    
    init(title: String, link: String, image: String, lprice: String, mallName: String, productId: String) {
        self.title = title
        self.link = link
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.productId = productId
    }
    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, mallName, productId
    }
}
