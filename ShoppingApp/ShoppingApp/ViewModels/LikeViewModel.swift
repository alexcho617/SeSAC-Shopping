//
//  LikeViewModel.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/24.
//

import Foundation
import RealmSwift


final class LikeViewModel {
    var likeTable: Observable<Results<RealmItem>>

    init() {
        let initialResults = ItemRealmRepository.shared.fetch()
        likeTable = Observable(initialResults)

    }
}
