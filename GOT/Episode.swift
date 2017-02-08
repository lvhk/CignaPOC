//
//  Episode.swift
//  GOT
//
//  Created by Hari Kishore on 2/8/17.
//  Copyright © 2017 Hari Kishore. All rights reserved.
//

import UIKit

class Episode: NSObject {
    
    var title: String?
    var imdbID: String?
    var releaseDate: String?
    var rating: String?
    var episode: String?
    
    init(episodeTitle: String, imdbID: String, releaseDate: String, rating: String, episodeNumber: String) {
        self.title = episodeTitle;
        self.imdbID = imdbID;
        self.releaseDate = releaseDate;
        self.rating = rating;
        self.episode = episodeNumber;
    }
}
