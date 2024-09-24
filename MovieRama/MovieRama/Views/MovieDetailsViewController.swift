//
//  MovieDetailsViewController.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 21/9/24.
//

import UIKit
import SwiftUI

class MovieDetailsViewController: UIViewController {
    var viewModel: MovieListViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingController = UIHostingController(rootView: MovieDetailsView(viewModel: viewModel!))
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}
