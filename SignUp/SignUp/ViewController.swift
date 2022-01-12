//
//  ViewController.swift
//  SignUp
//
//  Created by 김동규 on 2022/01/11.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var idTextField: UITextField!
    
    // MARK: Custom Method
    func initUserInformatino() {
        if UserInformation.shared.registered {
            idTextField.text = UserInformation.shared.id
        } else {
            UserInformation.shared.id = nil
            UserInformation.shared.pwd = nil
            UserInformation.shared.phoneNumber = nil
            UserInformation.shared.birth = nil
        }
    }
    
    func tapGestureSetting() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // MARK: Life Cylcle
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initUserInformatino()
    }
}

