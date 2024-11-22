//
//  DataCache.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/21.
//

import Foundation

/// @mockable
protocol DataCache {
    
    func getData(forKey key: String) -> Data?
    func setData(_ data: Data, forKey key: String)
    
}

class DataCacheImplementation: DataCache {
    
    static let shared = DataCacheImplementation()
    
    private let cache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func getData(forKey key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }
    
func setData(_ data: Data, forKey key: String) {
        cache.setObject(data as NSData, forKey: key as NSString)
    }
}
