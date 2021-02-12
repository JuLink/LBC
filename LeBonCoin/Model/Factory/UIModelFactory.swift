//
//  UIModelFactory.swift
//  LeBonCoin
//
//  Created by Julien Lebeau on 11/02/2021.
//

import Foundation
import LBCDataProvider

/**
 The factory is in charge of transforming the data object from the repo to a useful object that the UI can manipulate more easily.
 */
protocol ModelFactory {
    func convertToUIModel(offers: [LBCDataProvider.Offer], categories: [LBCDataProvider.Category]) -> ([UIOffer], [UICategory])
}

struct UIModelFactory: ModelFactory {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let shared = UIModelFactory()
    
    func convertToUIModel(offers: [LBCDataProvider.Offer], categories: [LBCDataProvider.Category]) -> ([UIOffer], [UICategory]) {
        let uiCategories = categories.map { UICategory(id: $0.id, name: $0.name) }
        
        let uiOffers = offers.map { offer -> UIOffer in
            let date = UIModelFactory.dateFormatter.date(from: offer.creationDate) ?? Date()
            let displayDateString = UIModelFactory.displayDateFormatter.string(from: date)
            return UIOffer(id: offer.id,
                    category: uiCategories.first(where: { $0.id == offer.categoryID }),
                    title: offer.title,
                    description: offer.description,
                    price: offer.price,
                    priceString: UIModelFactory.priceFormatter.string(for: offer.price) ?? "",
                    creationDate: UIModelFactory.dateFormatter.date(from: offer.creationDate) ?? Date(),
                    creationDateString: displayDateString,
                    isUrgent: offer.isUrgent,
                    siret: offer.siret,
                    smallImages: URL(string: offer.images.small ?? ""),
                    thumbImages: URL(string: offer.images.thumb ?? ""))
        }
        
        return (uiOffers, uiCategories)
    }
}
