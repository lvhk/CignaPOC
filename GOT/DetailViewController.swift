//
//  DetailViewController.swift
//  GOT
//
//  Created by Hari Kishore on 2/8/17.
//  Copyright © 2017 Hari Kishore. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.title
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.loadEpisodeDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Episode? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func loadEpisodeDetails() {
        GOTNetworkController.sharedInstance.getEpsodeDetails(imdbID: (self.detailItem?.imdbID)!, complete: { (episodeDetails) in
            
            print(episodeDetails)
            
        }) { (error) in
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
}

