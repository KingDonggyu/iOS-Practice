//
//  ShowActionSheet.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/02/01.
//

import UIKit

func showAlertContoller(vc: UIViewController, style: UIAlertController.Style) {
    let alerContoller: UIAlertController
    alerContoller = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
    
    let handler: (UIAlertAction) -> Void
    handler = { ( action: UIAlertAction) in
        if let str = action.title {
            var type: Int
    
            switch str {
            case "예매율":
                type = 0
            case "큐레이션":
                type = 1
            case "개봉일":
                type = 2
            default:
                type = 0
            }
            
            MovieListType.shared.type = type
            vc.navigationItem.title = MovieListType.shared.title
            requestMovieList(type: type)
        }
    }
    
    let reservationRateSortAction = UIAlertAction(title: "예매율", style: .default, handler: handler)
    
    let curationSortAction = UIAlertAction(title: "큐레이션", style: .default, handler: handler)

    let dateSortAction = UIAlertAction(title: "개봉일", style: .default, handler: handler)
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    
    alerContoller.addAction(reservationRateSortAction)
    alerContoller.addAction(curationSortAction)
    alerContoller.addAction(dateSortAction)
    alerContoller.addAction(cancelAction)
    
    vc.present(alerContoller, animated: true, completion: nil)
}
