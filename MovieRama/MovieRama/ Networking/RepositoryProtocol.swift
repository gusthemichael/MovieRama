//
//  NetworkProtocol.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 19/9/24.
//

import Foundation

//This is used so we can create mock up requests for testing
protocol RepositoryProtocol {
    func getMovieList(page: Int, completion: @escaping((data: MovieListData?, error: Error?)) -> Void)
    func searchForMoview(page: Int, query: String, completion: @escaping((data: MovieListData?, error: Error?)) -> Void)
    func getMoviewDetails(movieId: String, completion: @escaping((data: MovieDetailsObject?, error: Error?)) -> Void)
    func getMoviewReviews(movieId: String, completion: @escaping((data: ReviewObject?, error: Error?)) -> Void)
    func getSimilarMovies(movieId: String, completion: @escaping((data: MovieListData?, error: Error?)) -> Void)
    func senfFavorteMovieDummyCall(completion: @escaping(Bool) -> Void)
}
