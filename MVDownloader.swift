//
//  MVDownloader.swift
//  MVDownloader
//
//  Created by Manasseh Michael on 25/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import Foundation

public class MVDownloaderTaskService {
    
    private var activeDownloadTask: [URLRequest: MVDownloaderTask]
    
    
    init() {
        activeDownloadTask = [:]
    }
    
    
    func addDownloadTask(_ task: MVDownloaderTask) {
    
        task.isDownloading = true
        activeDownloadTask[task.request] = task
        
        print("Added request: ", task.request.url as Any)
        print("Active Requests: ", activeDownloadTask.count)
    }
    
    
    func hasDownloadTask(for request: URLRequest) -> Bool {
        return (activeDownloadTask[request] != nil) ? true : false
    }
    

    func getDownloadTask(withRequest request: URLRequest) -> MVDownloaderTask? {
        
        let requests = activeDownloadTask.keys
        
        if requests.contains(request) {
            return activeDownloadTask[request]
        }
        
        return nil
    }
    
    
    func cancelDownloadTask(withRequest request: URLRequest) {
        
        guard let downloadTask = activeDownloadTask[request] else { return }
        
        downloadTask.task?.cancel()
        activeDownloadTask[request] = nil
    }
    
    
    @discardableResult
    func removeDownloadTask(_ task: MVDownloaderTask) -> MVDownloaderTask? {
        
        guard let downloadTask = activeDownloadTask[task.request] else { return nil }
        
        if let sessionTask = downloadTask.task {
            print("Cancelling session: ", downloadTask.request.url as Any)
           sessionTask.cancel()
           activeDownloadTask[task.request]?.isDownloading = false
        }
        
        if let removedTask = activeDownloadTask.removeValue(forKey: task.request) {
            print("Remove completed task: ", removedTask.request.url as Any)
            return removedTask
        }
        
        return nil
    }
    
    
    @discardableResult
    func removeAll() -> Bool {
        for downloadTask in activeDownloadTask {
            if let sessionTask = downloadTask.value.task {
                sessionTask.cancel()
                _ = activeDownloadTask.removeValue(forKey: downloadTask.key)
            }
        }
        
        return true
    }
}

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
    
    
    func downloadTask(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        if downloadTaskService.hasDownloadTask(for: request) {
            completion(nil, nil, MVDownloaderError.unknown)
            return
        }

        let downloaderTask = MVDownloaderTask(request)
        
        downloaderTask.task = session.dataTask(with: request) { [weak self] (data, response, error) in

            guard let `self` = self else { return }
            
            guard error == nil else {
                completion(nil, nil, MVDownloaderError.unknown)
                return
            }

            guard let data = data, let response = response else {
                completion(nil, nil, MVDownloaderError.unknown)
                return
            }
            
            self.downloadTaskService.removeDownloadTask(downloaderTask)
            
            completion(data, response, nil)
        }

        downloadTaskService.addDownloadTask(downloaderTask)

        downloaderTask.task?.resume()
    }
    
    
    func downloadImage(from url: URL, completion: @escaping (_ image: MVImage?, _ error: MVDownloaderError?) -> Void) {

        if imageCacheManager.isImageCached(withIdentifier: (url as NSURL)) == .available {
            if let cachedImage = imageCacheManager.filterImage(withIdentifier: (url as NSURL)) {
                
                print("Cached Image: ", cachedImage)
                
                completion(cachedImage, nil)
            }
            return
        }
    
        let request = URLRequest(url: url)
        
        downloadTask(request: request) { [weak self] (data, response, error) in

            guard let `self` = self else { return }

            guard error == nil else {
                print("Error: ", error as Any)
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
