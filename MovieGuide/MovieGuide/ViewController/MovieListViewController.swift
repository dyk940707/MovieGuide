//
//  MovieListViewController.swift
//  MovieGuide
//
//  Created by FIT on 2020/07/08.
//  Copyright © 2020 com.dy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class MovieListViewController: UIViewController {

    @IBOutlet weak var listSeg: UISegmentedControl!
    @IBOutlet weak var listTableView: UITableView!
    
    let movieListViewModel: MovieListViewModelType = MovieListViewModel(apiService: AFAPIService.share)
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        input()
        output()
    }

    func output() {
        movieListViewModel
            .updateMovieList
            .bind(to: listTableView.rx.items(cellIdentifier: "Cell", cellType: MovieListTableViewCell.self)) { row, element, cell in

            cell.movieImageView.kf.setImage(with: element.movieImg)
            cell.movieNameLabel.text = element.movieName
            cell.movieDetailLabel.text = element.movieDetail
            cell.releaseDateLabel.text = element.releaseDate
            cell.movieStarLabel.text = element.movieStar
        }
            .disposed(by: disposeBag)
    }
    
    func input() {
        listSeg.rx.selectedSegmentIndex
        .bind(to: movieListViewModel.segmentChange)
        .disposed(by: disposeBag)
    }
}

extension MovieListViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height

            if offsetY > contentHeight - scrollView.frame.height
            {
                self.movieListViewModel.loadMovieList(category: "now_playing", forceUpdate: false)
            }
    }
}
