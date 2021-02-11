//
//  OffersViewModel.swift
//  LeBonCoin
//
//  Created by Julien Lebeau on 11/02/2021.
//

import Foundation

/**
 This view model hold the current state of the application.
 */
class OffersViewModel {
    public private(set) var offers: [UIOffer] = []
    public private(set) var categories: [UICategory] = []
    public private(set) var selectedFilter: OfferFilter = .noFilter
    
    public enum OfferFilter: Equatable {
        case noFilter
        case category(Int)
    }
    
    
    private let repo: DataRepository
    
    init(repo: DataRepository = Repository()) {
        self.repo = repo
    }
    
    func loadOffers(filter: OfferFilter = .noFilter, completion: @escaping ([UIOffer]) -> Void) {
        self.selectedFilter = filter
        self.repo.load {
            switch filter {
            case .noFilter:
                self.offers = self.repo.offers.sorted()
                completion(self.offers)
            case .category(let id):
                self.offers = self.repo.offers.filter{ $0.category?.id == id }.sorted()
                completion(self.offers)
            }
        }
    }
    
    func loadCategories(completion: @escaping ([UICategory]) -> Void) {
        self.repo.load {
            self.categories = self.repo.categories
            completion(self.categories)
        }
    }
}
