//
//  Movie.swift
//  IMDb
//
//  Created by Aneli  on 18.01.2024.
//

import Foundation

// MARK: - Welcome
struct Movie: Codable {
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case results
    }
}

// MARK: - Result
struct Result: Codable {
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalTitle, overview, title: String
    let posterPath, releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let homepage: String?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case homepage
    }
}
