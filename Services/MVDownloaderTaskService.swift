//
//  MVDownloaderTaskService.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 29/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import Foundation

public class MVDownloaderTaskService {
    
    private var activeDownloadTask: [URLRequest: MVDownloaderTask]
    
    
    init() {
        activeDownloadTask = [:]
    }
    
    func downloadTaskCount() -> Int {
        return activeDownloadTask.count
    }
    
    func addCompletionHandler(for request: URLRequest, handler: ResponseHandler) {
        if hasDownloadTask(for: request) {
            let downloadTask = activeDownloadTask[request]
            downloadTask?.responseHandlers[handler.handlerID] = handler
        }
    }
    
    
    func invokeCompletionHandler(for request: URLRequest, withResponse response: ResponseData) {
        
        if hasDownloadTask(for: request) {
        
            guard let responseHandlers = activeDownloadTask[request]?.responseHandlers else { return }
            
            for responseHandler in responseHandlers {
                responseHandler.value.completion!(response.data, response.error)
            }
            
            activeDownloadTask.removeValue(forKey: request)
        }
        
    }
    
    
    func addDownloadTask(_ task: MVDownloaderTask) {
        task.isDownloading = true
        activeDownloadTask[task.request] = task
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
            sessionTask.cancel()
            activeDownloadTask[task.request]?.isDownloading = false
        }
        
        if let removedTask = activeDownloadTask.removeValue(forKey: task.request) {
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
