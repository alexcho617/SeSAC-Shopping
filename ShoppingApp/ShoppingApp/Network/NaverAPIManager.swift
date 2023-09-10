//
//  NaverAPIManager.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/08.
//

import Foundation
import Alamofire



class NaverAPIManager{
    static let shared = NaverAPIManager()
    let baseUrl = "https://openapi.naver.com/v1/search/shop.json"
    let linkUrl = "https://msearch.shopping.naver.com/product/"
    private init(){}

    func fetch(query: String, sortby: SortEnum, completionHandler: @escaping (Shop) -> ()) {
        
        let headers: HTTPHeaders = [
            Headers.ClientID.rawValue: APIKey.NaverClientID.rawValue,
            Headers.ClientSecret.rawValue: APIKey.NaverClientSecret.rawValue,
        ]
        
        let parameters: Parameters = [
            "query": query,
            "display": "30",
            "start": "1",
            "sort": sortby.rawValue
        ]
        
        AF.request(baseUrl, method: .get, parameters: parameters, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Shop.self) { response in
//                print("DEBUG:",response.request?.url?.description)
                switch response.result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}

enum SortEnum: String{
    case similarity = "sim"
    case date
    case ascendingPrice = "asc"
    case descendingPrice = "dsc"
}
