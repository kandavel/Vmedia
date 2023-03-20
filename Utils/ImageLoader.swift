import Foundation
import UIKit

public final class ImageLoader {
    public static let shared = ImageLoader()
    
    private let cache: ImageCacheType
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }
    
    public func loadImage(from url: URL,completionHandler : @escaping (_ image : UIImage?,_ error : Error?) -> Void) {
        if let image = cache[url] {
            completionHandler(image, nil)
        }
        // self.cache[url] = image
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let response = data {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: response)
                    self.cache[url] = imageToCache
                    completionHandler(imageToCache, nil)
                }
            }
            else {
                completionHandler(nil, error)
            }
        }.resume()
    }
}
