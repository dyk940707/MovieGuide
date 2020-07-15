//
//  MovieSearchViewController.swift
//  MovieGuide
//
//  Created by FIT on 2020/07/08.
//  Copyright © 2020 com.dy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MovieSearchViewController: UIViewController {


    @IBOutlet weak var searchTableView: UITableView!

    let disposeBag = DisposeBag()
    let movieSearchViewModel: MovieSearchViewModelType = MovieSearchViewModel(apiService: AFAPIService.share)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        input()
        output()
        searchTableView.delegate = self
    }

    /** SearchBar Setting */
    private func setupNavigationBar() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        self.definesPresentationContext = true
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = true

        navigationItem.searchController?.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func input() {
        
        self.navigationItem.searchController?.searchBar
            .rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: movieSearchViewModel.searchChange)
            .disposed(by: disposeBag)
    }
    
    private func output() {
        
        movieSearchViewModel.updateList.bind(to: searchTableView.rx.items(cellIdentifier: "Cell", cellType: MovieSearchTableViewCell.self)) { row, element, cell in

            cell.movieImageView.kf.setImage(with: element.movieImg)
            cell.movieNameLabel.text = element.movieName
            cell.movieDetailLabel.text = element.movieDetail
            cell.releaseDateLabel.text = element.releaseDate
            cell.movieStarLabel.text = element.movieStar
        }
            .disposed(by: disposeBag)
    }
}

extension MovieSearchViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height
        {
            self.movieSearchViewModel.searchMovie(
                query: self.navigationItem.searchController?.searchBar.text ?? "",
                firstUpdate: false)
        }
    }
    
}
