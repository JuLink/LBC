//
//  DataProvider.swift
//  LBCDataProvider
//
//  Created by Julien Lebeau on 09/02/2021.
//

import Foundation

public protocol DataProvider {
    func loadOffers(completion: @escaping (Result<[Offer], Error>) -> Void)
    func loadCategories(completion: @escaping (Result<[Category], Error>) -> Void)
}

public class API: DataProvider {
    let session: Networking
    let decoder: Decoder
    
    public init(session: Networking = URLSession.shared, decoder: Decoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    public func loadOffers(completion: @escaping (Result<[Offer], Error>) -> Void) {
        session.fetch(endpoint: Endpoint.listing) { [decoder] networkingResult in
            completion(decoder.decode(data: networkingResult))
        }
    }
    
    public func loadCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        session.fetch(endpoint: Endpoint.categories) { [decoder] networkingResult in
            completion(decoder.decode(data: networkingResult))
        }
    }
}

public protocol Decoder {
    func decode<T: Decodable>(data: Result<Data, Error>) -> Result<T, Error>
}

extension JSONDecoder: Decoder {
    public func decode<T: Decodable>(data: Result<Data, Error>) -> Result<T, Error> {
        switch data {
        case .success(let networkingData):

            do {
                let decodedData = try self.decode(T.self, from: networkingData)
                return .success(decodedData)
            } catch {
                return .failure(error)
            }
            
            
        case .failure(let error):
            return .failure(error)
        }
    }
}
