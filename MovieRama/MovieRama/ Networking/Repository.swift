//
//  Repository.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 20/9/24.
//

import Foundation

final class Repository: RepositoryProtocol {
    
    static let shared = Repository()
    
    func getMoviewDetails(movieId: String, completion: @escaping ((data: MovieDetailsObject?, error: Error?)) -> Void) {
        NetworkService.shared.apiGetRequest(urlPath: "\(ConstantsStrings.baseURL)/\(movieId)?append_to_response=credits", responseDecodeType: MovieDetailsObject.self) { response in
            completion((response.data,response.error))
        }
    }
    
    func searchForMoview(page: Int, query: String, completion: @escaping ((data: MovieListData?, error: Error?)) -> Void) {
        NetworkService.shared.apiGetRequest(urlPath: "\(ConstantsStrings.baseURL)?query=\(query)&page=\(page)", responseDecodeType: MovieListData.self) { response in
            completion((response.data,response.error))
        }
    }
    

    func getMovieList(page: Int, completion: @escaping ((data: MovieListData?, error: Error?)) -> Void) {
        NetworkService.shared.apiGetRequest(urlPath: "\(ConstantsStrings.baseURL)/popular?page=\(page)", responseDecodeType: MovieListData.self) { response in
            completion((response.data,response.error))
        }
    }
    
    func getMoviewReviews(movieId: String, completion: @escaping ((data: ReviewObject?, error: Error?)) -> Void) {
        NetworkService.shared.apiGetRequest(urlPath: "\(ConstantsStrings.baseURL)/\(movieId)/revi@ews", responseDecodeType: ReviewObject.self) { response in
            completion((response.data,response.error))
        }
    }
    
    func getSimilarMovies(movieId: String, completion: @escaping ((data: MovieListData?, error: Error?)) -> Void) {
        NetworkService.shared.apiGetRequest(urlPath: "\(ConstantsStrings.baseURL)/\(movieId)/simil@ar", responseDecodeType: MovieListData.self) { response in
            completion((response.data,response.error))
        }
    }
    
    func senfFavorteMovieDummyCall(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {   // Simulate the delay a real call would have
               let randomBool = Bool.random()
                completion(randomBool)
           }
    }
    
    
}
