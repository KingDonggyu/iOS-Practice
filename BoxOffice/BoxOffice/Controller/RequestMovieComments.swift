//
//  RequestMovieComments.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/02/05.
//

import Foundation

let DidReceiveMovieCommentsNoti: Notification.Name = Notification.Name("DidReceiveMovieComments")

func requestMovieComments(id: String) {
    
    guard let url: URL = URL(string: "https://connect-boxoffice.run.goorm.io/comments?movie_id=\(id)") else {
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
            let apiResponse: MovieComments = try JSONDecoder().decode(MovieComments.self, from: data)
            NotificationCenter.default.post(name: DidReceiveMovieCommentsNoti, object: nil , userInfo: ["comments": apiResponse.comments])
        } catch (let err) {
            print(err.localizedDescription)
        }
    }
    
    dataTask.resume()
}

