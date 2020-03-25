//
//  TableCellTableViewCell.swift
//  ImageGallery
//
//  Created by Xu Yan on 3/24/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

class TableCellTableViewCell: UITableViewCell, UITextFieldDelegate {
    private var singleTap: UITapGestureRecognizer!
    private var doubleTap: UITapGestureRecognizer!
    var tapDelegate: TappableCell?

    @IBOutlet weak var name: UITextField! {
        didSet {
            name.delegate = self
        }
    }
    
    override func awakeFromNib() {
        self.registerGestures()
    }

    private func registerGestures() {
        self.singleTap = UITapGestureRecognizer(target: self, action: #selector(self.onSingleTapped(recognizer:)))
        self.singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        self.addGestureRecognizer(self.singleTap)
        
        self.doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.onDoubleTapped(recognizer:)))
        self.doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        self.addGestureRecognizer(self.doubleTap)
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == self.singleTap && otherGestureRecognizer == self.doubleTap
    }

    @objc private func onSingleTapped(recognizer: UITapGestureRecognizer) {
        self.tapDelegate?.cellSingleTapped()
    }
    
    @objc private func onDoubleTapped(recognizer: UITapGestureRecognizer) {
        self.name.isEnabled = true
        self.name.becomeFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.name.resignFirstResponder()
        self.name.isEnabled = false
        self.tapDelegate?.onEditCompleted(cell: self)
        return true
    }
}

protocol TappableCell {
    func cellSingleTapped()
    func onEditCompleted(cell: TableCellTableViewCell)
}
