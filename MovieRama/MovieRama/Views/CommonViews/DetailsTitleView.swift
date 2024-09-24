//
//  DetailsTitleView.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 23/9/24.
//

import SwiftUI

struct DetailsTitleView: View {
    var text: String
    var body: some View {
        HStack {
            Text(text.uppercased())
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Spacer()
        }
        
    }
}

#Preview {
    DetailsTitleView(text: "Director")
}
