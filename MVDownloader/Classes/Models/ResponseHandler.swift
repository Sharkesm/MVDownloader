//
//  ResponseHandler.swift
//  MVDownloader
//
//  Created by Manase Michael on 30/06/2019.
//

import Foundation


/// Custom network response
public struct ResponseData {
    var data: Data?
    var error: Error?
}


public typealias CompletionHandler = (Data?, Error?) -> Void


/// Holds reference for unique response handler and can be utilised with download task `MVDownloaderTask`
/// to register awaiting closures.

public class ResponseHandler {
    
    let handlerID: String
    var completion: CompletionHandler?
    
    init(handlerID: String, completion: CompletionHandler?) {
        self.handlerID = handlerID
        self.completion = completion
    }
}


extension ResponseHandler {
    
    /// Generates a unique string to be used as handler identifirer
    ///
    /// - Returns: Unique string
    static func getUniqueHandlerID() -> String {
        return UUID().uuidString
    }
    
}
