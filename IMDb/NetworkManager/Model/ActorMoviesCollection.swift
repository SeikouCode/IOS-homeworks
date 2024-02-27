//
//  ActorMoviesCollection.swift
//  IMDb
//
//  Created by Aneli  on 19.02.2024.
//

import Foundation

struct ActorMoviesCollection: Codable {
    let cast: [Result]

    enum CodingKeys: String, CodingKey {
        case cast = "results" 
    }
}


