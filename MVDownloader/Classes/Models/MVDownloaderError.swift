//
//  MVDownloaderError.swift
//  MVDownloader
//
//  Created by Manase Michael on 30/06/2019.
//

import Foundation


public enum MVDownloaderError: Error {
    
    /// Loader has been completely deallocated
    case InvalidImageData
    
    /// The server response was invalid or corrupted
    case MalformedResponse
    
    /// Loader has been completely deallocated
    case LoaderDeallocated
    
    /// The response data returned from the server is invalid or corrupted
    case InvalidResponseData
    
    /// The request was internally cancelled by the system
    case RequestCancelledBySYS
    
    /// The request was explicitly cancelled by the user
    case RequestCancelledByUser
    
    /// Generic error
    case Generic(_ error: Error)
    
    /// Image caching error
    case ImageCacheFailed(_ image: MVImage, _ identifier: NSURL)
}



extension MVDownloaderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .LoaderDeallocated:
            return "Loader has been completely deallocated"
        case .RequestCancelledByUser:
            return "The request was explicitly cancelled by the user"
        case .RequestCancelledBySYS:
            return "The request was internally cancelled by the system"
        case .MalformedResponse:
            return "The server response was invalid or corrupted"
        case .InvalidResponseData:
            return "The response data returned from the server is invalid or corrupted"
        case .InvalidImageData:
            return "The image data response was corrupted or invalid"
        case .ImageCacheFailed(let mvimage, let identifier):
            return "An error occured while trying to cache \(mvimage) of type with an identifier \(identifier)"
        case .Generic(let error):
            return "An error occured: \(error.localizedDescription)"
        }
    }
}
