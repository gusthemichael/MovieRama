//
//  MovieListViewModel.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 20/9/24.
//

import Foundation
import CoreData


class MovieListViewModel: ObservableObject {
    let repository = Repository.shared
    var selectedMovieId = -1
    var popularMovieList = [MovieObject]()
    @Published var movieDetails: MovieDetailsObject?
    @Published var similarMovies: [MovieObject]?
    @Published var movieReviews: [Review]?
    @Published var dataAreBeingFetched = false
    
    // MARK: API CALLS
    func getPopularMovies(for page: Int, completion: @escaping (_ response: ([MovieObject]?,Error?)) -> Void) {
            self.repository.getMovieList(page: page) { data,error in
                if let responseData = data {
                    completion((responseData.results, nil))
                } else if let errorResponse = error {
                    completion((nil, errorResponse))
                }
            }

    }
    
    func searchForMoview(page: Int,query: String, completion: @escaping (_ response: ([MovieObject]?,Error?)) -> Void) {
        self.repository.searchForMoview(page: page,query: query) { data,error in
            if let responseData = data {
                completion((responseData.results, nil))
            } else if let errorResponse = error {
                completion((nil, errorResponse))
            }
        }
    }
    
    func getMoviewDetails(completion: @escaping (_ response: (MovieDetailsObject?, Error?)) -> Void) {
        self.repository.getMoviewDetails(movieId: selectedMovieId.description) { data,error in
            if let responseData = data {
                completion((responseData, nil))
            } else if let errorResponse = error {
                completion((nil, errorResponse))
            }
        }
    }
    
    func getSimilarMovies(completion: @escaping (_ response: ([MovieObject]?,Error?)) -> Void) {
        self.repository.getSimilarMovies(movieId: selectedMovieId.description) { data,error in
            if let responseData = data {
                completion((responseData.results, nil))
            } else if let resonseError = error {
                completion((nil, resonseError))
            }
            
        }
    }
    
    func getMoviewReviews(completion: @escaping (_ response: ([Review]?, Error?)) -> Void) {
        self.repository.getMoviewReviews(movieId: selectedMovieId.description) { data,error in
            if let responseData = data {
                completion((responseData.results, nil))
            } else if let resonseError = error {
                completion((nil, resonseError))
            }
        }
    }
    
    func makeApiCallsForDetailsView() {
        dataAreBeingFetched = true //This var is used to show a Progress View
        let dispatchGroup = DispatchGroup()
        
        
        dispatchGroup.enter()
        getMoviewDetails { response in
            self.movieDetails = response.0
            dispatchGroup.leave()
            
        }
        
        dispatchGroup.enter()
        getMoviewReviews { response in
            self.movieReviews = response.0
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        getSimilarMovies { response in
            self.similarMovies = response.0
            dispatchGroup.leave()

        }

        dispatchGroup.notify(queue: .main) {
            self.dataAreBeingFetched = false

        }
    }

    // MARK: HELPER FUNCTIONS
    
     func getGenres() -> String {
         var genresString = ""
         if let genres = movieDetails?.genres {
             for genre in genres {
                 genresString.append(" \(genre.name),")
             }
         }
         if !genresString.isEmpty {
             genresString.removeLast()
             genresString.removeFirst()
         }
     
         
         return genresString
     }
     
    func getReviewsCount() -> Int {
        if let movieReviewsList = movieReviews {
            return movieReviewsList.count
        }
        return 0
    }
    
    func getCastNames() -> [String] {
        var castNames = [String]()
        if let castNamesList = movieDetails?.credits.cast {
            let castNamesCount = min(5, castNamesList.count)
            for i in 0...castNamesCount-1  {
                castNames.append(" \(castNamesList[i].name),")

            }
                
        }
        if !castNames.isEmpty {
            castNames[0].removeFirst()
            castNames[castNames.count - 1].removeLast()
        }
        return castNames
    }
    
    // MARK: CORE DATA FUNCTIONS

    func saveMovie(movieId: Int,isFavorite: Bool, completion: @escaping (Bool) -> Void) {
        repository.senfFavorteMovieDummyCall { resonse in
            if resonse {
                let context =  CoreDataStack.shared.managedContext
                let predicate = NSPredicate(format: "movieId == %d", movieId)
                guard let fetchResult = CoreDataStack.shared.fetchEntities(entity: MovieDBObject.self, predicate: predicate, sortDescriptors: nil) else {return}
                //First it is checked if the movie exists in the db so we can udate it's value. If this movie is not in the db we create a new entity
                if !fetchResult.isEmpty {
                    fetchResult.first?.isFavorite = isFavorite
                } else {
                    let newMovie = MovieDBObject(context: context)
                    newMovie.movieId = Int64(movieId)
                    newMovie.isFavorite = isFavorite
                }
                CoreDataStack.shared.saveContext { status in
                    switch status {
                    case .success:
                        completion(true)
                        print("Successfully updated favorite status")
                    case .failed:
                        print("Error saving context")
                        completion(false)
                    }
                }
            }
        }
    }
    
    func checkFavoriteStatus(movieId: Int) -> Bool? {
        let predicate = NSPredicate(format: "movieId == %d", movieId)
        if let fetchResult = CoreDataStack.shared.fetchEntities(entity: MovieDBObject.self, predicate: predicate, sortDescriptors: nil) {
           return fetchResult.first?.isFavorite
        }
        return false
    }
    
}
