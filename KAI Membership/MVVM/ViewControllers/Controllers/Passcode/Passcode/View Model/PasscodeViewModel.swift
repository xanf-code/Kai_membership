//
//  PasscodeViewModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import RxSwift
import RxRelay

class PasscodeViewModel {
    
    // MARK: Properties
    let email: String
    
    let showLoading = BehaviorRelay<Bool>(value: false)
    
    // MARK: Life cycle's
    init(email: String) {
        self.email = email
    }
    
    // MARK: Methods
    func loginWithPasscode(_ passcode: String) -> Observable<Void> {
        let email = self.email
        
        showLoading.accept(true)
        return Observable<Void>.create { [weak self] observer -> Disposable in
            AccountManagement.loginWithPascode(with: email, and: passcode) {
                switch $0 {
                case .success:
                    observer.onNext(())
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
                
                self?.showLoading.accept(false)
            }
            
            return Disposables.create()
        }
    }
    
    func createPasscode(_ passcode: String) -> Observable<Void> {
        let email = self.email
        showLoading.accept(true)
        
        return Observable<Void>.create { [weak self] (observer) -> Disposable in
            PasscodeServices.createPasscode(with: email, passcode: passcode) {
                switch $0 {
                case .success:
                    observer.onNext(())
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            self?.showLoading.accept(false)
            
            return Disposables.create()
        }
    }
    
    func checkPasscode(_ passcode: String) -> Observable<Void> {
        showLoading.accept(true)
        
        return Observable<Void>.create { (observer) -> Disposable in
            PasscodeServices.checkPasscode(passcode) {
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
    
    func requestChangePassword() -> Observable<Void> {
        let email = self.email
        
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
    
    func resetPasscode(token: String, passcode: String) -> Observable<Void> {
        let email = self.email
        
        return Observable.create { (observer) -> Disposable in
            PasscodeServices.resetPasscode(token: token, passcode: passcode, email: email) {
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
