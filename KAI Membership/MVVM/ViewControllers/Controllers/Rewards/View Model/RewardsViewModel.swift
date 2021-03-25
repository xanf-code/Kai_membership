//
//  RewardsViewModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 11/03/2021.
//

import RxSwift

class RewardsViewModel {
    
    // MARK: Properties
    private(set) var histories = [HistoryRemote]()
    
    // MARK: Methods

    // TODO: Get histories
    func getHistories() -> Observable<[HistoryRemote]> {
        return Observable<[HistoryRemote]>.create { [weak self] observer -> Disposable in
            UserServices.getHistories() {
                switch $0 {
                case .success(let result):
                    self?.histories = result.datas
                    observer.onNext(result.datas)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
