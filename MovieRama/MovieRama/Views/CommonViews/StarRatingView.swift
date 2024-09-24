//
//  StarRatingView.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 23/9/24.
//

import SwiftUI

struct StarRatingView: View {
    var rating: Double

    

    var body: some View {
        HStack {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: self.starType(for: index))
                    .foregroundColor(.blue)
            }
        }
    }
    // this function returns the correct system image string based on movie rating
    private func starType(for index: Int) -> String {
        let threshold = Double(index) + 0.5
        let newRating = rating/2
        if newRating >= Double(index + 1) {
            return "star.fill" // Full star
        } else if newRating >= threshold {
            return "star.leadinghalf.filled" // Half star
        } else {
            return "star" // Empty star
        }
    }
}
