//
//  Album.swift
//  Album
//
//  Created by 김동규 on 2022/01/20.
//

import Foundation
import Photos

class AlbumModel {
    
    var name: String
    var count: Int
    var collection: PHAssetCollection
    
    init(name: String, count: Int, collection: PHAssetCollection) {
        
        self.name = name
        self.count = count
        self.collection = collection
    }
}
