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
    
    init(_ request: URLRequest) {
        self.request = request
    }
    
    var task: URLSessionTask?
    var isDownloading: Bool = false
    var resumeData: Data?
    
}
