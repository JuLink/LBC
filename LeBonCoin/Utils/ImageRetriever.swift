//
//  ImageRetriever.swift
//  LeBonCoin
//
//  Created by Julien Lebeau on 12/02/2021.
//

import UIKit

protocol ImageDownloader {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: ImageDownloader {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.dataTask(with: url, completionHandler: completionHandler).resume()
    }
}

protocol ImageRetriever {
    func image(for url: URL?, completion: @escaping (UIImage?) -> ())
}

class ImageCacheDownloader: ImageRetriever {
    
    private let cache: NSCache<NSURL, UIImage> = NSCache()
    private let cacheAccessQueue = DispatchQueue(label: "com.leboncoin.imageDownloader.cache", attributes: .concurrent)
    private let imageDownloader: ImageDownloader
    
    init(imageDownloader: ImageDownloader = URLSession.shared) {
        self.imageDownloader = imageDownloader
    }
    
    func image(for url: URL?, completion: @escaping (UIImage?) -> ()) {
        guard let url = url else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        var cacheData: UIImage?
        cacheAccessQueue.sync {
            cacheData = cache.object(forKey: (url as NSURL))
        }
        if let imageInCache = cacheData {
            DispatchQueue.main.async {
                completion(imageInCache)
            }
        } else {
            imageDownloader.dataTask(with: url) {[url] (data, _, _) in
                if let receivedData = data, let image = UIImage(data: receivedData) {
                    self.cacheAccessQueue.async(flags: .barrier) {
                        self.cache.setObject(image, forKey: (url as NSURL))
                    }
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
    
}
