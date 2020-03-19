//
//  GalleryImage.swift
//  ImageGallery
//
//  Created by Xu Yan on 3/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation

struct Gallery {
    var images: [GalleryImage] = []
    
    func url(at indexPath: IndexPath) -> URL {
        return images[indexPath.item].url
    }
    
    func aspectRatio(at indexPath: IndexPath) -> Double {
        return images[indexPath.item].aspectRatio
    }
}

struct GalleryImage {
    var url: URL
    var aspectRatio: Double
}
