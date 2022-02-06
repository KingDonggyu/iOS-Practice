//
//  MovieDetailModel.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/02/03.
//

import Foundation

struct MovieDetail: Codable {
    
    let audience: Int               // 총 관람객수
    let actor: String               // 배우진
    let duration: Int               // 영화 상영 길이
    let director: String            // 감독
    let synopsis: String            // 줄거리
    let genre: String               // 영화 장르
    let grade: Int                  // 관람등급
    let image: String               // 포스터 이미지 주소
    let reservation_grade: Int      // 예매순위
    let title: String               // 영화제목
    let reservation_rate: Double    // 예매율
    let user_rating: Double         // 사용자 평점
    let date: String                // 개봉일
    let id: String                  // 영화 고유 ID
    
}
