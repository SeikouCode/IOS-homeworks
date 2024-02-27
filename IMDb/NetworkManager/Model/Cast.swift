//
//  Cast.swift
//  IMDb
//
//  Created by Aneli  on 05.02.2024.
//

import Foundation

struct CastEntity: Codable {
    let id: Int
    let cast, crew: [CastElement]
}
struct CastElement: Codable {
    let adult: Bool
    let gender, id: Int
    let name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, job
    }
}
