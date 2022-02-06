//
//  MovieListModel.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/01/30.
//

import Foundation

struct MovieList: Codable {
    
    let order_type: Int             // 0: 예매율 (default), 1: 큐레이션, 2: 개봉일
    let movies: [Movie]
}

struct Movie: Codable {
    
    let grade: Int                  // 관람 등급
    let thumb: String               // 포스터 이미지 섬네일 주소
    let reservation_grade: Int      // 예매 순위
    let title: String               // 영화제목
    let reservation_rate: Double    // 예매율
    let user_rating: Double         // 사용자 평점
    let date: String                // 개봉일
    let id: String                  // 영화 고유 ID
    
    var infoLabel: String {
        return "평점 : \(user_rating) 예매순위 : \(reservation_grade) 예매율 : \(reservation_rate)"
    }
    
    var shortInfoLabel: String {
        return "\(reservation_grade)위(\(user_rating)) / \(reservation_rate)%"
    }
    
    var dateLabel: String {
        return "개봉일 : \(date)"
    }
    
    var gradeImageName: String {
        
        switch grade {
        case 0:
            return "ic_allages"
        case 12:
            return "ic_12"
        case 15:
            return "ic_15"
        case 19:
            return "ic_19"
        default:
            return "ic_allages"
        }
    }
}
