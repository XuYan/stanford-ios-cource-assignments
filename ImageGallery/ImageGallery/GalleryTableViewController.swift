//
//  GalleryTableViewController.swift
//  ImageGallery
//
//  Created by Xu Yan on 3/21/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

class GalleryTableViewController: UITableViewController, UIGestureRecognizerDelegate, TappableCell {
    @IBOutlet weak var tableHeaderLabel: UILabel!
    @IBOutlet weak var addGalleryBtn: UIButton!
    
    var app = App(currentGalleries: [ Gallery(title: "G1"), Gallery(title: "G2") ], recentlyDeletedGalleries: [])

    override func viewDidLoad() {
        select(at: CURRENTTOP)
    }
    
    private func select(at: IndexPath) {
        tableView.selectRow(at: at, animated: true, scrollPosition: .none)
        performSegue(withIdentifier: "ShowGallery", sender: nil)
    }

    @IBAction func addNewGallery(_ sender: UIButton) {
        app.addNewGallery()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return app.isOperationOnCurrentSection(at: section)
            ? app.currentGalleries.count
            : app.recentlyDeletedGalleries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        if let galleryCell = cell as? TableCellTableViewCell {
            galleryCell.name.isEnabled = false
            galleryCell.name.text = app.gallery(at: indexPath).title
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return app.isOperationOnCurrentSection(at: section) ? "Current" : "Recently Deleted"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let gallery = app.removeGallery(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if app.isOperationOnCurrentSection(at: indexPath) {
                app.addToRecentlyDeletedGalleries(gallery)
                tableView.insertRows(at: [DELETETOP], with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if app.isOperationOnCurrentSection(at: indexPath) {
            return nil
        }

        let action = UIContextualAction(style: .normal, title: "undelete") { (action, view, completionHandler) in
            let gallery = self.app.removeGallery(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.app.addToCurrentGalleries(gallery)
            tableView.insertRows(at: [CURRENTTOP], with: .automatic)
            
            completionHandler(true)
        }
        
        
        return UISwipeActionsConfiguration(actions: [action])
    }

    func cellSingleTapped() {
        performSegue(withIdentifier: "ShowGallery", sender: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ShowGallery", let indexPath = tableView.indexPathForSelectedRow {
            return app.isOperationOnCurrentSection(at: indexPath)
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("here")
        if segue.identifier == "ShowGallery" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let gallery = app.getCurrentGallery(at: indexPath) {
                    if let galleryVC = segue.destination as? ImageGalleryViewController {
                        galleryVC.gallery = gallery
                    }
                }
            }
        }
    }
}
