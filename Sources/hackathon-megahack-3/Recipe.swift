//
//  Recipe.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 01/07/20.
//

import Foundation
import ControllerSwift
import PerfectCRUD

struct Recipe: Codable {
    var id: Int
    var title: String
    var subtitle: String
    var ingredients: String
    var preparation_mode: String
    var description: String
    var image: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        self.title = try values.decode(String.self, forKey: .title)
        self.subtitle = try values.decode(String.self, forKey: .subtitle)
        self.ingredients = try values.decode(String.self, forKey: .ingredients)
        self.preparation_mode = try values.decode(String.self, forKey: .preparation_mode)
        self.description = try values.decode(String.self, forKey: .description)
        self.image = try? values.decode(String.self, forKey: .image)
    }
}

extension Recipe: ControllerSwiftProtocol {
    static func createTable<T: DatabaseConfigurationProtocol>(database: Database<T>) throws {
        try database.sql("DROP TABLE IF EXISTS \(Self.CRUDTableName)")
        try database.sql("""
            CREATE TABLE \(Self.CRUDTableName) (
            id INTEGER AUTO_INCREMENT PRIMARY KEY UNIQUE,
            title TEXT NOT NULL,
            subtitle TEXT NOT NULL,
            ingredients TEXT NOT NULL,
            preparation_mode TEXT NOT NULL,
            description TEXT NOT NULL,
            image TEXT
            )
            """)
    }
}
