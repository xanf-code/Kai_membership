//
//  SelectAccountViewModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 03/03/2021.
//

import RxSwift

class SelectAccountViewModel {
    
    // MARK: Properties
    private(set) var device: DeviceRemote?
    
    // MARK: Methods
    func getAccountsLoggedIntoDevice() -> Observable<DeviceRemote?> {
        return Observable<DeviceRemote?>.create { (observer) -> Disposable in
            DeviceServices.getAccountsLoggedIntoDevice { [weak self] in
                switch $0 {
                case .success(let result):
                    self?.device = result.data
                    observer.onNext(result.data)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
