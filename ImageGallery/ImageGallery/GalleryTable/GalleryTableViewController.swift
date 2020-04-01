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
    
    var app = App(currentGalleries: [], recentlyDeletedGalleries: [])

    // MARK: VC life cycle methods
    override func viewDidLoad() {
        if app.currentGalleries.count == 0 {
            addNewGallery()
        }
        select(at: CURRENTTOP)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    private func select(at: IndexPath) {
        tableView.selectRow(at: at, animated: true, scrollPosition: .none)
        performSegue(withIdentifier: "ShowGallery", sender: nil)
    }

    @IBAction func addNewGallery(_ sender: UIButton? = nil) {
        app.addNewGallery()
        tableView.reloadSections(IndexSet(integer: CURRENTTOP.section), with: .automatic)
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
        if let galleryCell = cell as? GalleryTableCell {
            galleryCell.name.isEnabled = false
            galleryCell.name.text = app.gallery(at: indexPath).title
            galleryCell.tapDelegate = self
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if app.isOperationOnCurrentSection(at: section) {
            if app.currentGalleries.count > 0 {
                return "Current"
            }
        } else {
            if app.recentlyDeletedGalleries.count > 0 {
                return "Recently Deleted"
            }
        }
        return nil
    }
    
    // MARK: Delete and Undelete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if !app.isOperationOnCurrentSection(at: indexPath) {
                _ = app.removeGallery(at: indexPath)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                tableView.performBatchUpdates({
                    app.addToRecentlyDeletedGalleries(app.removeGallery(at: indexPath))
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [DELETETOP], with: .automatic)
                })
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if app.isOperationOnCurrentSection(at: indexPath) {
            return nil
        }

        let action = UIContextualAction(style: .normal, title: "undelete") { (action, view, completionHandler) in
            tableView.performBatchUpdates({
                self.app.addToCurrentGalleries(self.app.removeGallery(at: indexPath))
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.insertRows(at: [CURRENTTOP], with: .automatic)
            }) { success in
                completionHandler(success)
            }
        }
        
        
        return UISwipeActionsConfiguration(actions: [action])
    }

    // MARK: TappableCell protocol
    func cellSingleTapped() {
        performSegue(withIdentifier: "ShowGallery", sender: nil)
    }

    func onEditCompleted(cell: GalleryTableCell) {
        let tableView = self.view as! UITableView
        if let indexPath = tableView.indexPath(for: cell) {
            self.app.updateGalleryTitle(at: indexPath, newTitle: cell.name.text)
        }
    }
    
    // MARK: segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ShowGallery", let indexPath = tableView.indexPathForSelectedRow {
            return app.isOperationOnCurrentSection(at: indexPath)
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGallery" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let gallery = app.getCurrentGallery(at: indexPath) {
                    if let navVC = segue.destination as? UINavigationController, let galleryVC = navVC.topViewController as? GalleryDetailViewController {
                        galleryVC.gallery = gallery
                    }
                }
            }
        }
    }
}
