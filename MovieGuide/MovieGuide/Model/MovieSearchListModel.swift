//
//  MovieSearchListModel.swift
//  MovieGuide
//
//  Created by FIT on 2020/07/14.
//  Copyright © 2020 com.dy. All rights reserved.
//

import Foundation

// MARK: - MovieSearchListModel
struct MovieSearchListModel: Codable {
    let page, totalResults, totalPages: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
    
    // MARK: - Result
    struct Result: Codable {
        let popularity: Double
        let voteCount: Int
        let video: Bool
        let posterPath: String?
        let id: Int
        let adult: Bool
        let backdropPath: String?
        let originalLanguage, originalTitle: String
        let genreIDS: [Int]
        let title: String
        let voteAverage: Double
        let overview, releaseDate: String
        var posterURL: URL {
            return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
        }
        enum CodingKeys: String, CodingKey {
            case popularity
            case voteCount = "vote_count"
            case video
            case posterPath = "poster_path"
            case id, adult
            case backdropPath = "backdrop_path"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case genreIDS = "genre_ids"
            case title
            case voteAverage = "vote_average"
            case overview
            case releaseDate = "release_date"
        }
    }

}
