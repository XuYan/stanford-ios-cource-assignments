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
            let size = newValue?.size ?? CGSize.zero
            imageView.image = newValue
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView.contentSize = size
            scrollViewWidth.constant = size.width
            scrollViewHeight.constant = size.height
            if size.width > 0 && size.height > 0 {
                scrollView.zoomScale = max(view.bounds.size.width / size.width, view.bounds.size.height / size.height)
            } else {
                scrollView.zoomScale = 1.0
            }
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewWidth.constant = scrollView.contentSize.width
        scrollViewHeight.constant = scrollView.contentSize.height
    }
}
