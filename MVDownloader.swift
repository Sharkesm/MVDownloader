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
    
    private let imageCacheManager = MVImageCache()
    
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
                    memoryCapacity: 80 * 1024 * 1024, // 80MB memory capacity
                    diskCapacity: 0,
                    diskPath: nil
                )
    }
    
    
    func downloadImage(from url: URL, completion: @escaping (_ image: MVImage?, _ error: MVDownloaderError?) -> Void) -> Void {
        
        if imageCacheManager.isImageCached(withIdentifier: (url as NSURL)) == .available {
            if let cachedImage = imageCacheManager.filterImage(withIdentifier: (url as NSURL)) {
                completion(cachedImage, nil)
            }
            return
        }
        
        let request = session.dataTask(with: url) { [unowned self] (data, urlResponse, error) in
            
            guard error == nil else {
                completion(nil, .responseFailed)
                return
            }
            
            guard let data = data, let image = MVImage(data: data) else {
                completion(nil, .imageConversionFailed)
                return
            }
            
            self.imageCacheManager.add(image, withIdentifier: (url as NSURL))

            completion(image, nil)
            
        }
            
        request.resume()
    }
    
}
