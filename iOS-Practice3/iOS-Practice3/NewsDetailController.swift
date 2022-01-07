//
//  NewsDetailController.swift
//  iOS-Practice3
//
//  Created by 김동규 on 2022/01/07.
//

import UIKit

class NewsDetailController: UIViewController {
    
    @IBOutlet weak var ImageMain: UIImageView!
    @IBOutlet weak var LabelMain: UILabel!
    
    var head: String?
    var imageUrl: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = head
        
        if let img = imageUrl {
            if let data = try? Data(contentsOf: URL(string: img)!) {
                // Main Thread 이용 - Data는 backgoround
                DispatchQueue.main.async {
                    self.ImageMain.image = UIImage(data: data)
                }
            }
        }
        
        if let d = desc {
            self.LabelMain.text = d
        }
    }
}
