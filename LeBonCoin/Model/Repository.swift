//
//  Repository.swift
//  LeBonCoin
//
//  Created by Julien Lebeau on 10/02/2021.
//

import Foundation
import LBCDataProvider

public protocol DataRepository {
    var categories: [UICategory] { get }
    var offers: [UIOffer] { get }
    
    func load(completion: @escaping () -> Void)
}

/**
 The role of the repository is to retrieve the data from a `DataProvider` (Service and/or the DB layer) and provide a consistent model for the UI using a `ModelFactory`. It manages a cache of the data so that ViewModels always have one source of truth.
 */
public class Repository: DataRepository {
    private let dataProvider: DataProvider
    private let factory: ModelFactory
    
    public var categories: [UICategory] = []
    public var offers: [UIOffer] = []
    
    private var apiOffers: [LBCDataProvider.Offer] = []
    private var apiCategories: [LBCDataProvider.Category] = []
    
    init(dataProvider: LBCDataProvider.DataProvider = API(), factory: ModelFactory = UIModelFactory.shared) {
        self.dataProvider = dataProvider
        self.factory = factory
    }
    
    public func load(completion: @escaping () -> Void) {
        
        guard self.offers.isEmpty || self.categories.isEmpty else {
            completion()
            return
        }
        
        let requestAPIGroup = DispatchGroup()
        
        requestAPIGroup.enter()
        self.dataProvider.loadCategories { [weak self] (categoriesResult) in
            switch categoriesResult {
            case .success(let categories):
                self?.apiCategories = categories
            case .failure(_):
                break
            }
            requestAPIGroup.leave()
        }
        
        requestAPIGroup.enter()
        self.dataProvider.loadOffers { [weak self] (resultOffers) in
            switch resultOffers {
            case .success(let offers):
                self?.apiOffers = offers
            case .failure(_):
                break
            }
            requestAPIGroup.leave()
        }
        
        requestAPIGroup.notify(queue: .main) {
            
            let (uiOffers, uiCategories) = self.factory.convertToUIModel(offers: self.apiOffers, categories: self.apiCategories)
            self.offers = uiOffers
            self.categories = uiCategories
            completion()
        }
    }
}
