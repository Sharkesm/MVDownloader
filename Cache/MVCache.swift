//
//  MVCache.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 25/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import UIKit


class MVCache {
    
    private var cache: NSCache<NSURL, CGImage>
    private var queue: DispatchQueue
    
    init() {
        cache = NSCache<NSURL, CGImage>()
        queue = DispatchQueue.init(label: "MVCacheQueue", qos: .userInitiated)
    }
    
}


// MARK: - Public methods
extension MVCache {
    
    
    /// Temporarily caches given bitmap image
    ///
    /// Caching of bitmap images will depend on existence of all defined method parameters.
    /// And, by any chance that given `URL` is found in cache object, caching will be cancelled.
    ///
    /// - Parameter image: Bitmap image to be cached
    /// - Parameter url: Associated URL path resource for the image. (Downloadable URL)
    ///
    func save(image: CGImage?, withURL url: NSURL) {
        
        guard let image = image else {
            return
        }
        
        // Only cache image if it's not cached yet.
        if cacheItemExists(withURL: url) {
            return
        }
        
        queue.async { [unowned cache] in
            cache.setObject(image, forKey: url)
        }
    }
    
    
    /// Requests to fetch for `CGImage` object only if it exists or else returns nil
    ///
    /// - Parameter url: The URL path to be used as a criterion in finding cached `CGImage` object.
    ///
    /// - Returns: An optional `CGImage` object ~ bitmap image
    ///
    func fetch(imageWithURL url: NSURL) -> CGImage? {
        return cacheItemExists(withURL: url) ? cache.object(forKey: url) : nil
    }

}


// MARK: - Private methods
private extension MVCache {
    
    /// Verifies availability of resources through given `NSURL` path
    ///
    /// - Parameter url: The URL path to be used to find a cached item
    ///
    /// - Returns: A boolean value
    private func cacheItemExists(withURL url: NSURL) -> Bool {
        return (cache.object(forKey: url) != nil) ? true : false
    }
    
}
