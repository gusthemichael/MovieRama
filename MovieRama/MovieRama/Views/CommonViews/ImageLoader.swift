//
//  ImageLoader.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 23/9/24.
//

import Foundation
import Combine
import SwiftUI

struct URLImage: View {
    let urlString: String
    @State private var image: UIImage? = nil

    var body: some View {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ZStack{}
                    .onAppear {
                        loadImage()
                    }
            }
    }

    private func loadImage() {
        guard let url = URL(string: urlString) else { return }
        
        // Fetch image from URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            }
        }.resume()
    }
}
