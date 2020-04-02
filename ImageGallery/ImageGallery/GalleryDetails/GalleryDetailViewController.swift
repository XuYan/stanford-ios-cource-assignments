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

class GalleryDetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate, UICollectionViewDragDelegate {
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
        self.collectionView.dragDelegate = self
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
                let url = self.gallery.url(at: indexPath)
                guard let data = try? Data(contentsOf: url) else {
                    DispatchQueue.main.async {
                        self.showAlert(for: url)
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        galleryImageCell.imageView.image = image
                    } else {
                        galleryImageCell.imageView.image = UIImage(named: "frowny-face")
                    }
                }
            }
        }
    
        return cell
    }
    
    private func showAlert(for url: URL) {
        print("Fail to load image at \(url)")
        let alertController = UIAlertController(title: "Data fails to load", message:
            "check your network connectivity", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        present(alertController, animated: true)
    }
    
    // MARK: UICollectionDropDelegate
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isFromSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        if isFromSelf {
            return true
        }
        return gallery != nil && session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isFromSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isFromSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: self.gallery.images.count, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                // this drag item comes from the collection view itself
                collectionView.performBatchUpdates({
                    gallery.move(from: sourceIndexPath, to: destinationIndexPath)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            } else {
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
    }
    
    // MARK: UICollectionViewDragDelegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItem(at: indexPath)
    }
    
    private func dragItem(at indexPath: IndexPath) -> [UIDragItem] {
        if let _ = gallery.image(at: indexPath) {
            let dragItem = UIDragItem(itemProvider: NSItemProvider())
            dragItem.localObject = indexPath.item
            return [dragItem]
        } else {
            return []
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
