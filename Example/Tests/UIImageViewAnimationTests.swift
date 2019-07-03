//
//  UIImageViewAnimationTests.swift
//  MVDownloader_Tests
//
//  Created by Manase Michael on 01/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import MVDownloader


/// MockUIImageViewSetImage
///
/// Mocks features to download images asynchronously and invoke a completion handler upon completion
///
/// - Note: MVDownloader has extended `UIImageView` with `mv_setImage(from:_)` method
///         with a purpose of downloading images asynchronously and set them by under the hood upon completion.
///
///         Otherwise a default place holder will be used instead but on this mock method we aren't
///         setting any default image.

class MockUIImageViewSetImage {
    
    static func mock_setImage(from url: URL, completion: @escaping (MVImage?, MVDownloaderError?) -> Void) {
        
        MVDownloader.shared.requestImage(from: url) { (image, error) in
            completion(image, error)
        }
    }
}



class UIImageViewAnimationTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    
    func testSuccessfulRequestAndSetImage() {
        
        let validImageRequest = URL(string: "https://images.unsplash.com/photo-1464536564416-b73260a9532b?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=03326914ff00d129abd031d5033c15d5")!
        
        let imageView = UIImageView()
        var downloadedImage: UIImage?
        
        let expectation = self.expectation(description: "Image is successfully downloaded and set on UIImageView")
        
        MockUIImageViewSetImage.mock_setImage(from: validImageRequest) { (image, error) in
            DispatchQueue.main.async {
                imageView.image = image // Set downloaded image manually, on the library it's by default
                downloadedImage = image
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
        
        XCTAssertNotNil(downloadedImage, "Should not be nil")
        XCTAssertTrue(downloadedImage! == imageView.image!)
    }

    
    func testFailableRequestAndSetImage() {
        
        let fakeRequest = URL(string: "https://4op=entropy&s=03326914ff00d129abd031d5033c15d5")!
        
        var errorOccured: Error?
        
        let expectation = self.expectation(description: "Image request should fail and fire an error")
        
        MockUIImageViewSetImage.mock_setImage(from: fakeRequest) { (_, error) in
            errorOccured = error
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    
        XCTAssertNotNil(errorOccured, "Should not be nil since request was invalid")
        
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
