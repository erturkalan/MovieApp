//
//  Genre.swift
//  movieApp
//
//  Created by Ertürk Alan on 18.02.2023.
//

import Foundation
import RealmSwift


class Genre: Object, Decodable {
    @objc dynamic var id: Int
    @objc dynamic var name: String
}

struct GenreResponse: Decodable {
    let genres: [Genre]
}
