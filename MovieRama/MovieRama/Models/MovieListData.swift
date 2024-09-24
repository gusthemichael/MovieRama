//
//  MovieListData.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 19/9/24.
//

import Foundation


struct MovieListData: Codable {
    let page: Int
    let results: [MovieObject]
    let totalPages: Int
    let totalResults: Int
    //the use of coding keys is so that all variables conform to camel case
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
