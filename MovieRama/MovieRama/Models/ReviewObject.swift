//
//  ReviewObject.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 21/9/24.
//

import Foundation

struct ReviewObject: Codable {
    let results: [Review]
}

struct Review: Codable {
    let author: String
    let content: String
}

