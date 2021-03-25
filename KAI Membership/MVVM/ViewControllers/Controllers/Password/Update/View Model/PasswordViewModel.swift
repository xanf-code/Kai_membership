//
//  PasswordViewModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 10/03/2021.
//

import RxSwift
import RxRelay

class PasswordViewModel {
    
    // MARK: Life cycle's
    let showLoading = BehaviorRelay<Bool>(value: false)
    
    // MARK: Methods
    func confirmPassword(with token: String, password: String) -> Observable<Void> {
        showLoading.accept(true)
        
        return Observable.create { [weak self] observer -> Disposable in
            UserServices.confirmPassword(with: token, password: password) {
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
    
    func changePassword(password: String, newPassword: String) -> Observable<Void> {
        showLoading.accept(true)
        
        return Observable.create { [weak self] observer -> Disposable in
            UserServices.changePassword(password: password, newPassword: newPassword) {
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
}
