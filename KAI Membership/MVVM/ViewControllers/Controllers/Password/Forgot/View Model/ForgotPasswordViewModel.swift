//
//  ForgotPasswordViewModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 10/03/2021.
//

import RxSwift

class ForgotPasswordViewModel {
    
    // MARK: Methods
    func requestChangePassword(with email: String) -> Observable<Void> {
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
}
