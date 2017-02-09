//
//  DetailViewController.swift
//  GOT
//
//  Created by Hari Kishore on 2/8/17.
//  Copyright © 2017 Hari Kishore. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblRated: UILabel!
    @IBOutlet weak var lblReleased: UILabel!
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var lblEpisode: UILabel!
    @IBOutlet weak var lblRuntime: UILabel!
    @IBOutlet var superView: UIView!
    
    var episodeDetails : EpisodeDetails?
    var progressHUD : ProgressHUD?
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            self.navigationController?.topViewController?.title = detail.title
        }
        
        self.setLoadingIndicator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.loadEpisodeDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        self.showIndicator(show: true, progressHUD: self.progressHUD!)
        
        GOTNetworkController.sharedInstance.getEpsodeDetails(imdbID: (self.detailItem?.imdbID)!, complete: { (episodeDetails) in
            
            print("Episode Details : \(episodeDetails)")
            self.episodeDetails = episodeDetails
            self.setData()
            self.showIndicator(show: false, progressHUD: self.progressHUD!)
            
        }) { (error) in
            self.showIndicator(show: false, progressHUD: self.progressHUD!)
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    func setData() {
        DispatchQueue.main.async {
            self.lblYear.text = self.episodeDetails!.year
            self.lblRated.text = self.episodeDetails!.rating
            self.lblSeason.text = self.episodeDetails!.season
            self.lblEpisode.text = self.episodeDetails!.episode
            self.lblRuntime.text = self.episodeDetails!.duration
            self.lblReleased.text = self.episodeDetails!.releaseDate
        }
    }
    
    func setLoadingIndicator() {
        //setup loading indicator
        progressHUD = ProgressHUD(text: "Loading...")
        self.view.addSubview(progressHUD!)
    }
}

extension UIViewController {
    
    func showIndicator(show: Bool, progressHUD : ProgressHUD) {
        DispatchQueue.main.async {
            if show {
                self.view.backgroundColor = UIColor.lightGray
                progressHUD.show()
            } else {
                self.view.backgroundColor = UIColor.white
                progressHUD.hide()
            }
        }
    }
}
