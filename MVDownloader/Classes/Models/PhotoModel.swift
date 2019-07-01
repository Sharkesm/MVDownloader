//
//  PhotoModel.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 30/06/2019.
//

import Foundation

/// To be used for demostration purposes only 
public struct PhotoModel: Codable {
    var urls: PhotoUrls
}

public struct PhotoUrls: Codable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}
