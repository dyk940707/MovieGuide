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
import Kingfisher


protocol MovieListViewModelType {
    
    var updateMovieList: Observable<[CustomMovieModel]> { get }
    var segmentChange: AnyObserver<Int> { get }

    func loadMovieList(category: String, forceUpdate: Bool)
}

class MovieListViewModel: MovieListViewModelType {

    private let disposeBag = DisposeBag()

    private let apiService: APIService
    
    private let segChangeSubject = PublishSubject<Int>()
    private let movieListSubject = BehaviorSubject<[CustomMovieModel]>(value: [])

    var updateMovieList: Observable<[CustomMovieModel]>
    
    private var pageList = [CustomMovieModel]()
    private var pageIndex: Int = 0

    var segmentChange: AnyObserver<Int>

    //2. 옵저버로 만듬

    init(apiService: APIService) {
        self.apiService = apiService
        
        updateMovieList = movieListSubject.asObservable()
        segmentChange = segChangeSubject.asObserver()
    
        //3. 서브젝트를 구독하여 값변경 -> 리스트를 변환시켜줘야함
        segChangeSubject
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] index in

                if index == 0 {
                    print("Start")
                    self.loadMovieList(category: "now_playing", forceUpdate: true)
                }
                else if index == 1 {
                    self.loadMovieList(category: "popular", forceUpdate: true)
                }
                else {
                    self.loadMovieList(category: "upcoming", forceUpdate: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func loadMovieList(category: String, forceUpdate: Bool) {
        
        if forceUpdate {
            pageIndex = 0
            pageList = []
        }
        
        pageIndex += 1
        apiService.movieListUpdate(category, page: pageIndex)
        .map { list in
            return list.map { result in
                
                CustomMovieModel(movieImg: result.posterURL,
                        movieName:result.originalTitle ?? "",
                        movieDetail: result.overview ?? "",
                        releaseDate: result.releaseDate ?? "",
                        movieStar: "\(result.voteAverage!)") }

        }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { list in
            print(self.pageList.count)
            print(list.count)
            self.pageList.append(contentsOf: list)
            self.movieListSubject.onNext(self.pageList)
        })
        .disposed(by: self.disposeBag)
    }

}
