//
//  MovieDetailsObject.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 21/9/24.
//

import Foundation

struct MovieDetailsObject: Codable {
    let backdropPath: String?
    let genres: [Genre] // Assuming you might have a Genre struct
    let id: Int
    let overview: String
    let releaseDate: String
    let title: String
    let voteAverage: Double
    let credits: Credits

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genres
        case id
        case overview
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case credits
    }
}

struct Credits: Codable {
    let cast: [Cast]
    let crew: [Crew]
}

struct Genre: Equatable, Codable {
    let name: String
}

struct Cast: Codable {
    let name: String
}



struct Crew: Codable {
    let name: String
    let job: String
}

