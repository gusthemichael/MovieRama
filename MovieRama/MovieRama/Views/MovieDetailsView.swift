//
//  MovieDetailsView.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 21/9/24.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieListViewModel
    @State var isFavoriteMovie: Bool = false
    var body: some View {
        GeometryReader { metrics in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    ZStack {
                        if let imageUrl = viewModel.movieDetails?.backdropPath {
                            URLImage(urlString: "\(ConstantsStrings.baseImageURL)\(imageUrl)")
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    .frame(width: metrics.size.width
                            , height: 200)
                    .padding(.vertical)
                    
                    Text(viewModel.movieDetails?.title ?? "")
                        .font(.system(size: 26))
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    Text(viewModel.getGenres())
                        .font(.system(size: 14))
                        .padding(.horizontal)
                    
                    HStack {
                        VStack(alignment: .leading,spacing: 5) {
                            Text(viewModel.movieDetails?.releaseDate.formatDate() ?? "")
                                .foregroundColor(.gray)
                            StarRatingView(rating: viewModel.movieDetails?.voteAverage ?? 0.0)
                        }
                        Spacer()
                        Image(systemName: isFavoriteMovie ? "heart.fill" : "heart")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                viewModel.saveMovie(movieId: viewModel.selectedMovieId, isFavorite: !isFavoriteMovie) { completion in
                                    if completion {
                                        isFavoriteMovie.toggle()
                                    }
                                }
                                    
                            }
                    }
                    .padding(.horizontal)
                    
                    DetailsTitleView(text: "\(ConstantsStrings.description)")
                        .padding(.horizontal)
                    
                    Text(viewModel.movieDetails?.overview ?? "")
                        .padding(.horizontal)
                    
                    DetailsTitleView(text: "\(ConstantsStrings.director)")
                        .padding(.horizontal)
                    
                    Text(viewModel.movieDetails?.credits.crew.first?.name ?? "")
                        .padding(.horizontal)
                    
                    DetailsTitleView(text: "\(ConstantsStrings.cast)")
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.getCastNames(), id: \.self) { string in
                                Text(string)
                            }
                        }
                    }.padding(.horizontal)
                    
                    DetailsTitleView(text: "\(ConstantsStrings.similarMoviews)").padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            if let similarMovies = viewModel.similarMovies {
                                ForEach(similarMovies, id: \.self) { movie in
                                    if let imageUrl = movie.posterPath {
                                        URLImage(urlString: "\(ConstantsStrings.baseImageURL)\(imageUrl)")
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(15)
                                            .shadow(color: .gray, radius: 5, x: 2, y: 2)
                                            .frame(width:180
                                                   , height: 200)
                                    }
                                }
                            }
                            
                        }
                    }
                    DetailsTitleView(text: "\(ConstantsStrings.reviews)").padding(.horizontal)
                    
                    let reviewsCount = min(2, viewModel.getReviewsCount())
                    ForEach(0..<reviewsCount, id: \.self) { index in
                        Text(viewModel.movieReviews?[index].author ?? "")
                            .padding(.horizontal)
                        
                        Text(viewModel.movieReviews?[index].content ?? "")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                    }
                    
                    
                    
                }
            }
        }
        .onAppear() {
            viewModel.makeApiCallsForDetailsView()
            if let isFavoriteStatus =  viewModel.checkFavoriteStatus(movieId: viewModel.selectedMovieId) {
                isFavoriteMovie = isFavoriteStatus 
            }
        }
        .onDisappear(perform: {
            viewModel.movieDetails = nil
        })
    }
}

#Preview {
    MovieDetailsView(viewModel: MovieListViewModel())
}


