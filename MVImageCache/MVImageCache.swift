//
//  MVCache.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 25/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import UIKit


/// Caches `MVImage` temporarily
public class MVImageCache {
    
    private var cache: NSCache<NSURL, MVImage>
    private var cacheQueue: DispatchQueue
    
    init() {
        cache = NSCache<NSURL, MVImage>()
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
        return cache.object(forKey: identifier)!
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
