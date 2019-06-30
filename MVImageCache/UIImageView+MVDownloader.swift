//
//  MVImage+MVDownloader.swift
//  MVDownloader
//
//  Created by Sharkes Monken on 30/06/2019.
//  Copyright © 2019 Sharkes Monken. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
    
    /// Kind of image transition effects along side with there durations.
    
    public enum MVImageTransition {
        
        /// No image transition effect will happen.
        case noTransition
        
        /// Dissolves current image to another image.
        case crossDissolve(TimeInterval)
        
        /// Curls current image from the bottom.
        case curlUp(TimeInterval)
        
        /// Curls current image from the top.
        case curlDown(TimeInterval)
        
        /// Flips current image from the left to right.
        case flipToRight(TimeInterval)
        
        /// Flips current image from right to left.
        case flipToLeft(TimeInterval)
        
        
        /// The duration of the transition in seconds
        public var duration: TimeInterval {
            switch self {
            case .noTransition:
                return 0.0
            case .crossDissolve(let duration):
                return duration
            case .curlUp(let duration):
                return duration
            case .curlDown(let duration):
                return duration
            case .flipToRight(let duration):
                return duration
            case .flipToLeft(let duration):
                return duration
            }
        }
        
        
        /// The animation options of the transition
        public var animationOptions: AnimationOptions {
            switch self {
            case .noTransition:
                return []
            case .crossDissolve:
                return .transitionCrossDissolve
            case .curlUp(_):
                return .transitionCurlUp
            case .curlDown(_):
                return .transitionCurlDown
            case .flipToRight(_):
                return .transitionFlipFromLeft
            case .flipToLeft(_):
                return .transitionFlipFromRight
            }
        }
        
        
        /// The animation options of the image transition.
        public var animations: ((UIImageView, MVImage) -> Void) {
            return { $0.image = $1 }
        }
    }
}



extension UIImageView {
    
    /// Asynchronously downloads an image from a given `URL` request, applies a default image initially while waiting
    /// for an image to be downloaded then runs image transitioning effect (If given) and finnally sets downloaded
    /// image to `UIImageView`
    ///
    /// - Parameters:
    ///     - url:               URL request
    
    ///     - placeholderImage:  An image to be set initially until the image requested finishes downloading. If `nil`,
    ///                             the `UIImageView` won't have any initial image and it will have to wait for image request
    ///                             to finish. Defaults to an image name `placeholder`.
    
    ///     - animationOption:   The image transitioning effect to be applied while setting image.
    ///                             Defaults to  `MVImageTransition.crossDissolve(1.0)`.
    
    public func mv_setImage(from url: URL, placeholderImage: UIImage? = UIImage(named: "placeholder"), animationOption: MVImageTransition = MVImageTransition.crossDissolve(1.0)) {
        
        self.image = placeholderImage
        
        MVDownloader.shared.downloadImage(from: url) { [weak self] (image, error) in
            
            guard let `self` = self else { return }
            
            guard error == nil else { return }
            
            guard let image = image else { return }
            
            DispatchQueue.main.async {
                self.runAnimation(animationOption, with: image, completion: {(status) in
                    self.image = image
                })
            }
        }
    }
    
    
    
    /// Creates an image transition effect by applying given `MVImageTransition` option
    ///
    /// - Parameters:
    ///     - imageTransition: The image transitioning effect option
    ///     - image:           The image to transition to
    ///     - completion:      A closure handler that gets to be invoked only when the animation is successful.
    
    public func runAnimation(_ imageTransition: MVImageTransition, with image: MVImage, completion: @escaping (Bool) -> Void) {
        UIView.transition(with: self, duration: imageTransition.duration, options: imageTransition.animationOptions, animations: {
            imageTransition.animations(self, image)
        }, completion: {(status) in
            completion(status)
        })
    }
}
