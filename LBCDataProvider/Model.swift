//
//  Model.swift
//  LBCNetwork
//
//  Created by Julien Lebeau on 09/02/2021.
//

import Foundation

public struct Category: Codable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct Offer: Codable {
    public let id: Int
    public let categoryID: Int
    public let title: String
    public let description: String
    public let price: Double
    public let creationDate: String
    public let isUrgent: Bool
    public let siret: String?
    public let images: ImageUrl
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case title
        case description
        case price
        case creationDate = "creation_date"
        case isUrgent = "is_urgent"
        case siret
        case images = "images_url"
    }
    
    public init(id: Int, categoryID: Int, title: String, description: String, price: Double, creationDate: String, isUrgent: Bool, siret: String?, images: ImageUrl) {
        self.id = id
        self.categoryID = categoryID
        self.title = title
        self.description = description
        self.price = price
        self.creationDate = creationDate
        self.isUrgent = isUrgent
        self.siret = siret
        self.images = images
    }
}

public struct ImageUrl: Codable {
    public let small: String?
    public let thumb: String?
    
    public init(small: String?, thumb: String?) {
        self.small = small
        self.thumb = thumb
    }
}



