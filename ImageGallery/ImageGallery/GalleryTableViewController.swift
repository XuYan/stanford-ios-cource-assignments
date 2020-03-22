//
//  GalleryTableViewController.swift
//  ImageGallery
//
//  Created by Xu Yan on 3/21/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

class GalleryTableViewController: UITableViewController {
    var app = App(currentGalleries: [ Gallery() ], recentlyDeletedGalleries: [ Gallery() ])

    @IBOutlet weak var tableHeaderLabel: UILabel!
    @IBOutlet weak var addGalleryBtn: UIButton!

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
