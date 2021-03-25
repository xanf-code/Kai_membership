//
//  UpdateProfileViewModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 10/03/2021.
//

import RxSwift

class UpdateProfileViewModel {
    
    // MARK: Properties
    private let fullNameDefault: String
    private let birthdayDefault: Double?
    private let phoneNumberDefault: String
    
    var fullName: String = ""
    var birthday: Double?
    var phoneNumber: String = ""
    
    var hasChanged: Bool {
        if let birthdayDefault = self.birthdayDefault {
            return !fullName.isEmpty && !phoneNumber.isEmpty && (fullName != fullNameDefault || phoneNumber != phoneNumberDefault || birthday != birthdayDefault)
        } else {
            return !fullName.isEmpty && !phoneNumber.isEmpty && (fullName != fullNameDefault || phoneNumber != phoneNumberDefault)
        }
    }
    
    // MARK: Life cycle's
    init(fullName: String? = nil, birthday: Double? = nil, phoneNumber: String? = nil) {
        self.fullNameDefault = fullName ?? ""
        self.birthdayDefault = birthday
        self.phoneNumberDefault = phoneNumber ?? ""
        
        self.fullName = self.fullNameDefault
        self.birthday = self.birthdayDefault
        self.phoneNumber = self.phoneNumberDefault
    }
    
    // MARK: Methods
    func udpateProfile() -> Observable<AccountInfoRemote> {
        let birthday = self.birthday
        let name = self.fullName
        let phoneNumber = self.phoneNumber
        
        return Observable<AccountInfoRemote>.create { (observer) -> Disposable in
            AccountManagement.updateUserInfomation(name: name, phoneNumber: phoneNumber, birthday: birthday) {
                switch $0 {
                case .success(let accountInfo):
                    observer.onNext(accountInfo)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
