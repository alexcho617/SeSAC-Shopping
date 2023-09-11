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
}
