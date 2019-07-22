<p align="center" >
<img src="https://raw.githubusercontent.com/Sharkesm/MVDownloader/development/MVDownloaderBanner.png" title="MVDownloader logo" float=left>
</p>

# MVDownloader

[![Build Status](https://img.shields.io/travis/Sharkesm/master.svg?style=flat)](https://travis-ci.org/Sharkesm/MVDownloader)
[![Pod Version](https://img.shields.io/cocoapods/v/MVDownloader.svg?style=flat)](http://cocoadocs.org/docsets/MVDownloader/)
[![Pod Platform](https://img.shields.io/cocoapods/p/MVDownloader.svg?style=flat)](http://cocoadocs.org/docsets/MVDownloader/)
[![Pod License](https://img.shields.io/cocoapods/l/MVDownloader.svg?style=flat)](https://github.com/Sharkesm/MVDownloader/blob/master/LICENSE)
[![Repo Size](https://img.shields.io/github/repo-size/Sharkesm/MVDownloader.svg)](http://cocoadocs.org/docsets/MVDownloader/)

MVDownloader is a native swift library for making asynchronous remote requests to download images or JSON format files from the web. 

## Features 
- [x] Asynchronous image downloading and caching.
- [x] Supports parallel remote requests and caches URL responses
- [x] Cancelable downloading and re-using resume data from previous requests
- [x] Fetching of images from the cache to improve performance and experience
- [x] Built-in transition animation when setting images
- [x] Supports image placeholder support
- [x] Guarantee same URL request won't be fired several times
- [x] Custom cache control and configuration
- [x] Guarantee invalid URL won't be fired
- [x] Guarantee main thread won't be blocked
- [x] Extends UIImageView and exposes usable methods that support a quick way to download images
- [x] Multiple resources accessing the same resource will be backed up with the same response
- [x] Supports decoding of instances of a data type from JSON objects.
- [x] Uses GRC under the hood 

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
platform :ios, '10.0'
use_frameworks!
pod 'MVDownloader'
```

## Usage

### Shared Instance  
MVDownloader has a shared instance that can be utilised to access all of the exposed API methods.
```swift
import MVDownloader 

MVDownloader.shared
```
By default the library will cache all responses from all given URL requests and utilises `NSCache` object to provide in-memory spacing of up to `80 mb`.
 You can still configure a custom `NSCache` object with different storage capacity by initiating `MVDownloader.init(urlCache:_)` with defined cache.  

### Download Image
Downloading images using the library can be as easy as providing a proper `URL` request to `requestImage(from:_, comepletion:_)` method 
and takes over the process of downloading and converting response data to `MVImage` a type of `UIImage`. 
```swift 
import MVDownloader 

let url = URL(string:"https://techcrunch.com/wp-content/uploads/2015/04/codecode.jpg?w=1390&crop=1")!

MVDownloader.shared.requestImage(from: url) { (mvimage, error) in
    
    if let downloadedImage = mvimage {
       print("Downloaded image: ", downloadedImage)
    }
    
}
```
Also, there's another way to download images quickly without the hussle writting longer code blocks of such. Checkout `mv_setImage` example. 

### Download Image using `mv_setImage`
MVDownloader library under the hood it extends `UIImageView` and exposes `mv_setUmage(from:_)` method with intention of downloading images and setting them automatically and apply animation transition. 

```swift
import MVDownloader

guard let url = URL(string:"https://techcrunch.com/wp-content/uploads/2015/04/codecode.jpg?w=1390&crop=1") else {
    print("Given url is invalid")
    return 
}

let imageView = UIImageView()

// Downloads image and sets it automatically 
imageView.mv_setImage(from: url) { (error) in 
  ...
}  
```

### Download JSON 
Decoding of instances of a particular type from JSON objects can be smootly executed by utilising `MVDownloader` ~ `requestDecodable(type:_,from:)` method.  

```swift 
import MVDownloader

/// A type that can convert itself into and out of an external representation.
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


guard let pasteBinUrl =
URL(string:"https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max&s=d5682032c546a3520465f2965cde1cec") else {
print("Given url is invalid")
return 
}

/// By default, below function utilises `JSONDecoder` object to decode instances of a data type from JSON objects.  

MVDownloader.shared.requestDecodable(type: [PhotoModel].self, from: pasteBinUrl) { (data, error) in

    ...
    // Proceed with data extraction 
    ...
}
```

### Normal Remote Request 
Another benefit for this library is that it's not limited to download JSON and Image only. But you can also still make normal requests to the network. 
```swift 
import MVDownloader 

let url = URL(string: "www.google.com")!
let urlRequest = URLRequest(url: url)

MVDownloader.shared.request(urlRequest) { (data, error) in
    ...
    // Process response data 
    ...
}
```

### Cancel Active Request 
Active remote request can still be cancelled and removed completely from active download task collection list. 
```swift 
import MVDownloader 

let url = URL(string: "www.google.com")!
let urlRequest = URLRequest(url: url)

let downloader = MVDownloader.shared 

// Active request on progress 
downloader.request(urlRequest) { (data, error) in 
    ...
    // Proceed with data extraction
    ...
}


// Cancelling active request using there associated `URL` request 
let requestDidCancel = downloader.cancelRequest(for: url)

// Check if request is successfully cancelled 
if requestDidCancel {
    ...
}
```

### Clear Cache
An entire cache can be easily cleared up by simply invoking the following method `clearAllCache()`
```swift 
 MVDownloader.shared.clearAllCache()
```

Clearing up a specific request from the cache can be achieved by the following method ``
```swift 

guard let url = URL(string:"https://techcrunch.com/wp-content/uploads/2015/04/codecode.jpg?w=1390&crop=1") else {
    print("Given url is invalid")
    return 
}

MVDownloader.shared.clearCache(for: url)
```


## Author

Manase Michael, sharkesm@gmail.com

## License

MVDownloader is available under the MIT license. See the LICENSE file for more info.
