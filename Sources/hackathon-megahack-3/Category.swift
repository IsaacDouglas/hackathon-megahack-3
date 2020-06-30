//
//  Category.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 30/06/20.
//

import Foundation
import ControllerSwift
import PerfectCRUD

struct Category: Codable {
    var id: Int
    var title: String
    var subtitle: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        self.title = try values.decode(String.self, forKey: .title)
        self.subtitle = try values.decode(String.self, forKey: .subtitle)
    }
}

extension Category: ControllerSwiftProtocol {
    static func createTable<T: DatabaseConfigurationProtocol>(database: Database<T>) throws {
        try database.sql("DROP TABLE IF EXISTS \(Self.CRUDTableName)")
        try database.sql("""
            CREATE TABLE \(Self.CRUDTableName) (
            id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
            title TEXT NOT NULL,
            subtitle TEXT
            )
            """)
    }
}
