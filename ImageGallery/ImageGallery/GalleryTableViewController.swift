//
//  GalleryTableViewController.swift
//  ImageGallery
//
//  Created by Xu Yan on 3/21/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

class GalleryTableViewController: UITableViewController {
    var app = App(currentGalleries: [ Gallery(title: "G1"), Gallery(title: "G2") ], recentlyDeletedGalleries: [])

    @IBOutlet weak var tableHeaderLabel: UILabel!
    @IBOutlet weak var addGalleryBtn: UIButton!
    
    override func viewDidLoad() {
        select(at: IndexPath(row: 0, section: 0))
    }
    
    private func select(at: IndexPath) {
        tableView.selectRow(at: at, animated: true, scrollPosition: .none)
        performSegue(withIdentifier: "ShowGallery", sender: at)
    }

    @IBAction func addNewGallery(_ sender: UIButton) {
        app.addNewGallery()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0
            ? app.currentGalleries.count
            : app.recentlyDeletedGalleries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        cell.textLabel?.text = app.gallery(at: indexPath).title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Current" : "Recently Deleted"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let gallery = app.removeGallery(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if indexPath.section == 0 {
                app.addToRecentlyDeletedGalleries(gallery)
                tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
