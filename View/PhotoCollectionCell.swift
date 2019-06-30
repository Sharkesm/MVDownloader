//
//  PhotoCollectionCell.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 30/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import Foundation
import UIKit


class PhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureImage(withURL url: URL) {
        imageView.mv_setImage(from: url)
    }
    
}
