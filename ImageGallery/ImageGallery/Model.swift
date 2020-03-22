//
//  GalleryImage.swift
//  ImageGallery
//
//  Created by Xu Yan on 3/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation

struct App {
    var currentGalleries: [Gallery]
    var recentlyDeletedGalleries: [Gallery]
    
    func gallery(at indexPath: IndexPath) -> Gallery {
        let galleries = indexPath.section == 0 ? currentGalleries : recentlyDeletedGalleries
        return galleries[indexPath.row]
    }
    
    func getCurrentGallery(at indexPath: IndexPath) -> Gallery? {
        if indexPath.section == 1 {
            return nil
        }
        return currentGalleries[indexPath.row]
    }
    
    mutating func addNewGallery() {
        let existingGalleryTitles = currentGalleries.map { $0.title }
        currentGalleries += [ Gallery(title: "untitled".madeUnique(withRespectTo: existingGalleryTitles)) ]
    }
    
    mutating func removeGallery(at: IndexPath) {
        if at.section == 0 {
            currentGalleries.remove(at: at.row)
            return
        }
        recentlyDeletedGalleries.remove(at: at.row)
    }
}

class Gallery {
    var title: String
    var images: [GalleryImage]
    
    init(title: String?) {
        self.title = title ?? ""
        self.images = []
    }

    func url(at indexPath: IndexPath) -> URL {
        return images[indexPath.item].url
    }
    
    func aspectRatio(at indexPath: IndexPath) -> Double {
        return images[indexPath.item].aspectRatio
    }
    
    func data(at indexPath: IndexPath) -> Data {
        return images[indexPath.item].data
    }
    
    func insert(_ image: GalleryImage, at: IndexPath) {
        images.insert(image, at: at.item)
    }
}

struct GalleryImage {
    var url: URL
    var aspectRatio: Double
    var data: Data
}
