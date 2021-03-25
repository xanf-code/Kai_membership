//
//  NewsViewModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import RxSwift

class NewsViewModel {
    
    // MARK: Properties
    var suggestions = [NewRemote]()
    var lastests = [NewRemote]()
    
    // MARK: Methods
    func createData() {
        let sugg1 = NewRemote(with: "s1", title: "KardiaChain X DID Alliance to reinforce the pioneering DID proposition in Vietnam", publicDate: "Today, 27 Nov 2020")
        let sugg2 = NewRemote(with: "s2", title: "Liner Notes: Roky Erickson's 'True Love Cast Out All Evil'", publicDate: "Today, 27 Nov 2020")
        let sugg3 = NewRemote(with: "s3", title: "How Ina Drew Got Swallowed by the London Whale", publicDate: "Today, 27 Nov 2020")
        
        suggestions = [sugg1, sugg2, sugg3]
        
        let last1 = NewRemote(with: "l1", title: "1. Lex Luger Can Write a Hit Rap Song in the Time It Takes to Read This", publicDate: "Wed, 10 Jun 2020")
        let last2 = NewRemote(with: "l2", title: "2. Did Robert Johnson Sell His Soul to the Devil?", publicDate: "Wed, 09 Jun 2020")
        let last3 = NewRemote(with: "l3", title: "3. Lex Luger Can Write a Hit Rap Song in the Time It Takes to Read This", publicDate: "Today, 27 Nov 2020")
        let last4 = NewRemote(with: "l4", title: "4. Lex Luger Can Write a Hit Rap Song in the Time It Takes to Read This", publicDate: "Wed, 10 Jun 2020")
        let last5 = NewRemote(with: "l5", title: "5. Did Robert Johnson Sell His Soul to the Devil?", publicDate: "Wed, 09 Jun 2020")
        let last6 = NewRemote(with: "l6", title: "6. Lex Luger Can Write a Hit Rap Song in the Time It Takes to Read This", publicDate: "Today, 27 Nov 2020")
        
        lastests = [last1, last2, last3, last4, last5, last6]
    }
    
    func getNewsFromTwitter(_ completion: @escaping ((APIResult<[TwitterNews], APIErrorResult>) -> Void)) {
        NewsServices.getNewsFromTwitter(completion)
    }
    
    func getNewsFromMedium(_ completion: @escaping ((APIResult<[MediumNews], APIErrorResult>) -> Void)) {
        NewsServices.getNewsFromMedium(completion)
    }
}
