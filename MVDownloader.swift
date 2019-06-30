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
        clearAllCache()                      // Clear all caches
        session.invalidateAndCancel()    // Cancel all session tasks
        downloadTaskService.removeAll() // Remove all stored download tasks
    }

}


public extension MVDownloader {
    
    
    /// Default URL cache instance
    ///
    /// - Returns: URL cache instance with defined memory capacity. Defaults to `80MB`

    static func defaultURLCache() -> URLCache {
        return URLCache(
                    memoryCapacity: 80 * 1024 * 1024, // 80MB memory capacity
                    diskCapacity: 0,
                    diskPath: nil
                )
    }
    
    
    /// Clear URL response for a given `URL` request
    ///
    /// - Parameter url: URL request
    
    func clearCache(for url: URL) {
        
        let request = URLRequest(url: url)
        urlCache.removeCachedResponse(for: request)
        
        // Remove cached image if it exists
        if imageCacheManager.isImageCached(withIdentifier: (url as NSURL)) == .available {
            _ = imageCacheManager.removeImage(withIdentifier: (url as NSURL))
        }
    }
    
    
    /// Clears all cahced images and URL responses
    func clearAllCache() {
        imageCacheManager.clearCache()
        urlCache.removeAllCachedResponses()
    }
    
    
    /// Asynchrounsly performs a data task request and manages parallel requests
    ///
    ///  - Note:
    ///
    ///     Under the hood, it creates a download task `MVDownloaderTask` to be used as reference point
    ///     for unique requests. Then utilises `MVDownloaderTaskService` object to register incoming requests.
    ///
    ///     1 - Generates a unique closure handler identity.
    ///
    ///     2 - Creates a response handler that registers a closure handler with a unique identity.
    ///
    ///     3 - Creates download task `MVDownloaderTask`, that manages independent request session.
    ///
    ///     4 - `MVDownloaderTaskService` will check if incoming request has already been made and it's under processing.
    ///         And if the request has been made already, it will add a new `ResponseHandler` with a unique identity.
    ///
    ///     5 - Registers a data task to `MVDownloaderTask`, so as other network operation can be performed such suspending or
    ///         resume that particular request or pausing i
    ///
    ///     6 - Add new `MVDownloaderTask` into `MVDownloaderTaskService` download task collection
    ///
    ///     7 - Resumes `MVDownloaderTask.task` session
    ///
    ///     8 - Upon network response, all `ResponseHandlers` linked to that particular request will
    ///         get to be invoked with corresponding data from the server.
    ///
    ///
    /// - Parameters:
    ///     - request:    URL request
    ///     - completion: A closure handler to be invoked upon network request completes.
    
    func downloadTask(request: URLRequest, completion: @escaping CompletionHandler) {
        
        // 1
        let handlerID = ResponseHandler.getUniqueHandlerID()
        
        // 2
        let responseHanlder = ResponseHandler(handlerID: handlerID, completion: completion)
        
        // 3
        let downloaderTask = MVDownloaderTask(request, handlerID: handlerID, responseHandler: responseHanlder)

        // 4
        if downloadTaskService.hasDownloadTask(for: request) {
            downloadTaskService.addCompletionHandler(for: request, handler: responseHanlder)
            return
        }

        // 5
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

            // 8
            self.downloadTaskService.invokeCompletionHandler(for: request, withResponse: ResponseData(data: data, error: nil))
            
        }

        // 6
        downloadTaskService.addDownloadTask(downloaderTask)

        // 7
        downloaderTask.task?.resume()
    }
    
    
    /// Asynchronously performs a remote request and fetch an image.
    ///
    /// Incase by any chance incoming `URL` request finds a match on any cached image with associated `URL` request.
    /// Then `MVImageCache` wil be utilised to fetch the image and network request will be dropped.
    ///
    /// Under the hood, it utilises internal `downloadTask(request:_)` method, with intention of firing network
    /// requests and return raw data or error as response.
    ///
    /// - Parameters:
    ///     - url:         URL request
    ///     - completion:  A closure handler to be invoked upon image request has completed.

    func downloadImage(from url: URL, completion: @escaping (_ image: MVImage?, _ error: MVDownloaderError?) -> Void) {

        
        // Fetch image from cache only if it has been stored before with the same `URL`
        // Otherwise, proceed with remote request.
        
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
    
    
    /// Asynchronously performs a remote request and decodes instances of a data `type` from JSON objects then
    /// return a value of type.
    ///
    /// Under the hood, by default it uses `JSONDecoder` to decode instances of a given data type.
    /// And types being passed as parameter should be decodable of kind otherwise error `MVDownloaderError` of a kind will be returned
    ///
    /// - Parameters:
    ///     - type:       Instance of a data type to be decoded
    ///
    ///     - url:        URL Request
    ///
    ///     - decoder:    JSON decoder object used to decode instance of given data type. Defaults to `JSONDecoder`
    ///
    ///     - completion: A clousre handler invoked when request returns a response.
    
    func requestDecodable<T: Decodable>(type: T.Type, from url: URL, decoder: JSONDecoder = JSONDecoder(),
                                        completion: @escaping (_ decodedType: T?, _ error: MVDownloaderError?) -> Void) {
        
        let request = URLRequest(url: url)
        
        downloadTask(request: request) { (data, error) in
            
            guard error == nil else {
                completion(nil, MVDownloaderError.responseFailed)
                return
            }
            
            guard let data = data else {
                completion(nil, MVDownloaderError.responseFailed)
                return
            }
            
            if let decodedType = try? decoder.decode(T.self, from: data) {
                completion(decodedType, nil)
            } else {
                completion(nil, MVDownloaderError.responseFailed)
            }
            
        }
    }
    
}
