//
//  ExternalIDs.swift
//  IMDb
//
//  Created by Aneli  on 05.02.2024.
//

import Foundation

struct ExternalIDs: Codable {
    let id: Int
    let imdbId: String?
    let instagramId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imdbId = "imdb_id"
        case instagramId = "instagram_id"
    }
}
