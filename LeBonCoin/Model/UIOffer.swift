//
//  UIOffer.swift
//  LeBonCoin
//
//  Created by Julien Lebeau on 11/02/2021.
//

import Foundation

public struct UIOffer: Equatable {
    public let id: Int
    public let category: UICategory?
    public let title: String
    public let description: String
    public let price: Double
    public let priceString: String
    public let creationDate: Date
    public let creationDateString: String
    public let isUrgent: Bool
    public let siret: String?
    public let smallImages: URL?
    public let thumbImages: URL?
    
    public init(id: Int, category: UICategory?, title: String, description: String, price: Double, priceString: String, creationDate: Date, creationDateString: String, isUrgent: Bool, siret: String?, smallImages: URL?, thumbImages: URL?) {
        self.id = id
        self.category = category
        self.title = title
        self.description = description
        self.price = price
        self.priceString = priceString
        self.creationDate = creationDate
        self.creationDateString = creationDateString
        self.isUrgent = isUrgent
        self.siret = siret
        self.smallImages = smallImages
        self.thumbImages = thumbImages
    }
}

extension UIOffer: Comparable {
    public static func < (lhs: UIOffer, rhs: UIOffer) -> Bool {
        if lhs.isUrgent != rhs.isUrgent {
            return lhs.isUrgent
        }
        
        return lhs.creationDate < rhs.creationDate
    }
}
