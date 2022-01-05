//
//  DetailController.swift
//  iOS-Practice2
//
//  Created by 김동규 on 2022/01/05.
//

import UIKit
import WebKit

class DetailController: UIViewController {
    @IBOutlet weak var WebViewMain: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 1. url string
        // 2. url > request
        // 3. req > load
        
        let urlString = "https://www.google.com"
        if let url = URL(string: urlString) {  // unwrap - 옵셔널 바인딩
            let urlReq = URLRequest(url: url)
            WebViewMain.load(urlReq)
        }
    }
}
