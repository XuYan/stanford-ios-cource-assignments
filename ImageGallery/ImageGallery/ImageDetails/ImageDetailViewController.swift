//
//  ImageDetailViewController.swift
//  ImageGallery
//
//  Created by Xu Yan on 3/25/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(self.imageView)
        }
    }
    
    var imageView = UIImageView()
    var image: UIImage? {
        get {
            return imageView.image
        }

        set {
            imageView.image = newValue
            imageView.frame = CGRect(origin: CGPoint.zero, size: newValue?.size ?? CGSize.zero)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewWidth.constant = scrollView.contentSize.width
        scrollViewHeight.constant = scrollView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageSize = self.image?.size ?? CGSize.zero
        scrollViewWidth.constant = imageSize.width
        scrollViewHeight.constant = imageSize.height
        scrollView.contentSize = imageSize
        if imageSize.width > 0 && imageSize.height > 0 {
            scrollView.zoomScale = max(view.bounds.size.width / imageSize.width, view.bounds.size.height / imageSize.height)
        } else {
            scrollView.zoomScale = 1.0
        }
    }
}
