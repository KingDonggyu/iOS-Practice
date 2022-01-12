//
//  ThirdViewController.swift
//  SignUp
//
//  Created by 김동규 on 2022/01/12.
//

import UIKit

class ThirdViewController: UIViewController, UIGestureRecognizerDelegate {
    	
    //MARK: Properties
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    //MARK: IBOutlets
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var signUpBtn: UIButton!
    
    // MARK: IBActions
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func touchUpPopToPrevButton(_ sender: UIButton) {
        UserInformation.shared.phoneNumber = phoneNumber.text
        UserInformation.shared.birth = birthLabel.text
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func touchUpSignUpBtn(_ sender: UIButton) {
        UserInformation.shared.registered = true
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didDatePickerValueChanged(_ sender: UIDatePicker) {
        getDateToString()
    }
    
    // MARK: Custom Method
    func getDateToString() {
        let date: Date = datePicker.date
        let dateString: String = dateFormatter.string(from: date)
        birthLabel.text = dateString
    }
    
    func getStringToDate(_ dateString: String) {
        if let date = dateFormatter.date(from: dateString) {
            datePicker.date = date
        }
    }
    
    func initUserInfo() {
        if let text = UserInformation.shared.phoneNumber {
            phoneNumber.text = text
        }
        if let text = UserInformation.shared.birth {
            birthLabel.text = text
            getStringToDate(text)
        } else {
            getDateToString()
        }
    }
    
    func tapGestureSetting() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func userInfoValidation() {
        if phoneNumber.text != "" && birthLabel.text != "" {
            signUpBtn.isEnabled = true
        } else {
            signUpBtn.isEnabled = false
        }
    }
    
    // MARK: Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        userInfoValidation()
        return true
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUserInfo()
        tapGestureSetting()
        userInfoValidation()
        signUpBtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInfoValidation()
    }
}
