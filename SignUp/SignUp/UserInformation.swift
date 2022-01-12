//
//  UserInformation.swift
//  SignUp
//
//  Created by 김동규 on 2022/01/12.
//

import Foundation

// MARK: Singleton
class UserInformation {
    static let shared: UserInformation = UserInformation()
    
    var id: String?
    var pwd: String?
    var introduction: String?
    var phoneNumber: String?
    var birth: String?
    var registered: Bool = false
}
