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

    var fetchList: Observable<[TestBox]> { get }
    var segmentChange: AnyObserver<Int> { get }
    
}

class MovieListViewModel: MovieListViewModelType {

    let disposeBag = DisposeBag()

    let segChangeInVM = PublishSubject<Int>()
    let movieListInVM = BehaviorSubject<[TestBox]>(value: [])

    var fetchList: Observable<[TestBox]>
    
    var pageList = [TestBox]()
    var pageIndex: Int = 0

    var segmentChange: AnyObserver<Int>

    //2. 옵저버로 만듬

    init() {
        fetchList = movieListInVM.asObservable()
        segmentChange = segChangeInVM.asObserver()
    
        //3. 서브젝트를 구독하여 값변경 -> 리스트를 변환시켜줘야함
        segChangeInVM
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
        APIService.share.movieListUpdate(category, page: pageIndex)
        .map { list in
            return list.map { result in
                
                TestBox(movieImg: result.posterURL,
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
            self.movieListInVM.onNext(self.pageList)
        })
        .disposed(by: self.disposeBag)
    }

}
