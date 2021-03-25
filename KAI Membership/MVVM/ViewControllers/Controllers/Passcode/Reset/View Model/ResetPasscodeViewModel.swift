//
//  ResetPasscodeViewModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 11/03/2021.
//

import RxSwift

class ResetPasscodeViewModel {
    
    // MARK: Methods
    func requestResetPasscode(with email: String) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            PasscodeServices.requestResetPasscode(with: email) {
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
