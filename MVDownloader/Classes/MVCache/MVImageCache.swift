//
//  MVImageCache.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 30/06/2019.
//

import Foundation
import UIKit


/// Caches `MVImage` temporarily
public class MVImageCache {
    
    var cache: NSCache<NSURL, MVImage>
    var cacheQueue: DispatchQueue
    
    static let DefaultImageCacheLimit = 100  // Number of objects cache can store
    static let DefaultCacheCostLimitInBytes = 30 * 1024 * 1024 // Size in bytes of data is used as cost, 30MB limit
    
    init() {
        
        cache = NSCache<NSURL, MVImage>()
        cache.name = "MVImageCacheQueue"
        cache.countLimit = MVImageCache.DefaultImageCacheLimit
        cache.totalCostLimit = MVImageCache.DefaultCacheCostLimitInBytes
            
        cacheQueue = DispatchQueue(label: "MVImageCacheQueue", qos: .userInitiated, attributes: .concurrent)
    }
    
    deinit {
        clearCache()
    }
}


// MARK: - MVImageCacheProtocol Methods

extension MVImageCache: MVImageCacheProtocol {
    
    
    @discardableResult
    public func clearCache() -> Bool {
        cache.removeAllObjects()
        return true
    }
    
    
    public func filterImage(withIdentifier identifier: NSURL) -> MVImage? {
        return cache.object(forKey: identifier)
    }
    
    
    public func isImageCached(withIdentifier identifier: NSURL) -> MVImageCacheStatus {
        return (cache.object(forKey: identifier) != nil) ? .available : .notAvailable
    }
    
    
    public func add(_ image: MVImage, withIdentifier identifier: NSURL) {
        
        if isImageCached(withIdentifier: identifier) == .available {
            return
        }
        
        cacheQueue.async { [unowned cache] in
            cache.setObject(image, forKey: identifier)
        }
        
    }
    
    
    public func removeImage(withIdentifier identifier: NSURL) -> Bool {
        
        if isImageCached(withIdentifier: identifier) == .notAvailable {
            return false
        }
        
        cache.removeObject(forKey: identifier)
        
        return true
    }
}
