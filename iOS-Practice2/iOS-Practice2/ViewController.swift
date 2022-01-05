//
//  ViewController.swift
//  iOS-Practice2
//
//  Created by 김동규 on 2022/01/04.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ClickMoveBtn(_ sender: Any) {
        // storyboard find controller
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailController") {
            // move controller
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

