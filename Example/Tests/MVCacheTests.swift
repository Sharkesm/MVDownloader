//
//  MVCacheTests.swift
//  MVDownloader_Tests
//
//  Created by Sharkes Monken on 01/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import MVDownloader


class MVCacheTests: XCTestCase {

    let imageCache = MVImageCache()
    
    override func setUp() {
        super.setUp()
        imageCache.clearCache()
    }

    override func tearDown() {
        super.tearDown()
        imageCache.clearCache()
    }

    func testDefaultIntialization() {
    
        XCTAssertNotNil(imageCache.cache, "Should not be nil")
        XCTAssertEqual(imageCache.cache.name, "MVImageCacheQueue")
        XCTAssertNotNil(imageCache.cacheQueue, "Should not be nil")
        
        XCTAssertEqual(imageCache.cache.countLimit, MVImageCache.DefaultImageCacheLimit)
        XCTAssertEqual(imageCache.cache.totalCostLimit, MVImageCache.DefaultCacheCostLimitInBytes)
    }

    
    func testAvailableImageOnCache() {
        
        let mvimage = MVImage(named: "placeholder")!
        let testURL = NSURL(string: "www.reddit.com")!
        
        imageCache.add(mvimage, withIdentifier: testURL)
        
        XCTAssertTrue(imageCache.isImageCached(withIdentifier: testURL) == .available, "Should not fail since image was cached")
    }
    
    
    func testUnavailableImageOnCache() {
        
        let testURL = NSURL(string: "www.youtube.com")!
        
        XCTAssertFalse(imageCache.isImageCached(withIdentifier: testURL) == .available, "Should not fail since image was never cached")
    }
    
    
    func testFilterCachedImageWithSuccess() {
        
        let mvimage = MVImage(named: "placeholder")!
        let testURL = NSURL(string: "www.github.com")!
        
        imageCache.add(mvimage, withIdentifier: testURL)
        
        XCTAssertNotNil(imageCache.filterImage(withIdentifier: testURL), "Should not be nil since we are expecting a match")
    }
    
    
    func testFilterCachedImageWithFailure() {
        
        let mvimage2 = MVImage(named: "placeholder")!
        
        let testURL2 = NSURL(string: "www.facebook.com")!
        let testURL1 = NSURL(string: "www.google.com")!
        
        imageCache.add(mvimage2, withIdentifier: testURL2)
        
        XCTAssertNil(imageCache.filterImage(withIdentifier: testURL1), "Should be nil since no match was found")
    }
    
    
    func testRemoveCachedImageWithSuccess() {
        
        let mvimage = MVImage(named: "placeholder")!
        let testURL = NSURL(string: "www.malcomx.com")!
        
        imageCache.add(mvimage, withIdentifier: testURL)
        
        XCTAssertTrue(imageCache.isImageCached(withIdentifier: testURL) == .available, "Should not fail since image was cached")
        
        XCTAssertTrue(imageCache.removeImage(withIdentifier: testURL), "Cached image should have been removed by then")
        
        XCTAssertNil(imageCache.filterImage(withIdentifier: testURL), "Should be nil since no match was found")
    }
    
    
    func testRemoveCachedImageWithFailure() {
    
        let mvimage = MVImage(named: "placeholder")!
        let testURL1 = NSURL(string: "www.spiderman.com")!
        let testURL2 = NSURL(string: "www.wechat.com")!
        
        imageCache.clearCache()
        
        imageCache.add(mvimage, withIdentifier: testURL1)
        
        XCTAssertTrue(imageCache.isImageCached(withIdentifier: testURL1) == .available, "Should not fail since image was cached")
        
        XCTAssertNil(imageCache.filterImage(withIdentifier: testURL2), "Should be nil since no match was found")
       
        XCTAssertFalse(imageCache.removeImage(withIdentifier: testURL2), "Should be false since no cached image was found to be deleted")
    }
    
    
    func testClearCache() {
        
        let mvimage1 = MVImage(named: "placeholder")!
        let mvimage2 = MVImage(named: "placeholder")!
        let mvimage3 = MVImage(named: "placeholder")!
        
        let testURL1 = NSURL(string: "www.ibm.com")!
        let testURL2 = NSURL(string: "www.samsung.com")!
        let testURL3 = NSURL(string: "www.accer.com")!
        
        imageCache.add(mvimage1, withIdentifier: testURL1)
        imageCache.add(mvimage2, withIdentifier: testURL2)
        imageCache.add(mvimage3, withIdentifier: testURL3)
        
        XCTAssertTrue(imageCache.isImageCached(withIdentifier: testURL1) == .available, "Should not fail since image was cached")
        XCTAssertTrue(imageCache.isImageCached(withIdentifier: testURL2) == .available, "Should not fail since image was cached")
        XCTAssertTrue(imageCache.isImageCached(withIdentifier: testURL3) == .available, "Should not fail since image was cached")
        
        XCTAssert(imageCache.clearCache())
        
        XCTAssertNil(imageCache.filterImage(withIdentifier: testURL1), "Should be nil since no match was found")
        XCTAssertNil(imageCache.filterImage(withIdentifier: testURL2), "Should be nil since no match was found")
        XCTAssertNil(imageCache.filterImage(withIdentifier: testURL3), "Should be nil since no match was found")
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
