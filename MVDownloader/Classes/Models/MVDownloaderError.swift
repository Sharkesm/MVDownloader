//
//  MVDownloaderError.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 30/06/2019.
//

import Foundation


public enum MVDownloaderError: Error {
    case requestCancelled
    case responseFailed
    case imageConversionFailed
    case unknown
}

extension MVDownloaderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestCancelled:
            return "The requested was explicitly cancelled"
        case .responseFailed:
            return "The response was returned with unsuccessful result"
        case .imageConversionFailed:
            return "Image conversion has failed"
        default:
            return "Uknown error"
        }
    }
}
