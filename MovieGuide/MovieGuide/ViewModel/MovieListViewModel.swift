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
                    self.movieListInVM.onNext([
                        TestBox(movieImg: #imageLiteral(resourceName: "bando"), movieName: "갈갈이", movieDetail: "아주재밌습니다. 좀비가 아주 죽여줘요!  아주재밌습니다. 좀비가 아주 죽여줘요! 아주재밌습니다. 좀비가 아주 죽여줘요! 아주재밌습니다. 좀비가 아주 죽여줘요!", releaseDate: "12/25", movieStar: "별별별별별"),
                        TestBox(movieImg: #imageLiteral(resourceName: "bando"), movieName: "대연의모험", movieDetail: "아주재밌습니다", releaseDate: "12/25", movieStar: "별별별별별"),
                        TestBox(movieImg: #imageLiteral(resourceName: "bando"), movieName: "김또깡", movieDetail: "아주재밌습니다", releaseDate: "12/25", movieStar: "별별별별별"),
                        TestBox(movieImg: #imageLiteral(resourceName: "bando"), movieName: "마영전", movieDetail: "아주재밌습니다", releaseDate: "12/25", movieStar: "별별별별별")
                        ])
                }
                else {
                    self.movieListInVM.onNext([
                        TestBox(movieImg: #imageLiteral(resourceName: "bando"), movieName: "갈갈이", movieDetail: "아주재밌습니다. 좀비가 아주 죽여줘요! 아주재밌습니다. 좀비가 아주 죽여줘요! 아주재밌습니다. 좀비가 아주 죽여줘요! 아주재밌습니다. 좀비가 아주 죽여줘요!", releaseDate: "12/25", movieStar: "별별별별별"),
                        TestBox(movieImg: #imageLiteral(resourceName: "bando"), movieName: "대연의모험", movieDetail: "아주재밌습니다", releaseDate: "12/25", movieStar: "별별별별별"),
                        TestBox(movieImg: #imageLiteral(resourceName: "bando"), movieName: "김또깡", movieDetail: "아주재밌습니다", releaseDate: "12/25", movieStar: "별별별별별"),
                        TestBox(movieImg: #imageLiteral(resourceName: "bando"), movieName: "마영전", movieDetail: "아주재밌습니다", releaseDate: "12/25", movieStar: "별별별별별"),
                        TestBox(movieImg: #imageLiteral(resourceName: "bando"), movieName: "너의이름은", movieDetail: "아주재밌습니다", releaseDate: "12/25", movieStar: "별별별별별"),
                        TestBox(movieImg: #imageLiteral(resourceName: "bando"), movieName: "달파이트", movieDetail: "아주재밌습니다", releaseDate: "12/25", movieStar: "별별별별별")
                        ])
                }
            })
            .disposed(by: disposeBag)
    }
}
