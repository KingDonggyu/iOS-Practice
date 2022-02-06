//
//  MovieCommentsModel.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/02/05.
//

import Foundation

struct MovieComments: Codable {
    let comments: [MovieComment]
}

struct MovieComment: Codable {
    let writer: String
    let rating: Double
    let timestamp: Double
    let movie_id: String
    let id: String
    let contents: String
}
