//
//  RealmItem.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/08.
//

import Foundation
import RealmSwift
class RealmItem: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted(primaryKey: true) var productId: String
    @Persisted var productId: String
    @Persisted var title: String
    @Persisted var link: String
    @Persisted var image: String
    @Persisted var lprice: String
    @Persisted var mallName: String
    
    convenience init(title: String, link: String, image: String, lprice: String, mallName: String, productId: String) {
        self.init()
        self.title = title
        self.link = link
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.productId = productId
    }
}
