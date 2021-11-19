//
//  PostErrors.swift
//  bloguikit
//
//  Created by Ariel Ortiz on 10/23/21.
//

import Foundation


enum PostErrors: Error{
    case title
    
    
    var msgError: String{
        switch self {
        case .title:
            return "Title is required."
        }
    }
}

enum PostErrorsCatch: Error{
    case catchError
    
    var msgError: String{
        switch self {
        case .catchError:
            return "Error from server"
        }
    }
}




struct PostUniversalErrorsMessage: Decodable, Identifiable{
    let id: UUID?
    var title: [String]?
    
    
    init(messageError: [String]){
        self.id = UUID()
        self.title = messageError
    }
}

