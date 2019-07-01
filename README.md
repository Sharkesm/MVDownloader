# MVDownloader

MVDownloader is a native swift library for making asynchrouns remote requests to download images or JSON format files from the web. 

[![CI Status](https://img.shields.io/travis/Sharkes Monken/MVDownloader.svg?style=flat)](https://travis-ci.org/Sharkes Monken/MVDownloader)
[![Version](https://img.shields.io/cocoapods/v/MVDownloader.svg?style=flat)](https://cocoapods.org/pods/MVDownloader)
[![License](https://img.shields.io/cocoapods/l/MVDownloader.svg?style=flat)](https://cocoapods.org/pods/MVDownloader)
[![Platform](https://img.shields.io/cocoapods/p/MVDownloader.svg?style=flat)](https://cocoapods.org/pods/MVDownloader)

## Features 
- [x] Asynchronous image downloading and caching.
- [x] Supports parallel remote requests 
- [x] Cancelable downloading and re-using resume data from previous requests 
- [x] Fetching of images form cache to improve performance and experience 
- [x] Built-in transition animation when setting images 
- [x] Placeholder replacement support 
- [x] Extends UIImageView and exposes usable methods that support quick way to download images 
- [x] Multiple resources accessing same resource will be backed with the same response 
- [x] Supports decoding of instances of a data type from JSON objects.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- iOS 10.0+ 
- Xcode 10.0+
- Swift 5.0+

## Dependencies
- [UIKit](https://developer.apple.com/documentation/uikit)

## Installation

MVDownloader is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MVDownloader'
```

## Usage

### Download image 

```swift
import MVDownloader

let imageView = UIImageView()

imageView.mv_setImage(from: url) // Sets downloaded image under the hood 
```

### Download JSON 
```swift 
import MVDownloader

/// A type that can convert itself into and out of an external representation.

struct PhotoUrls: Codable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}


/// By default, below function utilises `JSONDecoder` object to decode instances of a data type from JSON objects.  

MVDownloader.shared.requestDecodable(type: PhotoUrls.self, from: pasteBinUrl) { (data, error) in

    // Proceed with data extraction 
}
```

## Author

Manase Michael, sharkesm@gmail.com

## License

MVDownloader is available under the MIT license. See the LICENSE file for more info.
