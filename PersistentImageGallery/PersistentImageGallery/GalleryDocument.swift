//
//  GalleryDocument.swift
//  PersistentImageGallery
//
//  Created by Xu Yan on 3/27/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

class GalleryDocument: UIDocument {
    var gallery: Gallery?
    
    override func contents(forType typeName: String) throws -> Any {
        return gallery?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            gallery = Gallery(data: json)
        }
    }
}

