//
//  MVDownloaderError.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 28/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import Foundation


public enum MVDownloaderError: Error {
    case requestCancelled
    case responseFailed
    case imageConversionFailed
    case unknown
}

extension MVDownloaderError {
    public var localizedDescription: String {
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
