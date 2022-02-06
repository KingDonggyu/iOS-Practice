//
//  ActivityIndicator.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/02/04.
//

import UIKit

func addActivityIndicator(vc: UIViewController) -> UIActivityIndicatorView {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        
        // Create an indicator.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = vc.view.center
        activityIndicator.color = UIColor.gray
        // Also show the indicator even when the animation is stopped.
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        activityIndicator.startAnimating()
        
        return activityIndicator
    }()
    
   return activityIndicator
}



