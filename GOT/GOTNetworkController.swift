//
//  GOTNetworkController.swift
//  GOT
//
//  Created by Hari Kishore on 2/8/17.
//  Copyright © 2017 Hari Kishore. All rights reserved.
//

import UIKit

class GOTNetworkController: NSObject {
    
    static let sharedInstance = GOTNetworkController()
    
    func getSeasonEpsodes(season: Int, complete success:@escaping (([Episode]) -> ()) , fail failure:@escaping (NSError) -> ()) -> Void {
        
        if !GOTUtils.sharedInstance.isInternetAvailable() {
            failure(NSError(domain: "Pleaes Connect to Internet", code: 1006, userInfo: [: ]))
            return
        }
        
        let url = URL(string: GOTConstants.kSeasonDetailsURL.appending(String(season)))
        
        self.fireRequest(url: url!, success: { (data) in
            // parse the result as JSON, since that's what the API provides
            do {
                guard let json = try JSONSerialization.jsonObject(with: data as Data, options: []) as? NSDictionary else {
                    GOTUtils.sharedInstance.hideNetworkActivityIndicator()
                    failure(NSError(domain: "error trying to convert data to JSON", code: 1005, userInfo: [:]))
                    return
                }
                
                print("Data : \(json)")
                
                var episodeArray = [Episode]()
                
                if let episodes = json["Episodes"] as? [[String: AnyObject]] {
                    
                    for episode in episodes {
                        let model : Episode = Episode(episodeTitle: (episode["Title"] as? String)!, imdbID: (episode["imdbID"] as? String)!, releaseDate: (episode["Released"] as? String)!, rating: (episode["imdbRating"] as? String)!, episodeNumber: (episode["Episode"] as? String)!)
                        
                        episodeArray.append(model)
                    }
                    GOTUtils.sharedInstance.hideNetworkActivityIndicator()
                    success(episodeArray)
                }
                
            } catch  {
                GOTUtils.sharedInstance.hideNetworkActivityIndicator()
                failure(NSError(domain: "error trying to convert data to JSON", code: 1004, userInfo: [: ]))
                return
            }
        }) { (error) in
            failure(error)
        }
        
    }
    
    func getEpsodeDetails(imdbID: String, complete success:@escaping ((EpisodeDetails) -> ()) , fail failure:@escaping (NSError) -> ()) -> Void {
        
        if !GOTUtils.sharedInstance.isInternetAvailable() {
            failure(NSError(domain: "Pleaes Connect to Internet", code: 1006, userInfo: [: ]))
            return
        }
        
         let url = URL(string: GOTConstants.kEpisodeDetailsURL.replacingOccurrences(of: "@@@@@", with: imdbID))
        
        self.fireRequest(url: url!, success: { (data) in
            // parse the result as JSON, since that's what the API provides
            do {
                guard let json = try JSONSerialization.jsonObject(with: data as Data, options: []) as? NSDictionary else {
                    GOTUtils.sharedInstance.hideNetworkActivityIndicator()
                    failure(NSError(domain: "error trying to convert data to JSON", code: 1005, userInfo: [:]))
                    return
                }
                
                print("Episode Details Data : \(json)")
                
                let episodeDetails = EpisodeDetails(year: json.object(forKey: "Year") as! String, rating: json.object(forKey: "Rated") as! String, releaseDate: json.object(forKey: "Released") as! String, season: json.object(forKey: "Season") as! String, episodeNumber: json.object(forKey: "Episode") as! String, duration: json.object(forKey: "Runtime") as! String)
                
                    GOTUtils.sharedInstance.hideNetworkActivityIndicator()
                    success(episodeDetails)
                
            } catch  {
                GOTUtils.sharedInstance.hideNetworkActivityIndicator()
                failure(NSError(domain: "error trying to convert data to JSON", code: 1004, userInfo: [: ]))
                return
            }
        }) { (error) in
            failure(error)
        }
    }
    
    func fireRequest(url : URL, success:@escaping ((Data) -> ()), fail failure:@escaping ((NSError) -> ())) {
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        GOTUtils.sharedInstance.showNetworkActivityIndicator()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // check for any errors
            guard error == nil else {
                GOTUtils.sharedInstance.hideNetworkActivityIndicator()
                failure(error as! NSError)
                return
            }
            
            // make sure we got data
            guard data != nil else {
                GOTUtils.sharedInstance.hideNetworkActivityIndicator()
                failure(error as! NSError)
                return
            }
            
            success(data!)
        }
        task.resume()
    }
}
