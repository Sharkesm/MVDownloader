//
//  MVDownloader.swift
//  MVDownloader
//
//  Created by Manasseh Michael on 25/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import Foundation


public class MVDownloader {
    
    private let session: URLSession
    private let urlCache: URLCache

    public static var shared: MVDownloader = MVDownloader(urlCache: MVDownloader.defaultURLCache())
    
    init(urlCache: URLCache = MVDownloader.defaultURLCache()) {
        
        self.urlCache = urlCache
        
        let urlSessionConfig = URLSessionConfiguration.default
        urlSessionConfig.urlCache = self.urlCache
        
        session = URLSession(configuration: urlSessionConfig)
    }
    
    
    deinit {
        session.invalidateAndCancel()
    }

}


public extension MVDownloader {
    
    static func defaultURLCache() -> URLCache {
        return URLCache(
                    memoryCapacity: 80 * 1024 * 1024, // 80MB
                    diskCapacity: 0,
                    diskPath: nil
                )
    }
    
    
    func downloadImage(from url: URL, completion: @escaping (_ image: MVImage?, _ error: MVDownloaderError?) -> Void) -> Void {
        
        session.dataTask(with: url) { (data, urlResponse, error) in
            
            guard error == nil else {
                completion(nil, .responseFailed)
                return
            }
            
            guard let data = data, let image = MVImage(data: data) else {
                completion(nil, .imageConversionFailed)
                return
            }
            
            completion(image, nil)
            
        }.resume()
    }
    
}
