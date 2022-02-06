//
//  RequestMovieInfo.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/01/30.
//

import Foundation

let DidReceiveMovieListNoti: Notification.Name = Notification.Name("DidReceiveMovieList")

func requestMovieList(type: Int) {
    
    guard let url: URL = URL(string: "https://connect-boxoffice.run.goorm.io/movies?order_type=\(type)") else {
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
            let apiResponse: MovieList = try JSONDecoder().decode(MovieList.self, from: data)
            NotificationCenter.default.post(name: DidReceiveMovieListNoti, object: nil, userInfo: ["movies":apiResponse.movies])
        } catch (let err) {
            print(err.localizedDescription)
        }
    }
    
    dataTask.resume()
}
