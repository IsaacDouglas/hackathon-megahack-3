//
//  Advertisement.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 30/06/20.
//

import Foundation
import ControllerSwift
import PerfectCRUD

struct Advertisement: Codable {
    var id: Int
    var uuid: String
    var title: String
    var description: String
    var url: String
    var image: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        self.uuid = (try? values.decode(String.self, forKey: .uuid)) ?? UUID().uuidString
        self.title = try values.decode(String.self, forKey: .title)
        self.description = try values.decode(String.self, forKey: .description)
        self.url = try values.decode(String.self, forKey: .url)
        self.image = try values.decode(String.self, forKey: .image)
    }
}

extension Advertisement: ControllerSwiftProtocol {
    static func createTable<T: DatabaseConfigurationProtocol>(database: Database<T>) throws {
        try database.sql("DROP TABLE IF EXISTS \(Self.CRUDTableName)")
        try database.sql("""
            CREATE TABLE \(Self.CRUDTableName) (
            id INTEGER AUTO_INCREMENT PRIMARY KEY UNIQUE,
            uuid TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            url TEXT,
            image TEXT
            )
            """)
    }
}
