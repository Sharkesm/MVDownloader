//
//  PhotoModel.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 30/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import Foundation


struct PhotoModel: Codable {
    var urls: PhotoUrls
}

struct PhotoUrls: Codable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}
