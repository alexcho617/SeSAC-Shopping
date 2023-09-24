//
//  String+Extension.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/11.
//

import Foundation
extension String {
    func removingHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func currencyFormatted() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: Double(self)! as NSNumber) ?? "0"

    }
}
