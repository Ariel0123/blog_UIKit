//
//  Post.swift
//  bloguikit
//
//  Created by Ariel Ortiz on 10/17/21.
//

import Foundation


struct Post: Codable{
    let id: Int
    let title: String
    let description: String
    let image: String
    let date: String
}
