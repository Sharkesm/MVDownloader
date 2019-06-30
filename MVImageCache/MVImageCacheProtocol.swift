//
//  ImageCacheProtocol.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 28/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import Foundation


/// Image cache status
public enum MVImageCacheStatus {
    case available
    case notAvailable
}


/// Image cache protocol operations

public protocol MVImageCacheProtocol {
    
    /// Add new `MVImage` with associated identifier into the cache list
    ///
    /// Incase by any chance, there's a cached `MVImage` with the same identifier.
    /// Cache process stops to avoid duplicate items being registered.
    ///
    /// - Parameters:
    ///     - image:      `MVImage` to be cached
    ///     - identifier: A unique identifier to be associated with `MVImage`
    
    func add(_ image: MVImage, withIdentifier identifier: NSURL)
    
    
    /// Removes cached image with associated identifier
    ///
    /// Firstly, checks if cached image with associated identifier exists
    /// then proceeds with removal proceducer and return `True`.
    ///
    /// Incase there's no image associated with given identifier in the cache list.
    /// It will return `False`.
    ///
    /// - Parameter identifier: URL request as identifier
    ///
    /// - Returns: A boolean value.
    
    func removeImage(withIdentifier identifier: NSURL) -> Bool
    
    
    /// Finds `MVImage` in the cache list with asssociated identifier
    ///
    /// - Parameter identifier: URL request as identifier
    ///
    /// - Returns: Optional `MVImage` instance
    
    func filterImage(withIdentifier identifier: NSURL) -> MVImage?
    
    
    /// Checks if there's any image in the cache list associated with a given
    /// `NSURL` as identifier
    ///
    /// - Parameter identifier: URL request as identifier
    ///
    /// - Returns: `MVImageCacheStatus` of kind as status
    
    func isImageCached(withIdentifier identifier: NSURL) -> MVImageCacheStatus
    
    
    /// Removes all cached objects
    ///
    /// - Returns: A boolean value. Defaults to `true`
    
    @discardableResult
    func clearCache() -> Bool
    
}


