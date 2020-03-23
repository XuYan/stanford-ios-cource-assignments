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
    
    func gallery(at: IndexPath) -> Gallery {
        let galleries = isOperationOnCurrentSection(at: at) ? currentGalleries : recentlyDeletedGalleries
        return galleries[at.row]
    }
    
    func getCurrentGallery(at: IndexPath) -> Gallery? {
        return isOperationOnCurrentSection(at: at) ? currentGalleries[at.row] : nil
    }
    
    mutating func addNewGallery() {
        let existingGalleryTitles = currentGalleries.map { $0.title }
        currentGalleries += [ Gallery(title: "untitled".madeUnique(withRespectTo: existingGalleryTitles)) ]
    }
    
    mutating func addToCurrentGalleries(_ gallery: Gallery) {
        currentGalleries.insert(gallery, at: 0)
    }
    
    mutating func addToRecentlyDeletedGalleries(_ gallery: Gallery) {
        recentlyDeletedGalleries.insert(gallery, at: 0)
    }

    mutating func removeGallery(at: IndexPath) -> Gallery {
        if isOperationOnCurrentSection(at: at) {
            return currentGalleries.remove(at: at.row)
        }
        return recentlyDeletedGalleries.remove(at: at.row)
    }
    
    func isOperationOnCurrentSection(at: IndexPath) -> Bool {
        return at.section == 0
    }
    
    func isOperationOnCurrentSection(at: Int) -> Bool {
        return at == 0
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
