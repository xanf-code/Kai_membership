//
//  Data+Extensions.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import Foundation

extension Data {

    init<T>(from value: T) {
        var value = value

        self = withUnsafePointer(to: &value) { (ptr: UnsafePointer<T>) -> Data in
            return Data(buffer: UnsafeBufferPointer(start: ptr, count: 1))
        }
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}
