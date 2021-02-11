//
//  UICategory.swift
//  LeBonCoin
//
//  Created by Julien Lebeau on 11/02/2021.
//

import Foundation

public struct UICategory {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension UICategory: Equatable {}
