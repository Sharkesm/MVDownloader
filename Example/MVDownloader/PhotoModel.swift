//
//  PhotoModel.swift
//  MVDownloader_Example
//
//  Created by Manase Michael on 01/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

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
