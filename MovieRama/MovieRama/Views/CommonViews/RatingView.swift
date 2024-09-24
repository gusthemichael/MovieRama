//
//  RatingView.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 21/9/24.
//

import Foundation
import UIKit

class RatingView: UIView {
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(withRating rating: String) {
        ratingLabel.text = rating.formatRating()
    }
    
    private func setupView() {
        self.backgroundColor = .systemYellow
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        
        addSubview(starImageView)
        addSubview(ratingLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            starImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            starImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            starImageView.heightAnchor.constraint(equalToConstant: 16),
            starImageView.widthAnchor.constraint(equalToConstant: 16),
            ratingLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 4),
            ratingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            ratingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.heightAnchor.constraint(equalToConstant: 30),
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
}
