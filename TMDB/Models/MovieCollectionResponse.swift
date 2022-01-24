//
//  MovieCollectionResponse.swift
//  TMDB
//
//  Created by BS236 on 11/1/22.
//

import Foundation

struct MovieCollectionResponse: Codable {
    var page: Int
    var results: [Movie]
    let total_pages: Int
    let total_results: Int
}
