//
//  RequestMovieDetail.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/02/03.
//

import Foundation

let DidReceiveMovieDetailNoti: Notification.Name = Notification.Name("DidReceiveMovieDetail")

func requestMovieDetail(id: String) {
    guard let url: URL = URL(string: "https://connect-boxoffice.run.goorm.io/movie?id=\(id)") else {
        return
    }
    
    let session: URLSession = URLSession(configuration: .default)
    
    let dataTask: URLSessionDataTask = session.dataTask(with: url) {
        (data: Data?, response: URLResponse?, error: Error?) in
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let data = data else {
            return
        }
        
        do {
            let apiResponse: MovieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
            NotificationCenter.default.post(name: DidReceiveMovieDetailNoti, object: nil , userInfo: ["movieDetail": apiResponse])
        } catch (let err) {
            print(err.localizedDescription)
        }
    }
    
    dataTask.resume()
}
