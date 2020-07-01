//
//  Restaurant.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 01/07/20.
//

import Foundation
import ControllerSwift
import PerfectCRUD

struct Restaurant: Codable {
    var id: Int
    var name: String
    var description: String
    var image: String?
    var latitude: Float?
    var longitude: Float?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        self.name = try values.decode(String.self, forKey: .name)
        self.description = try values.decode(String.self, forKey: .description)
        self.image = try? values.decode(String.self, forKey: .image)
        self.latitude = try? values.decode(Float.self, forKey: .latitude)
        self.longitude = try? values.decode(Float.self, forKey: .longitude)
    }
}

extension Restaurant: ControllerSwiftProtocol {
    static func createTable<T: DatabaseConfigurationProtocol>(database: Database<T>) throws {
        try database.sql("DROP TABLE IF EXISTS \(Self.CRUDTableName)")
        try database.sql("""
            CREATE TABLE \(Self.CRUDTableName) (
            id INTEGER AUTO_INCREMENT PRIMARY KEY UNIQUE,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            image TEXT,
            latitude FLOAT,
            longitude FLOAT
            )
            """)
    }
}
