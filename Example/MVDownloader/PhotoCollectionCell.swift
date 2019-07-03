//
//  PhotoCollectionCell.swift
//  MVDownloader_Example
//
//  Created by Manase Michael on 01/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import MVDownloader


class PhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureImage(withURL url: URL) {
        imageView.mv_setImage(from: url) { (_) in }
    }
    
}
