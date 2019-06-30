//
//  ResponseHandler.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 29/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import Foundation


/// Custom network response
public struct ResponseData {
    var data: Data?
    var error: Error?
}


public typealias CompletionHandler = (Data?, Error?) -> Void


/// Holds reference for unique response handlers
class ResponseHandler {
    
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
