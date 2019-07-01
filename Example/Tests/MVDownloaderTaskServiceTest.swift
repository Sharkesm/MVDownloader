//
//  MVDownloaderTaskService.swift
//  MVDownloader_Tests
//
//  Created by Sharkes Monken on 01/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import MVDownloader


class MVDownloaderTaskServiceTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testDefaultInitializer() {
        
        let downloadTaskService = MVDownloaderTaskService()
        
        XCTAssertEqual(downloadTaskService.downloadTaskCount(), 0)
    }

    func testDeinitializer() {
        
        var downloadTaskService: MVDownloaderTaskService? = MVDownloaderTaskService()
        
        XCTAssertEqual(downloadTaskService!.downloadTaskCount(), 0)
        
        downloadTaskService = nil
        
        XCTAssertNil(downloadTaskService, "Should be nil")
        
    }
    
    
    func testActiveDownloadTask() {
    
        let request = URLRequest(url: URL(string: "www.google.com")!)
        let handlerID = ResponseHandler.getUniqueHandlerID()
        let responseHandler = ResponseHandler(handlerID: handlerID, completion: nil)
    
        let downloadTaskService = MVDownloaderTaskService()
        
        let downloadTask1 = MVDownloaderTask(request, handlerID: handlerID, responseHandler: responseHandler)
        
        XCTAssertEqual(downloadTaskService.downloadTaskCount(), 0)
        
        downloadTaskService.addDownloadTask(downloadTask1)
        
        XCTAssertEqual(downloadTaskService.downloadTaskCount(), 1)
    }
    
    
    func testDownloadTaskIsRegisteredAndActive() {
    
        let request = URLRequest(url: URL(string: "www.google.com")!)
        let handlerID = ResponseHandler.getUniqueHandlerID()
        let responseHandler = ResponseHandler(handlerID: handlerID, completion: nil)
        
        let downloadTaskService = MVDownloaderTaskService()
        
        let downloadTask1 = MVDownloaderTask(request, handlerID: handlerID, responseHandler: responseHandler)
        
        downloadTaskService.addDownloadTask(downloadTask1)
    
        XCTAssert(downloadTaskService.hasDownloadTask(for: request), "Should be true since it's listed an active request")
    }
    
    
    func testGetDownloadTask() {
    
        let request = URLRequest(url: URL(string: "www.google.com")!)
        let handlerID = ResponseHandler.getUniqueHandlerID()
        let responseHandler = ResponseHandler(handlerID: handlerID, completion: nil)
        
        let downloadTaskService = MVDownloaderTaskService()
        
        let downloadTask1 = MVDownloaderTask(request, handlerID: handlerID, responseHandler: responseHandler)
        
        downloadTaskService.addDownloadTask(downloadTask1)
        
        let requestedDownloadTask = downloadTaskService.getDownloadTask(withRequest: request)
        
        XCTAssertNotNil(requestedDownloadTask, "Should not be nil since it's listed as an active request")
    }
    
    
    func testCancelActiveDownloadTask() {
    
        let request = URLRequest(url: URL(string: "www.google.com")!)
        let handlerID = ResponseHandler.getUniqueHandlerID()
        
        // Awaiting response handler with a closure that returns an error
        let responseHandler = ResponseHandler(handlerID: handlerID) { (_, err) in }
        
        let downloadTaskService = MVDownloaderTaskService()
        
        let downloadTask1 = MVDownloaderTask(request, handlerID: handlerID, responseHandler: responseHandler)
        
        downloadTaskService.addDownloadTask(downloadTask1)
        
        XCTAssert(downloadTaskService.hasDownloadTask(for: request), "Should be true since it's listed an active request")
        
        // Cancel download task with given request
        downloadTaskService.cancelDownloadTask(withRequest: request)
        
        XCTAssertFalse(downloadTaskService.hasDownloadTask(for: request), "Should be false since request is inactive")
        
    }
    
    
    func testRemoveDownloadTask() {
        
        let request = URLRequest(url: URL(string: "www.google.com")!)
        let handlerID = ResponseHandler.getUniqueHandlerID()
        
        // Awaiting response handler with a closure that returns an error
        let responseHandler = ResponseHandler(handlerID: handlerID) { (_, err) in }
        
        let downloadTaskService = MVDownloaderTaskService()
        
        let downloadTask1 = MVDownloaderTask(request, handlerID: handlerID, responseHandler: responseHandler)
        
        downloadTaskService.addDownloadTask(downloadTask1)
        
        
        XCTAssert(downloadTaskService.hasDownloadTask(for: request), "Should be true since it's listed an active request")
     
        // Remove active download task
        let removeDownloadTask = downloadTaskService.removeDownloadTask(downloadTask1)
        
        XCTAssertNotNil(removeDownloadTask, "Should not be nil since it's the request that has been inactive and removed")
        XCTAssertFalse(downloadTaskService.hasDownloadTask(for: request), "Should be false since no active request match was found")
        
    }
    
    
    
    func testRemovalAllDownloadTask() {
        
        let request1 = URLRequest(url: URL(string: "www.google.com")!)
        let handlerID1 = ResponseHandler.getUniqueHandlerID()
        
        // Awaiting response handler with a closure that returns an error
        let responseHandler1 = ResponseHandler(handlerID: handlerID1) { (_, err) in }
        
        let downloadTask1 = MVDownloaderTask(request1, handlerID: handlerID1, responseHandler: responseHandler1)

        
        let request2 = URLRequest(url: URL(string: "www.facebook.com")!)
        let handlerID2 = ResponseHandler.getUniqueHandlerID()
        
        // Awaiting response handler with a closure that returns an error
        let responseHandler2 = ResponseHandler(handlerID: handlerID2) { (_, err) in }
        
        let downloadTask2 = MVDownloaderTask(request2, handlerID: handlerID2, responseHandler: responseHandler2)
        
        
        let downloadTaskService = MVDownloaderTaskService()
        
        downloadTaskService.addDownloadTask(downloadTask1)
        downloadTaskService.addDownloadTask(downloadTask2)
        
        XCTAssert(downloadTaskService.hasDownloadTask(for: request1), "Should be true since it's listed an active request")
        XCTAssert(downloadTaskService.hasDownloadTask(for: request2), "Should be true since it's listed an active request")
    
        XCTAssert(downloadTaskService.removeAll(), "Should be true since all active download tasks have been removed")
        
        XCTAssertFalse(downloadTaskService.hasDownloadTask(for: request1), "Should be false since there's no match and download task is not active")
        XCTAssertFalse(downloadTaskService.hasDownloadTask(for: request2), "Should be false since there's no match and download taks is not active ")
        
    }
    
    
    func testAddResponseHandlerToDownloadTask() {
        
        let request1 = URLRequest(url: URL(string: "www.google.com")!)
        let handlerID1 = ResponseHandler.getUniqueHandlerID()
        
        // Awaiting response handler with a closure that returns an error
        let responseHandler1 = ResponseHandler(handlerID: handlerID1) { (_, err) in }
        
        
        let request2 = URLRequest(url: URL(string: "www.google.com")!)
        let handlerID2 = ResponseHandler.getUniqueHandlerID()
        
        // Awaiting response handler with a closure that returns an error
        let responseHandler2 = ResponseHandler(handlerID: handlerID2) { (_, err) in }
        
        
        let downloadTask = MVDownloaderTask(request1, handlerID: handlerID1, responseHandler: responseHandler1)
        
        let downloadTaskService = MVDownloaderTaskService()
        
        XCTAssertNil(downloadTaskService.getDownloadTask(withRequest: request1), "Should be nil since there are no active download tasks")
        
        // Awaiting response handlers
        XCTAssertEqual(downloadTask.responseHandlers.count, 1)
        
        // Register download task as active
        downloadTaskService.addDownloadTask(downloadTask)
        
        XCTAssertNotNil(downloadTaskService.getDownloadTask(withRequest: request1), "Should not be nil since active download task match was found")
        
        // Registering another await response handler pointing to the same request
        downloadTaskService.addCompletionHandler(for: request2, handler: responseHandler2)
        
        // Awaiting response handlers
        XCTAssertEqual(downloadTask.responseHandlers.count, 2)
        
    }
    
    
    func testInvokeResponseHandlersForDownloadTask() {
        
        let request1 = URLRequest(url: URL(string: "www.google.com")!)
        let handlerID1 = ResponseHandler.getUniqueHandlerID()
        
        // Awaiting response handler with a closure that returns an error
        let responseHandler1 = ResponseHandler(handlerID: handlerID1) { (_, err) in
            XCTAssertNotNil(err, "Should not be nil")
        }
        
        
        let request2 = URLRequest(url: URL(string: "www.google.com")!)
        let handlerID2 = ResponseHandler.getUniqueHandlerID()
        
        // Awaiting response handler with a closure that returns an error
        let responseHandler2 = ResponseHandler(handlerID: handlerID2) { (_, err) in
            XCTAssertNotNil(err, "Should not be nil")
        }
        
        
        let downloadTask = MVDownloaderTask(request1, handlerID: handlerID1, responseHandler: responseHandler1)
        
        let downloadTaskService = MVDownloaderTaskService()
        
        XCTAssertNil(downloadTaskService.getDownloadTask(withRequest: request1), "Should be nil since there are no active download tasks")
        
        // Awaiting response handlers
        XCTAssertEqual(downloadTask.responseHandlers.count, 1)
        
        // Register download task as active
        downloadTaskService.addDownloadTask(downloadTask)
        
        XCTAssertNotNil(downloadTaskService.getDownloadTask(withRequest: request1), "Should not be nil since active download task match was found")
        
        // Registering another await response handler pointing to the same request
        downloadTaskService.addCompletionHandler(for: request2, handler: responseHandler2)
        
        // Awaiting response handlers
        XCTAssertEqual(downloadTask.responseHandlers.count, 2)
        
        // Request to invoke all awaiting response handlers and pass response back
        downloadTaskService.invokeCompletionHandler(for: request1, withResponse: ResponseData(data: nil, error: MVDownloaderError.InvalidImageData))
        
        XCTAssertNil(downloadTaskService.getDownloadTask(withRequest: request1), "Should be nil since download task is no longer listed as active")
        XCTAssertNil(downloadTaskService.getDownloadTask(withRequest: request2), "Should be nil since download task is no longer listed as active")
        
        // Number of active donwload tasks
        XCTAssertEqual(downloadTaskService.downloadTaskCount(), 0, "Should equal to 0 since there are no longer active download tasks")
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
