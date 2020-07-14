//
//  APIService.swift
//  MovieGuide
//
//  Created by FIT on 2020/07/10.
//  Copyright © 2020 com.dy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation
import RxAlamofire

class APIService {

    let disposeBag = DisposeBag()
    static let share = APIService()
    
    func movieListUpdate(_ movieType: String, page: Int) -> Observable<[MovieListModel.Result]> {
        // 데이터 생산
        let ob = RxAlamofire
            .requestData(.get, "https://api.themoviedb.org/3/movie/\(movieType)?api_key=588c3d1360999056ac3c7d59dff46fcd&language=ko-KR&page=\(page)")
            .mapObject(type: MovieListModel.self)
            .map { (model: MovieListModel) in
                return model.results
        }

        return ob
    }
    
    func movieSearchUpdate(_ query: String, page: Int) -> Observable<[MovieSearchListModel.Result]> {
        
        let ob = RxAlamofire.requestData(.get, "https://api.themoviedb.org/3/search/movie?api_key=588c3d1360999056ac3c7d59dff46fcd&language=ko-KR&query=\(query)&page=\(page)&include_adult=false")
            .mapObject(type: MovieSearchListModel.self)
            .map { (model: MovieSearchListModel) in
                return model.results
        }
        
        return ob
    }
}






extension ObservableType {

    public func mapObject<T: Codable>(type: T.Type) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            let responseTuple = data as? (HTTPURLResponse, Data)

            guard let jsonData = responseTuple?.1 else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Could not decode object"]
                )
            }

            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: jsonData)

            return Observable.just(object)
        }
    }

    public func mapArray<T: Codable>(type: T.Type) -> Observable<[T]> {
        return flatMap { data -> Observable<[T]> in
            let responseTuple = data as? (HTTPURLResponse, Data)

            guard let jsonData = responseTuple?.1 else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Could not decode object"]
                )
            }

            let decoder = JSONDecoder()
            let objects = try decoder.decode([T].self, from: jsonData)

            return Observable.just(objects)
        }
    }
}
