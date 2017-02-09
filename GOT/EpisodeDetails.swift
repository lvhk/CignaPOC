//
//  EpisodeDetails.swift
//  GOT
//
//  Created by Hari Kishore on 2/8/17.
//  Copyright © 2017 Hari Kishore. All rights reserved.
//

import UIKit

class EpisodeDetails: NSObject {
    
    var year: String?
    var rating: String?
    var releaseDate: String?
    var season: String?
    var episode: String?
    var duration: String?
    
    init(year: String, rating: String, releaseDate: String, season: String, episodeNumber: String, duration: String) {
        self.year = year;
        self.rating = rating;
        self.releaseDate = releaseDate;
        self.season = season;
        self.episode = episodeNumber;
        self.duration = duration
    }
}
