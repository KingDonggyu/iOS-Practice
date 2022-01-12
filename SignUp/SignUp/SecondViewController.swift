//
//  SecondViewController.swift
//  SignUp
//
//  Created by 김동규 on 2022/01/12.
//

import UIKit
import Mantis

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, CropViewControllerDelegate {
    
    // MARK: Properties
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var checkPwd: UITextField!
    @IBOutlet weak var introduction: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: IBActions
    @IBAction func touchUpSelectImageView(_ sender: UITapGestureRecognizer) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pushToNext(_ sender: UIButton) {
        UserInformation.shared.id = id.text
        UserInformation.shared.pwd = pwd.text
    }
    
    @IBAction func popToPrev(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Custom Method
    func imageViewTapGestureSetting() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.touchUpSelectImageView))
        
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapGesture)
    }
    
    func placeholderSetting() {
        introduction.delegate = self
        introduction.text = "Introduce yourself"
        introduction.textColor = UIColor.lightGray
    }
    
    func tapGestureSetting() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func userInfoValidation() {
        if id.text != "" && pwd.text != "" && checkPwd.text != "" && introduction.text != "" {
            if pwd.text == checkPwd.text && introduction.text != "Introduce yourself" {
                nextButton.isEnabled = true
            }
        } else {
            nextButton.isEnabled = false
        }
    }
    
    // MARK: Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        let imageCropViewController = Mantis.cropViewController(image: originalImage!)
        imageCropViewController.modalPresentationStyle = .fullScreen
        imageCropViewController.delegate = self
        self.present(imageCropViewController, animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Introduce yourself"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        userInfoValidation()
        return true
    }
    
    // MARK: Protocol
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        imageView.image = cropped
        self.dismiss(animated: true, completion: nil)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pwd.isSecureTextEntry = true
        checkPwd.isSecureTextEntry = true
        nextButton.isEnabled = false
        imageViewTapGestureSetting()
        placeholderSetting()
        tapGestureSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInfoValidation()
    }
}
