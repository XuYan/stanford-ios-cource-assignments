//
//  GalleryDetailViewController.swift
//  ImageGallery
//
//  Created by Xu Yan on 3/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

private let imageCellReuseId = "GalleryImageCell"
private let placeholderCellReuseId = "GalleryImagePlaceholderCell"

class GalleryDetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate {
    // MARK: - Properties
    var gallery: Gallery!
    private var cellWidth: CGFloat!
    private var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }

    // MARK: VC life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellWidth = view.frame.width / 3
        self.collectionView.dropDelegate = self
        registerGestures()
    }
    
    // MARK: CollectionView delegate methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gallery == nil {
            return 0
        }
        return gallery.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellReuseId, for: indexPath)
        if let galleryImageCell = cell as? GalleryImageCell {
            DispatchQueue.global(qos: .userInitiated).async {
                guard let data = try? Data(contentsOf: self.gallery.url(at: indexPath)) else {
                    print("Fail to load image")
                    return
                }
                DispatchQueue.main.async {
                    galleryImageCell.imageView.image = UIImage(data: data)
                }
            }
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return gallery != nil && session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: self.gallery.images.count, section: 0)
        for item in coordinator.items {
            let placeholderContext = coordinator.drop(
                item.dragItem,
                to: UICollectionViewDropPlaceholder(
                    insertionIndexPath: destinationIndexPath,
                    reuseIdentifier: placeholderCellReuseId
                )
            )
            let itemProvider = item.dragItem.itemProvider
            itemProvider.loadObject(ofClass: UIImage.self) { (imgProvider, error) in
                itemProvider.loadObject(ofClass: NSURL.self) { (urlProvider, error) in
                    DispatchQueue.main.async {
                        if let image = imgProvider as? UIImage, let url = urlProvider as? URL {
                            placeholderContext.commitInsertion { insertionIndexPath in
                                self.gallery.insert(GalleryImage(url: url.imageURL, aspectRatio: image.aspectRatio), at: insertionIndexPath)
                            }
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = cellWidth / CGFloat(gallery.aspectRatio(at: indexPath))
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    private func registerGestures() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale(recognizer:)))
        collectionView.addGestureRecognizer(pinchGesture)
    }

    @objc private func scale(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            cellWidth = cellWidth * recognizer.scale
            collectionView.reloadData()
            flowLayout?.invalidateLayout()
            recognizer.scale = 1.0
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImageDetail",
            let imageDetailVC = segue.destination as? ImageDetailViewController,
            let galleryImageCell = sender as? GalleryImageCell
        {
            imageDetailVC.image = galleryImageCell.imageView.image
        }
    }
}

extension UIImage {
    var aspectRatio: Double {
        get {
            return Double(size.width/size.height)
        }
    }
}
