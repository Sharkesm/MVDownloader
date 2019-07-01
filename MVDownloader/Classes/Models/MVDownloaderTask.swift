//
//  MVDownloaderTask.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 30/06/2019.
//

import Foundation

/// A download task that manages it's response handlers
public class MVDownloaderTask {
    
    var request: URLRequest
    var task: URLSessionTask?
    var resumeData: Data?
    var isDownloading: Bool = false
    
    var responseHandlers: [String: ResponseHandler]
    
    
    init(_ request: URLRequest, handlerID: String, responseHandler: ResponseHandler) {
        self.request = request
        self.responseHandlers = [:]
        self.responseHandlers[handlerID] = responseHandler
    }
}
