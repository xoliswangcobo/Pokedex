//
//  ImageCache.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/21.
//

import UIKit

/// @mockable
protocol ImageCache {
    
    func getImage(forKey key: String) -> UIImage?
    func setImage(_ image: UIImage, forKey key: String)
    
}

class ImageCacheImplementation: ImageCache {
    
    static let shared = ImageCacheImplementation()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 300
        cache.totalCostLimit = 30 * 1024 * 1024 // 30MB
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
