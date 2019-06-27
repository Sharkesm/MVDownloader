//
//  ImageCacheProtocol.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 28/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import Foundation

public enum MVImageCacheStatus {
    case available
    case notAvailable
}

public protocol MVImageCacheProtocol {
    
    func add(_ image: MVImage, withIdentifier identifier: NSURL)
    
    func removeImage(withIdentifier identifier: NSURL) -> Bool
    
    func filterImage(withIdentifier identifier: NSURL) -> MVImage?
    
    func isImageCached(withIdentifier identifier: NSURL) -> MVImageCacheStatus
    
    @discardableResult
    func clearCache() -> Bool
    
}


