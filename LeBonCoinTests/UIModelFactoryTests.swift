//
//  UIModelFactoryTests.swift
//  LeBonCoinTests
//
//  Created by Julien Lebeau on 11/02/2021.
//

import XCTest
@testable import LeBonCoin
import LBCDataProvider

class UIModelFactoryTests: XCTestCase {

    func testConversionWithAllData() throws {
        //Given
        let sut = UIModelFactory()
        let offer: LBCDataProvider.Offer = LBCDataProvider.Offer(id: 1,
                                                                 categoryID: 1,
                                                                 title: "Test",
                                                                 description: "TestDescription",
                                                                 price: 50,
                                                                 creationDate: "2021-02-11T11:05:33+0000",
                                                                 isUrgent: true,
                                                                 siret: nil,
                                                                 images: ImageUrl(small: nil, thumb: nil))
        let category: LBCDataProvider.Category = LBCDataProvider.Category(id: 1, name: "Mode")
        
        //When
        let (uiOffers, uiCategories) = sut.convertToUIModel(offers: [offer], categories: [category])
        
        //Then
        let onlyConvertedOffer = try XCTUnwrap(uiOffers.first)
        let onlyConvertedCategory = try XCTUnwrap(uiCategories.first)
        
        XCTAssertEqual(onlyConvertedOffer.id, 1)
        XCTAssertEqual(onlyConvertedOffer.category, onlyConvertedCategory)
        //XCTAssertEqual(onlyConvertedOffer.priceString, "€50.00") //TODO: Find a better way to test the currency formatter. Not sure it's the right way to test this since it depend on the region/language of the device
        XCTAssertNotEqual(onlyConvertedOffer.creationDate, Date())
    }
    
    func testConversionWithoutCategory() throws {
        //Given
        let sut = UIModelFactory()
        let offer: LBCDataProvider.Offer = LBCDataProvider.Offer(id: 1,
                                                                 categoryID: 1,
                                                                 title: "Test",
                                                                 description: "TestDescription",
                                                                 price: 50,
                                                                 creationDate: "2021-02-11T11:05:33+0000",
                                                                 isUrgent: true,
                                                                 siret: nil,
                                                                 images: ImageUrl(small: nil, thumb: nil))
        
        //When
        let (uiOffers, uiCategories) = sut.convertToUIModel(offers: [offer], categories: [])
        
        //Then
        let onlyConvertedOffer = try XCTUnwrap(uiOffers.first)
        
        XCTAssertEqual(uiCategories.count, 0)
        XCTAssertEqual(onlyConvertedOffer.id, 1)
        XCTAssertNil(onlyConvertedOffer.category)
    }
    
    func testConversionWithoutMatchingCategory() throws {
        //Given
        let sut = UIModelFactory()
        let offer: LBCDataProvider.Offer = LBCDataProvider.Offer(id: 1,
                                                                 categoryID: 1,
                                                                 title: "Test",
                                                                 description: "TestDescription",
                                                                 price: 50,
                                                                 creationDate: "2021-02-11T11:05:33+0000",
                                                                 isUrgent: true,
                                                                 siret: nil,
                                                                 images: ImageUrl(small: nil, thumb: nil))
        
        let category: LBCDataProvider.Category = LBCDataProvider.Category(id: 2, name: "Mode")
        
        //When
        let (uiOffers, uiCategories) = sut.convertToUIModel(offers: [offer], categories: [category])
        
        //Then
        let onlyConvertedOffer = try XCTUnwrap(uiOffers.first)
        let onlyConvertedCategory = try XCTUnwrap(uiCategories.first)
        
        XCTAssertEqual(onlyConvertedOffer.id, 1)
        XCTAssertNil(onlyConvertedOffer.category)
    }
    

}
