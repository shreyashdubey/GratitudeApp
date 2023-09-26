//
//  ImageDownloaderViewModel.swift
//  Gratitude
//
//  Created by Shreyash on 9/24/23.
//

import Foundation
import SwiftUI
class ImageDownloaderViewModel: ObservableObject {
    @Published var downloadedImage: UIImage?
    
    func downloadImage(fromURL url: URL, completion: @escaping (UIImage?) -> Void) {
            if let cachedImage = APIService.imageCache.object(forKey: url as AnyObject) as? UIImage {
                print("Image was cached")
                self.downloadedImage = cachedImage
                completion(cachedImage)
            } else {
                APIService.downloadImage(from: url.absoluteString) { image in
                    DispatchQueue.main.async {
                        print("Image downloaded")
                        self.downloadedImage = image
                        completion(image)
                    }
                }
            }
        }
}
