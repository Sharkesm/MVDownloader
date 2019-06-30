//
//  MVDownloaderTaskService.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 30/06/2019.
//

import Foundation


/// Manages parallel download task sessions
public class MVDownloaderTaskService {
    
    // Private methods
    private var activeDownloadTask: [URLRequest: MVDownloaderTask]
    
    
    init() {
        activeDownloadTask = [:]
    }
    
    
    /// Number of active download task
    ///
    /// - Returns: A number of active downlod task
    
    func downloadTaskCount() -> Int {
        return activeDownloadTask.count
    }
    
    
    /// Add new `ResponseHandler` to there respective `MVDownloaderTask` response handler collection.
    ///
    /// - Warning:
    ///
    ///    This function should only be used to register new `ResponseHandler`
    ///    that match a given request on the active download task list.
    ///
    ///    Otherwise, such `ResponseHandler` will be dropped as there's no
    ///    active download task that will respond to it once request finishes.
    ///
    /// - Parameters:
    ///     - request: URL request
    ///     - handler: Associated closure handler `ResponseHandler` for an active download task.
    
    func addCompletionHandler(for request: URLRequest, handler: ResponseHandler) {
        if hasDownloadTask(for: request) {
            let downloadTask = activeDownloadTask[request]
            downloadTask?.responseHandlers[handler.handlerID] = handler
        }
    }
    
    
    /// Invokes all closure handlers associated with given request
    ///
    /// It checks if there's any active download task that matches that given request
    /// then invokes all `ResponseHandler` linked to that download task and pass respective data
    ///
    /// Once all `ResponseHandlers` have been invoked and passed with there respective data,
    /// that request will be removed as an active download task.
    ///
    /// - Parameters:
    ///     - request:  URL request
    ///     - resppnse: Response with respective data
    
    func invokeCompletionHandler(for request: URLRequest, withResponse response: ResponseData) {
        
        if hasDownloadTask(for: request) {
            
            guard let responseHandlers = activeDownloadTask[request]?.responseHandlers else { return }
            
            for responseHandler in responseHandlers {
                responseHandler.value.completion!(response.data, response.error)
            }
            
            activeDownloadTask.removeValue(forKey: request)
        }
        
    }
    
    
    /// Add new `MVDownloaderTask` as an active download task
    ///
    /// By default, incoming download task will be marked `isDownloading` as `true`
    ///
    /// - Parameter task: Download data task
    
    func addDownloadTask(_ task: MVDownloaderTask) {
        task.isDownloading = true
        activeDownloadTask[task.request] = task
    }
    
    
    /// Checks if there's any active download task that matches given `URL` request
    ///
    /// - Parameter request: URL Request
    ///
    /// - Returns: A boolean value
    
    func hasDownloadTask(for request: URLRequest) -> Bool {
        return (activeDownloadTask[request] != nil) ? true : false
    }
    
    
    /// Fetch active download task that matches given `URL` request
    ///
    /// - Parameter request: URL request
    ///
    /// - Returns: Optional download task
    
    func getDownloadTask(withRequest request: URLRequest) -> MVDownloaderTask? {
        return activeDownloadTask[request]
    }
    
    
    /// Cancels active download taks that matches given `URL` request
    ///
    /// Incase there's an active download task then it will be cancelled and
    /// removed completely as active otherwise return.
    ///
    /// - Parameter request: URL request
    
    func cancelDownloadTask(withRequest request: URLRequest) {
        
        guard let downloadTask = activeDownloadTask[request] else { return }
        
        downloadTask.task?.cancel()
        activeDownloadTask[request] = nil
    }
    
    
    /// Removes given download task from active download task list
    ///
    /// - Parameter task: Download task to be removed
    ///
    /// - Returns: Optional download task that has been removed
    
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
    
    
    /// Removes all download task and cancels all linked session data task
    ///
    /// - Returns: A boolean value
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
