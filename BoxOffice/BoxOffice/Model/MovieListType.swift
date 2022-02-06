//
//  MovieListType.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/02/01.
//

import Foundation

// MARK: - Singleton
class MovieListType {
    static let shared: MovieListType = MovieListType()
    
    var type: Int = 0
    var title: String {
        switch type {
        case 0:
            return "예매율순"
        case 1:
            return "큐레이션순"
        case 2:
            return "개봉일순"
        default:
            return "예매율순"
        }
    }
}
