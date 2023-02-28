//
//  Cast.swift
//  movieApp
//
//  Created by Ertürk Alan on 19.02.2023.
//

import Foundation

struct Cast: Decodable {
    let id: Int
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePath = "profile_path"
    }
}

struct CastResponse: Decodable {
    let id: Int
    let cast: [Cast]
}
