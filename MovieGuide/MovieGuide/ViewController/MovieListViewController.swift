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

struct TestBox {
    let movieImg: URL
    let movieName: String
    let movieDetail: String
    let releaseDate: String
    let movieStar: String
}

class MovieListViewController: UIViewController {

    @IBOutlet weak var listSeg: UISegmentedControl!
    @IBOutlet weak var listTableView: UITableView!

    var movieListViewModel: MovieListViewModel = MovieListViewModel()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        binding()
    }

    func binding() {
        // output
        movieListViewModel.fetchList.bind(to: listTableView.rx.items(cellIdentifier: "Cell", cellType: MovieListTableViewCell.self)) { row, element, cell in

            cell.movieImageView.kf.setImage(with: element.movieImg)
            cell.movieNameLabel.text = element.movieName
            cell.movieDetailLabel.text = element.movieDetail
            cell.releaseDateLabel.text = element.releaseDate
            cell.movieStarLabel.text = element.movieStar
        }
            .disposed(by: disposeBag)

        // 1. segControl 받음 뷰모델의 세그먼트체인지가 구독하게 함.

        // input
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
                print(self.movieListViewModel.pageIndex)
                
            }
    }
}
