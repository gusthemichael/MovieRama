//
//  MovieItemCell.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 20/9/24.
//

import UIKit

class MovieItemCell: UITableViewCell {
    
    static let identifier = "MovieItemCell"
    var favoriteTappedAction: (() -> Void)?

    let movieImageView: UIImageView = {
        return UIImageView()
    }()
    
    let titleLabelView: UILabel = {
        return UILabel()
    }()
    let favoriteImageView: UIImageView = {
        return UIImageView()
    }()
    
    let releaseDateLabelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let ratingsLabelView = RatingView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setupViews() {
        //configure image view

        contentView.addSubview(movieImageView)
        contentView.addSubview(titleLabelView)
        contentView.addSubview(releaseDateLabelView)
        contentView.addSubview(ratingsLabelView)
        contentView.addSubview(favoriteImageView)
        setUpImageView()
        setUpReleaseDateLabelView()
        setUpTitleLabelView()
        setupFavoriteView()
        setUpRatingsView()
        
    }
   

    private func setUpImageView() {
        
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint =   movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        let topConstraint =   movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        let bottomConstraint =   movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        let width = movieImageView.widthAnchor.constraint(equalToConstant: 90)
        NSLayoutConstraint.activate([leadingConstraint, topConstraint, bottomConstraint, width])
        movieImageView.contentMode = .scaleAspectFit

    }
    
    private func setUpTitleLabelView() {
        titleLabelView.numberOfLines = 0
        titleLabelView.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabelView.textColor = .white
        titleLabelView.textAlignment = .right
        titleLabelView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint =   titleLabelView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10)
        let topConstraint =   titleLabelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        let bottomConstraint =   titleLabelView.bottomAnchor.constraint(equalTo: releaseDateLabelView.topAnchor, constant: -10)
        let trailingConstraint = titleLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        NSLayoutConstraint.activate([ leadingConstraint, topConstraint, bottomConstraint, trailingConstraint])

    }
    
    
    private func setUpReleaseDateLabelView() {
      //  releaseDateLabelView.numberOfLines = 0
        releaseDateLabelView.font = UIFont.italicSystemFont(ofSize: 12)
        releaseDateLabelView.textColor = .white
        releaseDateLabelView.textAlignment = .right
        releaseDateLabelView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint =   releaseDateLabelView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10)
        let trailingConstraint = releaseDateLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        let topConstaint = releaseDateLabelView.topAnchor.constraint(equalTo: titleLabelView.bottomAnchor, constant: 0)
   //     let bottomConstraint =   releaseDateLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        NSLayoutConstraint.activate([ leadingConstraint, topConstaint, trailingConstraint])

    }
    
    private func setupFavoriteView() {
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteImageView.tintColor = .red
        favoriteImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        favoriteImageView.addGestureRecognizer(tapGesture)
        
        let topConstraint = favoriteImageView.topAnchor.constraint(equalTo: releaseDateLabelView.bottomAnchor, constant: 10)
        let trailingConstraint = favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        let widthConstraint = favoriteImageView.widthAnchor.constraint(equalToConstant: 34)
        let heightConstraint = favoriteImageView.heightAnchor.constraint(equalToConstant: 34)

        NSLayoutConstraint.activate([topConstraint, trailingConstraint, widthConstraint, heightConstraint])
    }
    
    
    private func setUpRatingsView() {
        ratingsLabelView.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint =   ratingsLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        let trailingConstraint = ratingsLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        NSLayoutConstraint.activate([bottomConstraint, trailingConstraint])

    }
    
    @objc private func favoriteTapped() {
        favoriteTappedAction?()
    }
}
