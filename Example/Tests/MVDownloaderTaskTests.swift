//
//  MVDownloaderTask.swift
//  MVDownloader_Tests
//
//  Created by Sharkes Monken on 01/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import MVDownloader


class MVDownloaderTaskTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testDefaultInitializer() {
        
        let request = URLRequest(url: URL(string: "www.google.com")!)
        let handlerID = ResponseHandler.getUniqueHandlerID()
        let responseHandler = ResponseHandler(handlerID: handlerID, completion: nil)
        
        let downloaderTask = MVDownloaderTask(request, handlerID: handlerID, responseHandler: responseHandler)
        
        XCTAssertFalse(downloaderTask.isDownloading, "Should be false since download task wasn't resumed")
        XCTAssertNil(downloaderTask.resumeData, "Should be nil since download task has no resume data")
        XCTAssertNil(downloaderTask.task, "Should be nil since download task no active session")
        XCTAssert(downloaderTask.request == request, "Should be the same request")
        
        // Check awaiting response handlers with identity
        let handler = downloaderTask.responseHandlers[handlerID]
        
        XCTAssertNotNil(handler, "Should not be nil since there's an active handler waiting for response")
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
