//
//  Genres.swift
//  IMDb
//
//  Created by Aneli  on 18.01.2024.
//

import Foundation

struct Genre: Decodable {
    var id: Int
    var name: String
}

struct GenresEntity: Decodable {
    let genres: [Genre]
}

