//
//  ImageCacheDownloaderTests.swift
//  LeBonCoinTests
//
//  Created by Julien Lebeau on 12/02/2021.
//

import XCTest
@testable import LeBonCoin

class DownloadRequestCounter: ImageDownloader {
    var counter = 0
    let fakeData: Data
    
    init(fakeDataToReturn: Data) {
        fakeData = fakeDataToReturn
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        counter += 1
        completionHandler(fakeData, nil, nil)
    }
}

class ImageCacheDownloaderTests: XCTestCase {

    func testDownload() throws {
        //Given
        let testImage = UIImage(named: "apple-swift-logo-1", in: Bundle(for: ImageCacheDownloaderTests.self), compatibleWith: nil)!
        let dataToPutInCache = testImage.pngData()!
        let downloadCounter = DownloadRequestCounter(fakeDataToReturn: dataToPutInCache)
        let fakeURL = URL(string: "www.fakeurl.fr")!
        let sut = ImageCacheDownloader(imageDownloader: downloadCounter)
        
        //When
        let expectation = self.expectation(description: "Image should be loaded")
        var imageDownloaded: UIImage?
        sut.image(for: fakeURL) { (downloadedImage) in
            imageDownloaded = downloadedImage
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        //Then
        let unwrappedImageData = try XCTUnwrap(imageDownloaded?.pngData())
        XCTAssertEqual(unwrappedImageData, dataToPutInCache)
    }

    func testCache() throws {
        //Given
        let testImage = UIImage(named: "apple-swift-logo-1", in: Bundle(for: ImageCacheDownloaderTests.self), compatibleWith: nil)!
        let dataToPutInCache = testImage.pngData()!
        let downloadCounter = DownloadRequestCounter(fakeDataToReturn: dataToPutInCache)
        let fakeURL = URL(string: "www.fakeurl.fr")!
        let sut = ImageCacheDownloader(imageDownloader: downloadCounter)
        
        let expectation = self.expectation(description: "Image should be loaded one time")
        sut.image(for: fakeURL) { (downloadedImage) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        //When
        let expectationCache = self.expectation(description: "Image should be loaded from cache")
        var imageDownloaded: UIImage?
        sut.image(for: fakeURL) { (downloadedImage) in
            imageDownloaded = downloadedImage
            expectationCache.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        //Then
        let unwrappedImageData = try XCTUnwrap(imageDownloaded?.pngData())
        XCTAssertEqual(unwrappedImageData, dataToPutInCache)
        XCTAssertEqual(downloadCounter.counter, 1, "Call to network should occur only once for the 2 image requests.")
        
    }
    
}
