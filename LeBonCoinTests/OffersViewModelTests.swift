//
//  OffersViewModelTests.swift
//  LeBonCoinTests
//
//  Created by Julien Lebeau on 11/02/2021.
//

import XCTest
@testable import LeBonCoin

struct StubRepository: DataRepository {
    var categories: [UICategory]
    
    var offers: [UIOffer]
    
    func load(completion: @escaping () -> Void) {
        completion()
    }
    
    
}

extension UIOffer {
    static let sutVoitureOffer = UIOffer(id: 1,
                                         category: .sutVoitureCategory,
                                         title: "Renault",
                                         description: "Clio",
                                         price: 1000,
                                         priceString: "€1000",
                                         creationDate: Date(),
                                         isUrgent: true,
                                         siret: nil,
                                         smallImages: nil,
                                         thumbImages: nil)
    
    static let sutModeOffer = UIOffer(id: 2,
                                      category: .sutModeCategory,
                                      title: "Tshirt Oxbow",
                                      description: "Tshirt manche courte",
                                      price: 10,
                                      priceString: "€10",
                                      creationDate: Date(),
                                      isUrgent: false,
                                      siret: nil,
                                      smallImages: nil,
                                      thumbImages: nil)
    
    static let sutNoCategory = UIOffer(id: 4,
                                       category: nil,
                                       title: "Fusée",
                                       description: "Modèle lunaire",
                                       price: 1000000000,
                                       priceString: "€1000000000",
                                       creationDate: Date(),
                                       isUrgent: true,
                                       siret: nil,
                                       smallImages: nil,
                                       thumbImages: nil)
    
    
    static let sutOffers: [UIOffer] = [
        .sutVoitureOffer,
        .sutNoCategory,
        .sutModeOffer
    ]
}

extension UICategory {
    static let sutModeCategory: UICategory = UICategory(id: 1, name: "Mode")
    static let sutVoitureCategory: UICategory = UICategory(id: 2, name: "Voiture")
    static let sutInformatiqueCategory: UICategory = UICategory(id: 3, name: "Informatique")
    
    static let sutCategories: [UICategory] = [
        .sutModeCategory,
        .sutVoitureCategory,
        .sutInformatiqueCategory
    ]
}

class OffersViewModelTests: XCTestCase {

    func testLoadOffers() throws {
        //Given
        let sut = OffersViewModel(repo: StubRepository(categories: UICategory.sutCategories, offers: UIOffer.sutOffers))
        XCTAssertTrue(sut.categories.isEmpty)
        XCTAssertTrue(sut.offers.isEmpty)
        XCTAssertEqual(sut.selectedFilter, OffersViewModel.OfferFilter.noFilter)
        
        //When
        let expectation = self.expectation(description: "Loading data in a sut should never fail")
        sut.loadOffers { (_) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        //Then
        XCTAssertTrue(sut.categories.isEmpty)
        XCTAssertFalse(sut.offers.isEmpty)
        XCTAssertEqual(sut.selectedFilter, OffersViewModel.OfferFilter.noFilter)
        XCTAssertEqual(sut.offers.count, UIOffer.sutOffers.count)
    }
    
    func testLoadCategories() throws {
        //Given
        let sut = OffersViewModel(repo: StubRepository(categories: UICategory.sutCategories, offers: UIOffer.sutOffers))
        XCTAssertTrue(sut.categories.isEmpty)
        XCTAssertTrue(sut.offers.isEmpty)
        XCTAssertEqual(sut.selectedFilter, OffersViewModel.OfferFilter.noFilter)
        
        //When
        let expectation = self.expectation(description: "Loading data in a sut should never fail")
        sut.loadCategories { (_) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        //Then
        XCTAssertFalse(sut.categories.isEmpty)
        XCTAssertTrue(sut.offers.isEmpty)
        XCTAssertEqual(sut.selectedFilter, OffersViewModel.OfferFilter.noFilter)
        XCTAssertEqual(sut.categories.count, UICategory.sutCategories.count)
    }
    
    func testLoadOfferWithFilterOfExistingCategory() throws {
        //Given
        let sut = OffersViewModel(repo: StubRepository(categories: UICategory.sutCategories, offers: UIOffer.sutOffers))
        let categoryToFilter = UICategory.sutModeCategory
        
        //When
        let expectation = self.expectation(description: "Loading data in a sut should never fail")
        sut.loadOffers(filter: .category(categoryToFilter.id)) { (_) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        //Then
        XCTAssertEqual(sut.offers.count, 1)
        XCTAssertEqual(sut.selectedFilter, OffersViewModel.OfferFilter.category(categoryToFilter.id))
        let offer = try XCTUnwrap(sut.offers.first)
        XCTAssertEqual(offer.category, categoryToFilter)
    }
    
    func testLoadOfferWithFilterOfNonExistingCategory() throws {
        //Given
        let sut = OffersViewModel(repo: StubRepository(categories: UICategory.sutCategories, offers: UIOffer.sutOffers))
        
        //When
        let expectation = self.expectation(description: "Loading data in a sut should never fail")
        sut.loadOffers(filter: .category(1000)) { (_) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        //Then
        XCTAssertEqual(sut.offers.count, 0)
        XCTAssertEqual(sut.selectedFilter, OffersViewModel.OfferFilter.category(1000))
    }
    
    func testRemovingExistingFilter() throws {
        //Given
        let sut = OffersViewModel(repo: StubRepository(categories: UICategory.sutCategories, offers: UIOffer.sutOffers))
        let expectation = self.expectation(description: "Loading data in a sut should never fail")
        sut.loadOffers(filter: .category(UICategory.sutModeCategory.id)) { (_) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        //When
        let expectationLoadDataAfterRemovingFilter = self.expectation(description: "Loading data in a sut should never fail")
        sut.loadOffers(filter: .noFilter) { (_) in
            expectationLoadDataAfterRemovingFilter.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        //Then
        XCTAssertTrue(sut.categories.isEmpty)
        XCTAssertFalse(sut.offers.isEmpty)
        XCTAssertEqual(sut.selectedFilter, OffersViewModel.OfferFilter.noFilter)
        XCTAssertEqual(sut.offers.count, UIOffer.sutOffers.count)
    }

}
