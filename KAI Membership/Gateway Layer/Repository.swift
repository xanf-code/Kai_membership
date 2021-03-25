//
//  Repository.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/02/2021.
//

import Foundation

protocol RepositoryProtocol {
    
    associatedtype T
    
    func save(_ item: T)
    func load() -> T?
}

class Repository<T>: RepositoryProtocol {
    
    // MARK: Properties
    let repository: Repository?
    
    // MARK: Life cycle's
    init(repository: Repository? = nil) {
        self.repository = repository
    }
    
    // MARK: Methods
    func save(_ item: T) {
        fatalError("concrete classes should implement this method")
    }
    
    func load() -> T? {
        fatalError("concrete classes should implement this method")
    }
}
