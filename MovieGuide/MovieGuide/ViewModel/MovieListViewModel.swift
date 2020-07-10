//
//  MovieListViewModel.swift
//  MovieGuide
//
//  Created by FIT on 2020/07/08.
//  Copyright © 2020 com.dy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieListViewModelType {


    var fetchList: Observable<[TestBox]> { get }
    var segmentChange: AnyObserver<Int> { get }
}

class MovieListViewModel: MovieListViewModelType {

    let disposeBag = DisposeBag()

    let segChangeInVM = BehaviorSubject<Int>(value: 0)
    let movieListInVM = BehaviorSubject<[TestBox]>(value: [])

    var fetchList: Observable<[TestBox]>
    var segmentChange: AnyObserver<Int>

    //2. 옵저버로 만듬

    init() {
        fetchList = movieListInVM.asObservable()
        segmentChange = segChangeInVM.asObserver()

        //3. 서브젝트를 구독하여 값변경 -> 리스트를 변환시켜줘야함
        segChangeInVM
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] index in

                if index == 1 {
                    self.loadMovieList(category: "popular")


                }
                else {
                    self.loadMovieList(category: "upcoming")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func loadMovieList(category: String) {
        APIService.share.movieListUpdate(category)
        .map { list in
            return list.map { result in
                TestBox(movieImg: #imageLiteral(resourceName: "bando"),
                        movieName:result.originalTitle,
                        movieDetail: result.overview,
                        releaseDate: result.releaseDate,
                        movieStar: "\(result.voteAverage)") }

        }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { list in
            self.movieListInVM.onNext(list)
        })
        .disposed(by: self.disposeBag)
    }
}
