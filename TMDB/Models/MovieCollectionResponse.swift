//
//  MovieCollectionResponse.swift
//  TMDB
//
//  Created by BS236 on 11/1/22.
//

import Foundation

struct MovieCollectionResponse: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
