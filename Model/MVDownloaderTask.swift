//
//  MVDownloaderTask.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 29/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import Foundation


class MVDownloaderTask {
    
    var request: URLRequest
    var responseHandlers: [String: ResponseHandler]
    
    init(_ request: URLRequest, handlerID: String, responseHandler: ResponseHandler) {
        self.request = request
        self.responseHandlers = [:]
        self.responseHandlers[handlerID] = responseHandler
    }
    
    var task: URLSessionTask?
    var isDownloading: Bool = false
    var resumeData: Data?
    
}
