//
//  UIOfferTests.swift
//  LeBonCoinTests
//
//  Created by Julien Lebeau on 11/02/2021.
//

import XCTest
@testable import LeBonCoin

class UIOfferTests: XCTestCase {

    func testCompareOffersBetweenUrgencyWithSameDate() throws {
        //Given
        let date = Date()
        let offer1 = UIOffer(id: 1, category: nil, title: "", description: "", price: 50, priceString: "", creationDate: date, isUrgent: true, siret: nil, smallImages: nil, thumbImages: nil)
        let offer2 = UIOffer(id: 1, category: nil, title: "", description: "", price: 50, priceString: "", creationDate: date, isUrgent: false, siret: nil, smallImages: nil, thumbImages: nil)
        
        let offers = [offer1, offer2]
        
        //When
        let sortedOffers = offers.sorted()
        
        //Then
        XCTAssertEqual(offer1, sortedOffers.first, "First element of the sorted array should be the urgent offer")
        XCTAssertNotEqual(offer2, sortedOffers.first, "First element of the sorted array should be the urgent offer not the non-urgent one")
        XCTAssertNotEqual(offer1, sortedOffers.last)
        XCTAssertEqual(offer2, sortedOffers.last)
        
    }
    
    func testCompareOffersBetweenDateWithSameUrgency() throws {
        //Given
        let date = Date()
        let offer1 = UIOffer(id: 1, category: nil, title: "", description: "", price: 50, priceString: "", creationDate: date, isUrgent: true, siret: nil, smallImages: nil, thumbImages: nil)
        let offer2 = UIOffer(id: 1, category: nil, title: "", description: "", price: 50, priceString: "", creationDate: date.addingTimeInterval(500), isUrgent: true, siret: nil, smallImages: nil, thumbImages: nil)
        
        let offers = [offer1, offer2]
        
        //When
        let sortedOffers = offers.sorted()
        
        //Then
        XCTAssertEqual(offer1, sortedOffers.first, "First element of the sorted array should be the oldest offer")
        XCTAssertNotEqual(offer2, sortedOffers.first,  "First element of the sorted array should be the oldest offer")
        XCTAssertNotEqual(offer1, sortedOffers.last)
        XCTAssertEqual(offer2, sortedOffers.last)
        
    }
    
    func testCompareOffersWithoutSameUrgencyAndDate() throws {
        //Given
        let date = Date()
        let offer1 = UIOffer(id: 1, category: nil, title: "", description: "", price: 50, priceString: "", creationDate: date, isUrgent: false, siret: nil, smallImages: nil, thumbImages: nil)
        let offer2 = UIOffer(id: 1, category: nil, title: "", description: "", price: 50, priceString: "", creationDate: date.addingTimeInterval(-500), isUrgent: true, siret: nil, smallImages: nil, thumbImages: nil)
        
        let offers = [offer1, offer2]
        
        //When
        let sortedOffers = offers.sorted()
        
        //Then
        XCTAssertEqual(offer2, sortedOffers.first,  "First element of the sorted array should be the urgent offer, even if the date is more recent")
        XCTAssertNotEqual(offer1, sortedOffers.first, "First element of the sorted array should be the urgent offer, even if the date is more recent")
        XCTAssertNotEqual(offer2, sortedOffers.last)
        XCTAssertEqual(offer1, sortedOffers.last)
        
    }

}
