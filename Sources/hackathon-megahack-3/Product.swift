//
//  Product.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 30/06/20.
//

import Foundation
import ControllerSwift
import PerfectCRUD

struct Product: Codable {
    var id: Int
    var category_id: Int
    var name: String
    var price: String
    var ingredients_details: String?
    var allergic_information: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        self.category_id = try values.decode(Int.self, forKey: .category_id)
        self.name = try values.decode(String.self, forKey: .name)
        self.price = try values.decode(String.self, forKey: .price)
        self.ingredients_details = try? values.decode(String.self, forKey: .ingredients_details)
        self.allergic_information = try? values.decode(String.self, forKey: .allergic_information)
    }
}

extension Product: ControllerSwiftProtocol {
    static func createTable<T: DatabaseConfigurationProtocol>(database: Database<T>) throws {
        try database.sql("DROP TABLE IF EXISTS \(Self.CRUDTableName)")
        try database.sql("""
            CREATE TABLE \(Self.CRUDTableName) (
            id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
            category_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            price TEXT NOT NULL,
            ingredients_details TEXT,
            allergic_information TEXT
            )
            """)
    }
}
