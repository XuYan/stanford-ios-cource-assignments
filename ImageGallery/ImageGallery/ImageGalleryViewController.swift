//
//  ImageGalleryViewController.swift
//  ImageGallery
//
//  Created by Xu Yan on 3/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

private let imageCellReuseId = "GalleryImageCell"
private let placeholderCellReuseId = "GalleryImagePlaceholderCell"

class ImageGalleryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate {
    var gallery: Gallery!
    private var galleryImageWidth = 300.0
    private var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }

    // MARK: VC life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

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
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: UIImage(data: self.gallery.data(at: indexPath)))
                    imageView.frame = CGRect(x: 0, y: 0, width: Double(self.galleryImageWidth), height: Double(self.galleryImageWidth) / self.gallery.aspectRatio(at: indexPath))
                    galleryImageCell.addSubview(imageView)
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
            var draggedImage: UIImage? = nil
            var draggedUrl: URL? = nil

            let placeholderContext = coordinator.drop(
                item.dragItem,
                to: UICollectionViewDropPlaceholder(
                    insertionIndexPath: destinationIndexPath,
                    reuseIdentifier: placeholderCellReuseId
                )
            )
            let itemProvider = item.dragItem.itemProvider
            itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                if let image = provider as? UIImage {
                    draggedImage = image
                    if draggedUrl != nil {
                        self.onLoadCompleted(
                            context: placeholderContext,
                            url: draggedUrl!,
                            aspectRatio: draggedImage!.aspectRatio
                        )
                    }
                } else {
                    self.onLoadFailed(context: placeholderContext)
                }
            }
            itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                if let url = provider as? URL {
                    draggedUrl = url.imageURL
                    if draggedImage != nil {
                        self.onLoadCompleted(
                            context: placeholderContext,
                            url: draggedUrl!,
                            aspectRatio: draggedImage!.aspectRatio
                        )
                    }
                } else {
                    self.onLoadFailed(context: placeholderContext)
                }
            }
        }
    }

    private func onLoadCompleted(
        context: UICollectionViewDropPlaceholderContext,
        url: URL,
        aspectRatio: Double
    ) {
        guard let data = try? Data(contentsOf: url) else {
            print("Fail to load image")
            return
        }
        let image = GalleryImage(url: url, aspectRatio: aspectRatio, data: data)
        DispatchQueue.main.async {
            context.commitInsertion { insertionIndexPath in
                self.gallery.insert(image, at: insertionIndexPath)
            }
        }
    }

    private func onLoadFailed(context: UICollectionViewDropPlaceholderContext) {
        DispatchQueue.main.async {
            context.deletePlaceholder()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = Double(galleryImageWidth)
        let cellHeight = cellWidth / self.gallery.aspectRatio(at: indexPath)
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
            galleryImageWidth = galleryImageWidth * Double(recognizer.scale)
            collectionView.reloadData()
            flowLayout?.invalidateLayout()
            recognizer.scale = 1.0
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "ShowImageDetail" {
            if let imageDetailVC = segue.destination as? ImageDetailViewController {
                if let galleryImageCell = sender as? GalleryImageCell,
                    let image = (galleryImageCell.subviews[1] as? UIImageView)?.image
                {
                    imageDetailVC.image = image
                }
            }
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let json = self.gallery.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("Untitled.json") {
                do {
                    try json.write(to: url)
                    print("saved successfully")
                } catch let error {
                    print("couldn't save \(error)")
                }
            }
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
