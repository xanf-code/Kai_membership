//
//  UserDataSource.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/02/2021.
//

import RxSwift

class UserRemoteDataSource {
    
    class func get() -> Observable<UserRemote> {
        return Observable<UserRemote>.create({ (observer) -> Disposable in
            // Can hoan chinh
            
            return Disposables.create()
        })
    }
    
    // Saves the Object data into Realm
    class func save(_ remote: UserRemote) {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let object = remote.toDataLocal()
                
                RealmServices.shared.create(object)
            }
        }
    }
}

class UserLocalDataSource {
    
    // Fetches the data from Realm and returns an Object
    class func get(with uuid: String) -> UserLocal? {
        let localData = RealmServices.shared.get(ofType: UserLocal.self, forPrimaryKey: uuid)
        
        return localData
    }
    
    // Saves the Object data into Realm
    class func save(_ object: UserLocal) {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                RealmServices.shared.create(object)
            }
        }
    }
}
