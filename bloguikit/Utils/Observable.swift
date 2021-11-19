//
//  Observable.swift
//  bloguikit
//
//  Created by Ariel Ortiz on 10/23/21.
//

import Foundation

class Observable<T> {

    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }

    private var listener: ((T?) -> Void)?

   

    func bind(_ closure: @escaping (T?) -> Void) {
        closure(value)
        self.listener = closure
    }
}
