//
//  NaverError.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/23.
//

import Foundation

enum NaverError: String, Error, LocalizedError, Decodable{
    case SE01
    case SE02
    case SE03
    case SE04
    case SE06
    case SE05
    case SE99
    
    init(from decoder: Decoder) throws {
           let container = try decoder.singleValueContainer()
           let rawValue = try container.decode(String.self)
        self = NaverError(rawValue: rawValue) ?? .SE01
       }
    
    var errorDescription: String{
        switch self {
        case .SE01:
            return "Incorrect query request (잘못된 쿼리요청입니다.)"
        case .SE02:
            return "Invalid display value (부적절한 display 값입니다.)"
        case .SE03:
            return "Invalid start value (부적절한 start 값입니다.)"
        case .SE04:
            return "Invalid sort value (부적절한 sort 값입니다.)"
        case .SE05:
            return "Invalid search api (존재하지 않는 검색 api 입니다.)"
        case .SE06:
            return "Malformed encoding (잘못된 형식의 인코딩입니다.)"
        case .SE99:
            return "System Error (시스템 에러)"
        }
    }
}
