//
//  ProfileViewModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 14/03/2021.
//

import RxSwift

class ProfileViewModel {
    
    // MARK: Methods
    func getAccountsLoggedIntoDevice() -> Observable<DeviceRemote?> {
        return Observable<DeviceRemote?>.create { (observer) -> Disposable in
            DeviceServices.getAccountsLoggedIntoDevice {
                switch $0 {
                case .success(let result):
                    observer.onNext(result.data)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getUserInfo() -> Observable<AccountInfoRemote> {
        return Observable<AccountInfoRemote>.create { (observer) -> Disposable in
            AccountManagement.getInfoUser {
                switch $0 {
                case .success(let result):
                    observer.onNext(result)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func requestChangePassword() -> Observable<Void> {
        let email = AccountManagement.email
        
        return Observable.create { (observer) -> Disposable in
            UserServices.requestChangePassword(with: email) {
                switch $0 {
                case .success:
                    observer.onNext(())
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func updateAvatar(_ image: UIImage) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            AccountManagement.updateAvatar(image) {
                switch $0 {
                case .success:
                    observer.onNext(())
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
