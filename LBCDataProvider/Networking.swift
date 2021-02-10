//
//  Networking.swift
//  LBCDataProvider
//
//  Created by Julien Lebeau on 09/02/2021.
//

import Foundation

public protocol RequestProvider {
    var urlRequest: URLRequest { get }
}

public protocol Networking {
    func fetch(endpoint: RequestProvider, completion: @escaping (Result<Data, Error>) -> Void)
}

public enum Endpoint: RequestProvider {
    case listing
    case categories
    
    public var urlRequest: URLRequest {
        let urlString: String
        switch self {
        case .listing:
            urlString = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
        case .categories:
            urlString = "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json"
        }
        
        guard let url = URL(string: urlString) else {
            preconditionFailure("Invalid URL")
        }
        
        return URLRequest(url: url)
    }
}

extension URLSession: Networking {
    
    enum NetworkingError: Error {
        case noData
    }
    
    public func fetch(endpoint: RequestProvider, completion: @escaping (Result<Data, Error>) -> Void) {
        Self.shared.dataTask(with: endpoint.urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkingError.noData))
            }
            
        }.resume()
    }
}
