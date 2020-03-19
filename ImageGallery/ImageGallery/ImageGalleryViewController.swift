//
//  ImageGalleryViewController.swift
//  ImageGallery
//
//  Created by Xu Yan on 3/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GalleryImageCell"

class ImageGalleryViewController: UICollectionViewController, UIDropInteractionDelegate {
    private var gallery = Gallery()
    private var imageWidth = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        view.addInteraction(UIDropInteraction(delegate: self))
    }

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        var draggedImageUrl: URL?
        var draggedImage: UIImage?

        session.loadObjects(ofClass: NSURL.self) { nsurls in
            if let url = nsurls.first as? URL {
                draggedImageUrl = url.imageURL
                if let image = draggedImage {
                    self.onImageDropped(url: url, aspectRatio: image.aspectRatio)
                }
            }
        }
        
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage {
                draggedImage = image
                if let url = draggedImageUrl {
                    self.onImageDropped(url: url, aspectRatio: image.aspectRatio)
                }
            }
        }
    }
    
    private func onImageDropped(url: URL, aspectRatio: Double) {
        let image = GalleryImage(url: url, aspectRatio: aspectRatio)
        self.gallery.images.append(image)
        self.collectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gallery.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        // Configure the cell
        if let galleryImageCell = cell as? GalleryImageCell {
            DispatchQueue.global(qos: .userInitiated).async {
                let url = self.gallery.url(at: indexPath)
                print(url)
                guard let imageData = try? Data(contentsOf: self.gallery.url(at: indexPath)) else {
                    print("Fail to load image")
                    return
                }
                
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: UIImage(data: imageData))
                    galleryImageCell.imageView = imageView
                }
            }
        }
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension UIImage {
    var aspectRatio: Double {
        get {
            return Double(size.width/size.height)
        }
    }
}
