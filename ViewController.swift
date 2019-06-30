//
//  ViewController.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 25/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

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

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let downloadablePhotoLinks = ["https://images.unsplash.com/photo-1464550883968-cec281c19761",
                                          "https://images.unsplash.com/photo-1464550883968-cec281c19761",
                                          "https://images.unsplash.com/photo-1464550883968-cec281c19761",
                                      "https://images.unsplash.com/photo-1464550838636-1a3496df938b?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max&s=67b8dcbfc47e2ba3f39d2d01a8177864",
                                      "https://images.unsplash.com/photo-1464550838636-1a3496df938b?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max&s=67b8dcbfc47e2ba3f39d2d01a8177864",

                                          "https://images.unsplash.com/photo-1464547323744-4edd0cd0c746?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=17b4934ff6fe2e8773896c87aa4ae85b",
                                          "https://images.unsplash.com/photo-1464545022782-925ec69295ef?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=9af697a854378fe9e922dd8ebc6ec039",
                                          "https://images.unsplash.com/photo-1464537356976-89e35dfa63ee?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=3e32e4760e959e86133eb08418ed5fc5",
                                          "https://images.unsplash.com/photo-1464550883968-cec281c19761",
                                      "https://images.unsplash.com/photo-1464550838636-1a3496df938b?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max&s=67b8dcbfc47e2ba3f39d2d01a8177864",
                                          "https://images.unsplash.com/photo-1464547323744-4edd0cd0c746?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=17b4934ff6fe2e8773896c87aa4ae85b",
                                          "https://images.unsplash.com/photo-1464545022782-925ec69295ef?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=9af697a854378fe9e922dd8ebc6ec039",
                                          "https://images.unsplash.com/photo-1464537356976-89e35dfa63ee?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=3e32e4760e959e86133eb08418ed5fc5",
                                      "https://images.unsplash.com/photo-1464550838636-1a3496df938b?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max&s=67b8dcbfc47e2ba3f39d2d01a8177864",
                                      
                                          "https://images.unsplash.com/photo-1464519586905-a8c004d307cc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=54ea86802ddc826d8933491d262616af",
                                          
                                          "https://images.unsplash.com/photo-1464519046765-f6d70b82a0df?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=8cfd7aa940eb30ae2d754704c1ba89b5",
                                          "https://images.unsplash.com/photo-1464547323744-4edd0cd0c746?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=17b4934ff6fe2e8773896c87aa4ae85b"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.reloadData()
    }


}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadablePhotoLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photoURLString = downloadablePhotoLinks[indexPath.row]
        
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath)
        
        guard let cell = customCell as? PhotoCollectionCell else {
            return customCell
        }
        
        guard let photoURL = URL(string: photoURLString) else {
            return customCell
        }
        
        cell.configureImage(withURL: photoURL)
        
        return cell
    }
}

extension UIViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photoWidth = (collectionView.frame.width / 3) - 1
        return CGSize(width: photoWidth, height: photoWidth)
    }
}
