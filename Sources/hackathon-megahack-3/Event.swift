//
//  Event.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 01/07/20.
//

import Foundation
import ControllerSwift
import PerfectCRUD

struct Event: Codable {
    var id: Int
    var title: String
    var subtitle: String
    var description: String
    var date: String
    var latitude: Float?
    var longitude: Float?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        self.title = try values.decode(String.self, forKey: .title)
        self.subtitle = try values.decode(String.self, forKey: .subtitle)
        self.description = try values.decode(String.self, forKey: .description)
        self.date = try values.decode(String.self, forKey: .date)
        self.latitude = try? values.decode(Float.self, forKey: .latitude)
        self.longitude = try? values.decode(Float.self, forKey: .longitude)
    }
}

extension Event: ControllerSwiftProtocol {
    static func createTable<T: DatabaseConfigurationProtocol>(database: Database<T>) throws {
        try database.sql("DROP TABLE IF EXISTS \(Self.CRUDTableName)")
        try database.sql("""
            CREATE TABLE \(Self.CRUDTableName) (
            id INTEGER AUTO_INCREMENT PRIMARY KEY UNIQUE,
            title TEXT NOT NULL,
            subtitle TEXT NOT NULL,
            description TEXT NOT NULL,
            date TEXT NOT NULL,
            latitude FLOAT,
            longitude FLOAT
            )
            """)
    }
}
