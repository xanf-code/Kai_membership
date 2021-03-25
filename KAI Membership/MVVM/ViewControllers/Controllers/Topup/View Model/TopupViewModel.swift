//
//  TopupViewModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import RxSwift

class TopupViewModel {
    
    // MARK: Properties
    let serviceProviders = AppSetting.serviceProviders
    
    var phoneNumber: String = ""
    var amount: Amount = Amount(money: 20000, kai: 66.6666)
    var serviceProviderIndex: Int = 0
    
    // MARK: Methods
}
