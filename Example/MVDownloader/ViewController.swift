//
//  ViewController.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 06/30/2019.
//  Copyright (c) 2019 Sharkes Monken. All rights reserved.
//

import UIKit
import MVDownloader

class ViewController: UIViewController {
    
    // IBOutlet properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refreshControl = UIRefreshControl()
    
    // Private properties
    private var downloadablePhotoLinks: [URL] = []
    private let pasteBinUrl = URL(string: "https://pastebin.com/raw/wgkJgazE")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        
        collectionView.addSubview(self.refreshControl)
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        
        requestDownloadablePhotoUrls()
    }
    
    
    @objc func refresh(_ sender: Any) {
        
        downloadablePhotoLinks.removeAll()
        collectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.requestDownloadablePhotoUrls()
        }
    }
    
}


private extension ViewController {
    
    func requestDownloadablePhotoUrls() {
        
        refreshControl.beginRefreshing()
        
        MVDownloader.shared.requestDecodable(type: [PhotoModel].self, from: pasteBinUrl) { (photoModels, error) in
            
            guard let photoModels = photoModels else { return }
            
            // Load paste bin downlodable photo urls into collection
            for photoModel in photoModels {
                let url = URL(string: photoModel.urls.small)!
                self.downloadablePhotoLinks.append(url)
            }
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
            }
        }
    }
}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadablePhotoLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photoURL = downloadablePhotoLinks[indexPath.row]
        let identifier = String(describing: PhotoCollectionCell.self)
        
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        guard let cell = customCell as? PhotoCollectionCell else {
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


