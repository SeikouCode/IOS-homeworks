//
//  Person.swift
//  IMDb
//
//  Created by Aneli  on 18.02.2024.
//

import Foundation

struct ActorDetailsModel: Decodable {
    let adult: Bool
    let biography, birthday: String
    let deathday: String?
    let id: Int
    let imdbID, name, placeOfBirth: String
    let profilePath: String?
    var externalIDs: ExternalIDs?

    enum CodingKeys: String, CodingKey {
        case adult
        case biography, birthday, deathday, id
        case imdbID = "imdb_id"
        case name
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case externalIDs = "external_ids"
    }
}

