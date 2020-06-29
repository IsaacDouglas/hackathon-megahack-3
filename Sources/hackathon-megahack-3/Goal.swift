//
//  Goal.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 29/06/20.
//

import Foundation
import ControllerSwift
import PerfectCRUD

struct Goal: Codable {
    var id: Int
    var title: String
    var description: String
    var minimumPoints: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case minimumPoints = "minimum_points"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        self.title = try values.decode(String.self, forKey: .title)
        self.description = try values.decode(String.self, forKey: .description)
        self.minimumPoints = try values.decode(Int.self, forKey: .minimumPoints)
    }
}

extension Goal: ControllerSwiftProtocol {
    static func createTable<T: DatabaseConfigurationProtocol>(database: Database<T>) throws {
        try database.sql("DROP TABLE IF EXISTS \(Self.CRUDTableName)")
        try database.sql("""
            CREATE TABLE \(Self.CRUDTableName) (
            id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            minimum_points INTEGER NOT NULL
            )
            """)
    }
}
