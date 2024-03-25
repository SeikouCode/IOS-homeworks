//
//  Video.swift
//  IMDb
//
//  Created by Aneli  on 18.01.2024.
//

import Foundation

struct VideoEntity: Decodable {
    var results: [Video]
}

struct Video: Decodable {
    var key: String?
    var site: String?
}
