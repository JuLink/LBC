//
//  LBCDataProviderDecoderTests.swift
//  LBCDataProviderDecoderTests
//
//  Created by Julien Lebeau on 10/02/2021.
//

import XCTest
@testable import LBCDataProvider

class NetworkStub: LBCDataProvider.Networking {
    
    enum StubError: Error {
        case stubNotFound
    }
    
    func fetch(endpoint: RequestProvider, completion: @escaping (Result<Data, Error>) -> Void) {
        let fileName: String
        switch endpoint.urlRequest {
        case Endpoint.listing.urlRequest:
            fileName = "Offers"
        case Endpoint.categories.urlRequest:
            fileName = "Category"
        default:
            fileName = ""
        }
        
        if let path = Bundle(for: LBCDataProviderDecoderTests.self).path(forResource: fileName, ofType: "json"),
           let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            completion(.success(jsonData))
        } else {
            completion(.failure(StubError.stubNotFound))
        }
    }
}

class LBCDataProviderDecoderTests: XCTestCase {

    func testEndpoint() throws {
        XCTAssertEqual(Endpoint.listing.urlRequest.url?.absoluteString, "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json")
        XCTAssertEqual(Endpoint.categories.urlRequest.url?.absoluteString, "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json")
    }
    
    func testDecoderCategories() throws {
        //Given
        let networkStub = NetworkStub()
        
        let expectation = self.expectation(description: "Fake network should return data")
        var networkfakeResult: Result<Data, Error>?
        networkStub.fetch(endpoint: Endpoint.categories) { (result) in
            networkfakeResult = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        let networkResult = try XCTUnwrap(networkfakeResult)
        
        //When
        let decodedDataResult: Result<[LBCDataProvider.Category], Error> = JSONDecoder().decode(data: networkResult)
        
        
        //Then
        switch decodedDataResult {
        case .success(let categories):
            XCTAssertNotEqual(categories.count, 0)
            XCTAssertEqual(categories.first?.name, "Véhicule")
            XCTAssertEqual(categories.first?.id, 1)
            
            
        case .failure(_):
            XCTFail("Decoding Categories should not fail")
        }
    }
    
    func testDecoderOffers() throws {
        //Given
        let networkStub = NetworkStub()
        
        let expectation = self.expectation(description: "Fake network should return data")
        var networkfakeResult: Result<Data, Error>?
        networkStub.fetch(endpoint: Endpoint.listing) { (result) in
            networkfakeResult = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        let networkResult = try XCTUnwrap(networkfakeResult)
        
        //When
        let decodedDataResult: Result<[LBCDataProvider.Offer], Error> = JSONDecoder().decode(data: networkResult)
        
        
        //Then
        switch decodedDataResult {
        case .success(let offers):
            XCTAssertNotEqual(offers.count, 0)
            XCTAssertEqual(offers.first?.title, "Statue homme noir assis en plâtre polychrome")
            XCTAssertEqual(offers.first?.id, 1461267313)
            
            
        case .failure(let error):
            XCTFail("Decoding Offers should not fail \(error)")
        }
    }
    
    func testAPI() throws {
        //Given
        let sut = API(session: NetworkStub())
        
        let expectation = self.expectation(description: "Stub data should have been decoded and returned")
        var offersResult: Result<[LBCDataProvider.Offer], Error>?
        
        //When
        sut.loadOffers { (result) in
            offersResult = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let decodedDataResult = try XCTUnwrap(offersResult)
        
        //Then
        switch decodedDataResult {
        case .success(let offers):
            XCTAssertNotEqual(offers.count, 0)
            XCTAssertEqual(offers.first?.title, "Statue homme noir assis en plâtre polychrome")
            XCTAssertEqual(offers.first?.id, 1461267313)
            
            
        case .failure(let error):
            XCTFail("Decoding Offers should not fail \(error)")
        }
    }

}
