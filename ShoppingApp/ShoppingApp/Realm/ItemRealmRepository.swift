//
//  ItemRealmRepository.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/08.
//

import Foundation
import RealmSwift

protocol RealmRepository: AnyObject{
    func fetch() -> Results<RealmItem>
    func create(_ item: RealmItem)
}

final class ItemRealmRepository: RealmRepository {
    
    private let realm = try! Realm()
    private init() {}
    static let shared = ItemRealmRepository()
    
    func fetch() -> Results<RealmItem> {
        return realm.objects(RealmItem.self).sorted(byKeyPath: "_id",ascending: false)
    }
    
    func fetchById(id: String) -> Results<RealmItem> {
        return realm.objects(RealmItem.self).where {
            return $0.productId == id
        }
    }
    
    func filteredFetch(with query: String) -> Results<RealmItem>{
        realm.objects(RealmItem.self).where {
            return $0.title.contains(query)
        }
    }
    
    func create(_ item: RealmItem) {
        do {
            try realm.write{
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    func delete(targetProductId: String) {
        let item = fetch().where{
            $0.productId == targetProductId
        }
        
        //혹시라도 여러 레코드가 DB에 있다면 모두 삭제
        for i in item{
            try! realm.write {
                realm.delete(i)
            }
        }
    }
    
    func checkProductExistsInRealmByProductId(_ target: String) -> Bool{
        let items = fetch()
        for item in items{
            if item.productId == target{
                return true
            }
        }
        return false
    }
    
    func realmURL(){
        print(realm.configuration.fileURL ?? "")
    }
}


