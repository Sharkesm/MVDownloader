import XCTest
@testable import MVDownloader


class MVDownloaderTests: XCTestCase {
    
    
    let downloader = MVDownloader.shared

    let imageRequest1 = NSURL(string: "https://images.unsplash.com/photo-1464536564416-b73260a9532b?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=03326914ff00d129abd031d5033c15d5")!
    let imageRequest2 = NSURL(string: "https://images.unsplash.com/photo-1464536194743-0c49f0766ef6?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=f1126fb88744998f54efbae390fd7b67")!
    
    
    override func setUp() {
        super.setUp()
        downloader.clearAllCache()
    }
    
    override func tearDown() {
        super.tearDown()
        downloader.clearAllCache()
    }
    
    
    func testDefaultIntializer() {
        
        XCTAssertNotNil(downloader.session)
        XCTAssertNotNil(downloader.urlCache)
        XCTAssertNotNil(downloader.imageCacheManager)
        XCTAssertNotNil(downloader.downloadTaskService)
    }
    
    
    func testInitializerWithConfigurableCache() {
        
        let urlCache = URLCache(memoryCapacity: 40, diskCapacity: 0, diskPath: nil)
        let downloaderWithCache = MVDownloader(urlCache: urlCache)
        
        XCTAssertEqual(downloaderWithCache.urlCache, urlCache)
    }
    
    
    func testDeinitializer() {
        
        var downloader: MVDownloader? = MVDownloader(urlCache: URLCache(memoryCapacity: 30, diskCapacity: 0, diskPath: nil))
        
        downloader = nil
        
        XCTAssertNil(downloader, "Expected to be nil")
    }
    
    
    func testUrlCacheCapacity() {
        
        let maximumUrlCacheCapacity = 80 * 1024 * 1024
        
        let defaultURLCache = MVDownloader.shared.urlCache
        
        XCTAssertEqual(defaultURLCache.diskCapacity, 0)
        XCTAssertEqual(defaultURLCache.memoryCapacity, maximumUrlCacheCapacity)
    }
    
    
    func testDownloadTask() {
        
        let facebookRequest = URLRequest(url: URL(string: "https://facebook.com")!)
        let googleRequest = URLRequest(url: URL(string: "https://google.com")!)
        
        let expectation = self.expectation(description: "Google request should be successfull")
        var expectedData: Data?
        
        downloader.request(googleRequest) { (data, error) in
            expectedData = data
            expectation.fulfill()
        }

        XCTAssertTrue(downloader.downloadTaskService.hasDownloadTask(for: googleRequest))
        XCTAssertNotNil(downloader.downloadTaskService.getDownloadTask(withRequest: googleRequest))
        XCTAssertTrue(downloader.downloadTaskService.getDownloadTask(withRequest: googleRequest)!.isDownloading)
        
        waitForExpectations(timeout: 60, handler: nil)
        
        XCTAssertNotNil(expectedData, "Expecting response data not to be nil")
        XCTAssertFalse(downloader.downloadTaskService.hasDownloadTask(for: facebookRequest), "Request is not active and should return false")
        XCTAssertNil(downloader.downloadTaskService.getDownloadTask(withRequest: facebookRequest), "Request is not active and it should be nil")
        
    }
    
    
    func testClearCache() {
        
        let expectation1 = self.expectation(description: "First image request should be succesful")
        let expectation2 = self.expectation(description: "Second image request should be succesful")
        
        downloader.request(URLRequest(url: imageRequest1 as URL)) { (_, _) in
            expectation1.fulfill()
        }
        
        downloader.request(URLRequest(url: imageRequest2 as URL)) { (_, _) in
            expectation2.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
        
        XCTAssertNotNil(downloader.urlCache.cachedResponse(for: URLRequest(url: imageRequest1 as URL)), "Should not be nil as first request is expected to be cached")
        XCTAssertNotNil(downloader.urlCache.cachedResponse(for: URLRequest(url: imageRequest2 as URL)), "Should not be nil as second request is expected to be cached")
        
        downloader.clearCache(for: imageRequest1 as URL)
        XCTAssertNil(downloader.urlCache.cachedResponse(for: URLRequest(url: imageRequest1 as URL)), "Expected to be nil")
        
        XCTAssertNotNil(downloader.urlCache.cachedResponse(for: URLRequest(url: imageRequest2 as URL)), "Should not be nil as second request is expected to be cached")
        
        downloader.clearCache(for: imageRequest2 as URL)
        XCTAssertNil(downloader.urlCache.cachedResponse(for: URLRequest(url: imageRequest2 as URL)), "Expected to be nil")
        
    }
    
    
    func testClearAllCache() {
        
        let expectation1 = self.expectation(description: "First image request should be succesful")
        let expectation2 = self.expectation(description: "Second image request should be succesful")
        
        downloader.request(URLRequest(url: imageRequest1 as URL)) { (_, _) in
            expectation1.fulfill()
        }
        
        downloader.request(URLRequest(url: imageRequest2 as URL)) { (_, _) in
            expectation2.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
        
        XCTAssertNotNil(downloader.urlCache.cachedResponse(for: URLRequest(url: imageRequest1 as URL)), "Should not be nil as first request is expected to be cached")
        XCTAssertNotNil(downloader.urlCache.cachedResponse(for: URLRequest(url: imageRequest2 as URL)), "Should not be nil as second request is expected to be cached")
        
        downloader.clearAllCache()
        
        XCTAssertNil(downloader.urlCache.cachedResponse(for: URLRequest(url: imageRequest1 as URL)), "Expected to be nil")
        XCTAssertNil(downloader.urlCache.cachedResponse(for: URLRequest(url: imageRequest2 as URL)), "Expected to be nil")

    }
    
    
    func testCancelRequest() {
        
        let request = URLRequest(url: imageRequest1 as URL)
        let expectation = self.expectation(description: "First request should be successful")
        let handerID = ResponseHandler.getUniqueHandlerID()
        
        let responseHandler = ResponseHandler(handlerID: handerID) { (_, error) in
            XCTAssertNotNil(error, "Download request was cancelled")
            
            expectation.fulfill()
        }
        
        let downloadTask = MVDownloaderTask(request, handlerID: handerID, responseHandler: responseHandler)
        
        downloader.downloadTaskService.addDownloadTask(downloadTask)
        
        let requestDidCancel = downloader.cancelRequest(for: request.url!)
        
        waitForExpectations(timeout: 5.0, handler: nil)
        
        XCTAssertFalse(downloader.downloadTaskService.hasDownloadTask(for: request), "Download request is not active")
        XCTAssert(requestDidCancel, "Download request should been cancelled by now")
        
    }
  
    
    func testDownloadImageWithValidRequest() {
        
        let expectation = self.expectation(description: "Request should respond with an image of `MVImage` type")
        
        var expectedImage: MVImage?
        
        downloader.requestImage(from: imageRequest1 as URL) { (mvimage, error) in
            expectedImage = mvimage
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
        
        XCTAssertNotNil(expectedImage, "Expected image of `MVImage` kind should never be nil")
        
    }
    
    
    func testDownloadImageWithInvalidRequest() {
        
        let imageRequest = URL(string: "https://images.unsplash.com/1464536564416-b73260a9532b?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=03326914ff00d129abd031d5033c15d5")!
        
        let expectation = self.expectation(description: "Request should fail and return an error")
        
        var expectedError: Error?
        
        downloader.requestImage(from: imageRequest) { (mvimage, error) in
            expectedError = error
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
        
        XCTAssertNotNil(expectedError, "Error should not be nil")
    }
    
    
    func testDownloadImageAndCache() {
        
        let expectation1 = self.expectation(description: "Request is successfull and cached an image")
        
        downloader.requestImage(from: imageRequest1 as URL) { (mvimage, error) in
            expectation1.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
    
        if downloader.imageCacheManager.isImageCached(withIdentifier: imageRequest1) == .available {
            XCTAssertTrue(true)
        } else {
            XCTFail("Image should have been cached by now")
        }
    }
    
    
    func testDownloadImageAndRemoveCachedImages() {
        
        let expectation1 = self.expectation(description: "Request is successfull and cached an image")
        
        downloader.requestImage(from: imageRequest1 as URL) { (mvimage, error) in
            expectation1.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
        
        XCTAssertNotNil(downloader.imageCacheManager.filterImage(withIdentifier: imageRequest1), "Image expected to be cached and should never be nil")
        
        downloader.clearAllCache()
        
        XCTAssertNil(downloader.imageCacheManager.filterImage(withIdentifier: imageRequest1), "Expected to be nil since all cache have been cleared")
        
    }
    
    
    func testDistinctDownloadRequests() {
        
        let expectation1 = self.expectation(description: "Request is successful")
        let expectation2 = self.expectation(description: "Request is successful")
        
        downloader.request(URLRequest(url: imageRequest1 as URL)) { (_, _) in
            expectation1.fulfill()
        }
        
        downloader.request(URLRequest(url: imageRequest2 as URL)) { (_, _) in
            expectation2.fulfill()
        }
        
        XCTAssertEqual(downloader.downloadTaskService.downloadTaskCount(), 2)
        
        waitForExpectations(timeout: 30, handler: nil)
        
        XCTAssertEqual(downloader.downloadTaskService.downloadTaskCount(), 0)
    }
    
    
    func testIdenticalDownloadRequests() {
        
        let expectation1 = self.expectation(description: "Request is successful")
        let expectation2 = self.expectation(description: "Request is successful")
        
        downloader.request(URLRequest(url: imageRequest1 as URL)) { (_, _) in
            expectation1.fulfill()
        }
        
        downloader.request(URLRequest(url: imageRequest1 as URL)) { (_, _) in
            expectation2.fulfill()
        }
        
        let awaitingHandlerCount = downloader.downloadTaskService.getDownloadTask(withRequest: URLRequest(url: imageRequest1 as URL))!.responseHandlers.count
        
        XCTAssertEqual(downloader.downloadTaskService.downloadTaskCount(), 1, "Only a single request should be active")
        XCTAssertEqual(awaitingHandlerCount, 2, "Two closures are waiting for response")
        
        waitForExpectations(timeout: 30, handler: nil)
        
        XCTAssertEqual(downloader.downloadTaskService.downloadTaskCount(), 0)
    }
    
    
    func testDecodableRequest() {
        
        let jsonRequest = URL(string: "https://pastebin.com/raw/wgkJgazE")!
        let expectation = self.expectation(description: "JSON request should successfull and decoded to instance of type")
        var results: [PhotoModel]?
        
        downloader.requestDecodable(type: [PhotoModel].self, from: jsonRequest) { (data, _) in
            results = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
        
        XCTAssertNotNil(results, "Result should never be nil")

    }
    
    
    func testDecodableRequestWithInvalidModel() {
        
        struct InvalidJSON: Codable {
           var def: String
        }
        
        let request = URL(string: "https://pastebin.com/raw/wgkJgazE")!
        let expectation = self.expectation(description: "JSON request is successfull and decode instance of type")
        
        var failableResult: InvalidJSON?
        var error: Error?
        
        downloader.requestDecodable(type: InvalidJSON.self, from: request) { (data, err) in
            failableResult = data
            error = err
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
        
        XCTAssertNil(failableResult, "Result should be nil")
        XCTAssertNotNil(error, "Should always return an error")
    }
    
    
    func testDecodableRequestWithInvalidRequest() {
        
        let request = URL(string: "https://pastebin.com/raw/wgkJgazEER")!
        let expectation = self.expectation(description: "JSON request is successfull and decoded instance of type")
        
        var result: [PhotoModel]?
        var error: Error?
        
        downloader.requestDecodable(type: [PhotoModel].self, from: request) { (data, err) in
            result = data
            error = err
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
        
        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(error, "Should always return an error")
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
