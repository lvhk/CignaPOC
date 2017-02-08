//
//  MasterViewController.swift
//  GOT
//
//  Created by Hari Kishore on 2/8/17.
//  Copyright © 2017 Hari Kishore. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UIActionSheetDelegate {
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    var seasonEpisodesArray : [Episode]?
    var seasonsSelectedIndex : Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.loadData(forIndex: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let episode = self.seasonEpisodesArray![indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = episode
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//                controller.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.seasonEpisodesArray != nil) {
            return self.seasonEpisodesArray!.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let episode : Episode = self.seasonEpisodesArray![indexPath.row]
        cell.textLabel!.text = episode.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.seasonEpisodesArray?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Season \(section)"
    //    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width, height: 25))
        label.text = GOTConstants.seasonTitles[seasonsSelectedIndex - 1]
        label.textColor = UIColor(red: 38/255, green: 81/255, blue: 135/255, alpha: 1)
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        returnedView.addSubview(label)
        
        return returnedView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    // MARK: - Data
    
    func loadData(forIndex index:Int) {
        GOTNetworkController.sharedInstance.getSeasonEpsodes(season: index, complete: { (seasonData) in
            self.seasonEpisodesArray = seasonData
            self.reloadTableview()
        }) { (error) in
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    func reloadTableview() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func refreshAction(_ sender: Any) {
        loadData(forIndex: self.seasonsSelectedIndex)
    }
    
    @IBAction func unwind(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func showSeasonsAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Seasons", message: "Please Select a Season", preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor(colorLiteralRed: 30/255, green: 81/255, blue: 135/255, alpha: 1)
        
        
        for name in GOTConstants.seasonTitles {
            
            let action = UIAlertAction(title: name, style: .default, handler: {
                (alertController: UIAlertAction!) -> Void in
                
                self.seasonsSelectedIndex = GOTConstants.seasonTitles.index(of: name)! + 1
                self.loadData(forIndex: self.seasonsSelectedIndex)
            })
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:nil))
        
        self.present(alertController, animated: true, completion: {
            print("completion block")
        })
    }
    
}

extension UIViewController {
    func showAlert(title : String, message : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

