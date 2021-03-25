//
//  OverviewViewModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import RxSwift
import RxRelay

class OverviewViewModel {
    
    // MARK: Properties
    let amount: Amount
    let address: String
    let phoneNumber: String
    let providerCode: String
    
    let showLoading = BehaviorRelay<Bool>(value: false)
    
    // MARK: Life cycle's
    init(address: String, amount: Amount) {
        self.address = address
        self.amount = amount
        self.phoneNumber = ""
        self.providerCode = ""
    }
    
    init(phoneNumber: String, providerCode: String, amount: Amount) {
        self.address = ""
        self.phoneNumber = phoneNumber
        self.providerCode = providerCode
        self.amount = amount
    }
    
    // MARK: Methods
    func createTopup() -> Observable<Void> {
        let phone = self.phoneNumber
        let providerCode = self.providerCode
        let money = self.amount.money
        
        showLoading.accept(true)
        return Observable.create { [weak self] observer -> Disposable in
            TransactionServices.topup(phoneNumber: phone, providerCode: providerCode, amount: money) {
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
    
    func createSend() -> Observable<Void> {
        let walletAddress = self.address
        let kai = self.amount.kai
        
        showLoading.accept(true)
        return Observable.create { [weak self] observer -> Disposable in
            AccountManagement.sendKAI(walletAddress: walletAddress, kai: kai) {
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
