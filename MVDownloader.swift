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
    private let downloadTaskService: MVDownloaderTaskService = MVDownloaderTaskService()
    
    public static var shared: MVDownloader = MVDownloader(urlCache: MVDownloader.defaultURLCache())
    
    
    init(urlCache: URLCache = MVDownloader.defaultURLCache()) {
        
        self.urlCache = urlCache
        
        let urlSessionConfig = URLSessionConfiguration.default
        urlSessionConfig.urlCache = self.urlCache
        
        session = URLSession(configuration: urlSessionConfig)
    }
    
    
    deinit {
        session.invalidateAndCancel()
        downloadTaskService.removeAll()
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
    
    
    func clearCache(for url: URL) {
        
        let request = URLRequest(url: url)
        urlCache.removeCachedResponse(for: request)
        
        // Remove cached image if it exists
        if imageCacheManager.isImageCached(withIdentifier: (url as NSURL)) == .available {
            _ = imageCacheManager.removeImage(withIdentifier: (url as NSURL))
        }
    }
    
    
    func clearCache() {
        imageCacheManager.clearCache()
        urlCache.removeAllCachedResponses()
    }
    
    
    func downloadTask(request: URLRequest, completion: @escaping CompletionHandler) {
        
        let handlerID = UUID().uuidString
        
        let responseHanlder = ResponseHandler(handlerID: handlerID, completion: completion)
        
        let downloaderTask = MVDownloaderTask(request, handlerID: handlerID, responseHandler: responseHanlder)

        if downloadTaskService.hasDownloadTask(for: request) {
            downloadTaskService.addCompletionHandler(for: request, handler: responseHanlder)
            return
        }

        downloaderTask.task = session.dataTask(with: request) { [weak self] (data, _, error) in

            guard let `self` = self else { return }

            guard error == nil else {
                self.downloadTaskService.invokeCompletionHandler(for: request, withResponse: ResponseData(data: nil, error:  MVDownloaderError.unknown))
                return
            }

            guard let data = data else {
                self.downloadTaskService.invokeCompletionHandler(for: request, withResponse: ResponseData(data: nil, error: MVDownloaderError.responseFailed))
                return
            }

            self.downloadTaskService.invokeCompletionHandler(for: request, withResponse: ResponseData(data: data, error: nil))
            
        }

        downloadTaskService.addDownloadTask(downloaderTask)

        downloaderTask.task?.resume()
    }
    
    
    
    func downloadImage(from url: URL, completion: @escaping (_ image: MVImage?, _ error: MVDownloaderError?) -> Void) {

        if imageCacheManager.isImageCached(withIdentifier: (url as NSURL)) == .available {
            if let cachedImage = imageCacheManager.filterImage(withIdentifier: (url as NSURL)) {
                completion(cachedImage, nil)
            }
            return
        }
    
        let request = URLRequest(url: url)
        
        downloadTask(request: request) { [weak self] (data, error) in

            guard let `self` = self else {
                return
            }

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
    }
    
}
