//
//  ResponseHandler.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 29/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import Foundation


public struct ResponseData {
    var data: Data?
    var error: Error?
}


public typealias CompletionHandler = (Data?, Error?) -> Void


class ResponseHandler {
    
    let handlerID: String
    var completion: CompletionHandler?
    
    init(handlerID: String, completion: CompletionHandler?) {
        self.handlerID = handlerID
        self.completion = completion
    }
}

extension ResponseHandler {
    
    static func getUniqueHandlerID() -> String {
        return UUID().uuidString
    }
    
}
