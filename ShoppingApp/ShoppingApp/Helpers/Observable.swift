//
//  Observable.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/24.
//

import Foundation

class Observable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let value = self?.value {
                    self?.listener?(value)
                }
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = { [weak self] newValue in
            guard self != nil else { return }
            closure(newValue)
        }
    }
}
