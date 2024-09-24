//
//  ViewController.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 19/9/24.
//

import UIKit
import Kingfisher

class MainMovieListViewController: UIViewController {
    
    private let searchTextField = UITextField()
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let movieListViewModel = MovieListViewModel()
    private var popularMovieList = [MovieObject]()
    private var oldMovieList = [MovieObject]()
    private var page = 1
    private var searchPage = 1
    var isFetching = false
    var searchQuery = ""
    var isRefreshingList = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIForTableView()
        setUpRefresher()
        loadMovies(page: page)
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() //this is used so i can get the updated favorite status
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = tableView.bounds
        gradientLayer.colors = [UIColor.purple.cgColor,UIColor.blue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        tableView.backgroundView = backgroundView
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            if let destinationVC = segue.destination as? MovieDetailsViewController {
                // Create a new view model with the selected movie
                destinationVC.viewModel = movieListViewModel
            }
        }
    }

    private func setUpRefresher() {
        refreshControl.attributedTitle = NSAttributedString(string: "\(ConstantsStrings.updatingMovies)")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    private func setupUIForTableView() {
        // Setup searchTextField
        view.backgroundColor = UIColor.purple
        searchTextField.placeholder = "\(ConstantsStrings.searchField)"
        searchTextField.borderStyle = .roundedRect
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        view.addSubview(searchTextField)
        
        // Setup tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MovieItemCell.identifier, bundle: nil), forCellReuseIdentifier: MovieItemCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Add Constraints
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        //tableView.separatorStyle = .none
        
    }
    
    private func loadMovies(page: Int) {
        if !isFetching { //this var is used to prevent a fetch request while another is in progress
            self.isFetching = true
            movieListViewModel.getPopularMovies(for: page) {response in
                if let newData = response.0 {
                    self.isRefreshingList ?  self.popularMovieList = newData : self.popularMovieList.append(contentsOf: newData) //inCaseUserRefreshing the list it must be replaced
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing() //this is used for pull down refresh
                        self.isRefreshingList = false
                        self.isFetching = false
                    }
                }
            }
        }
        
    }
    
    private func searchMovies(searchPage: Int) {
        if !isFetching {
            self.isFetching = true
            movieListViewModel.searchForMoview(page: searchPage, query: searchQuery) { response in
                if let newData = response.0 {
                    self.popularMovieList.append(contentsOf: newData)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.isFetching = false
                    }
                }
            }
        }
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        page = Int.random(in: 1...500)
        isRefreshingList = true
        loadMovies(page: page)
    }
    @objc private func searchTextChanged() {
        /*This is used to recover old movie list when user stops searching for a movie*/
        if oldMovieList.isEmpty {
            oldMovieList = popularMovieList
        }
        guard let query = searchTextField.text, !query.isEmpty else {
            // Clear results if the search field is empty
            popularMovieList = oldMovieList
            oldMovieList.removeAll() //in case user makes a new search
            tableView.reloadData()
            return
        }
        searchQuery = query
        self.popularMovieList.removeAll()
        // Make API call
        searchMovies(searchPage: searchPage)
    }
  
}

extension MainMovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.popularMovieList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        movieListViewModel.selectedMovieId = popularMovieList[indexPath.row].id
        self.performSegue(withIdentifier: "details", sender: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieItemCell.identifier) as? MovieItemCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        if popularMovieList.count >= indexPath.row {
            let movieInfoForCell = self.popularMovieList[indexPath.row]
            configureCell(cell, with: movieInfoForCell, at: indexPath)
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if popularMovieList.count - 1 == indexPath.row {
            if !searchQuery.isEmpty { //if the user is searching then a different endpoint must be used so the search query is checked
                searchPage = searchPage + 1
                searchMovies(searchPage: searchPage)
            } else {
                page = page + 1
                loadMovies(page: page)
            }
           //     print("fetch data")
               
        }
    }
    private func configureCell(_ cell: MovieItemCell, with movie: MovieObject, at indexPath: IndexPath) {
        // Set up the image with Kingfisher
        if let imagePosterUrlPath = movie.posterPath {
            let imageUrl = "\(ConstantsStrings.baseImageURL)\(imagePosterUrlPath)"
            let url = URL(string: "\(imageUrl)")
            
            let roundCorner = RoundCornerImageProcessor(radius: .widthFraction(0.1), roundingCorners: [.all])
            let pngSerializer = FormatIndicatedCacheSerializer.png
            cell.movieImageView.kf.setImage(with: url, options: [.processor(roundCorner), .cacheSerializer(pngSerializer)])
        }
        
        // Check favorite status
        let isMovieFavorite = movieListViewModel.checkFavoriteStatus(movieId: movie.id) ?? false
        cell.favoriteImageView.image = UIImage(systemName: isMovieFavorite ? "heart.fill" : "heart")
        
        // Configure other cell details
        cell.backgroundColor = .clear
        cell.titleLabelView.text = movie.title
        cell.releaseDateLabelView.text = "\(ConstantsStrings.releaseDate) \(movie.releaseDate)"
        cell.ratingsLabelView.configure(withRating: movie.voteAverage.description)
        
        //the reason the tap is handled here is to avoid moving view model in every cell
        cell.favoriteTappedAction = { [weak self] in
            self?.movieListViewModel.saveMovie(movieId: movie.id, isFavorite: !isMovieFavorite) { _ in
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
}




