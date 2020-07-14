//
//  MovieSearchViewModel.swift
//  MovieGuide
//
//  Created by FIT on 2020/07/08.
//  Copyright © 2020 com.dy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

protocol MovieSearchViewModelType {
    
}

class MovieSearchViewModel: MovieSearchViewModelType {
    
    let disposeBag = DisposeBag()
    
    /// 검색 스트림
    let searchChangeSubject = PublishSubject<String>()
    /// 검색결과 리스트 스트림
    let movieListSubject = PublishSubject<[TestBox]>()
    
    var updateList: Observable<[TestBox]>
    
    var searchPageList = [TestBox]()
    var searchPageIndex: Int = 0
    
    var searchChange: AnyObserver<String>
    
    
    init() {
        updateList = movieListSubject.asObservable() // updateList 이벤트에 서브젝트의 이벤트형태를 넣음
        searchChange = searchChangeSubject.asObserver() // searchange라는 옵저버에 서브젝트의 옵저버 형태를 넣음
        
        searchChangeSubject
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] query in
                self.searchMovie(query: query, firstUpdate: true)
        })
        .disposed(by: disposeBag)
    }
    
    /// Movie검색 함수
    func searchMovie(query: String, firstUpdate: Bool) {
        /// 검색하고 스크롤 되기전까지 데이터 로드
        if firstUpdate {
            searchPageList = []
            searchPageIndex = 0
        }
        /// Scroll시 인덱스를 증가시켜 다음 페이지 정보 API Call
        searchPageIndex += 1
        
        APIService.share.movieSearchUpdate(query, page: searchPageIndex)
        .map { list in
                return list.map { result in
                    TestBox(movieImg: result.posterURL,
                    movieName: result.originalTitle,
                    movieDetail: result.overview,
                    releaseDate: result.releaseDate,
                    movieStar: "\(result.voteAverage)")
                }
            }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext:{ list in
            self.searchPageList.append(contentsOf: list)
            self.movieListSubject.onNext(self.searchPageList)
            
        })
        .disposed(by: disposeBag)
    }
    
}
