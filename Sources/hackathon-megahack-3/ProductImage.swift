//
//  ProductImage.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 30/06/20.
//

import Foundation
import ControllerSwift
import PerfectCRUD

struct ProductImage: Codable {
    var id: Int
    var product_id: Int
    var name: String
    var size: Double
    var url: String
    var created_at: Date
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        self.product_id = try values.decode(Int.self, forKey: .product_id)
        self.name = try values.decode(String.self, forKey: .name)
        self.size = try values.decode(Double.self, forKey: .size)
        self.url = try values.decode(String.self, forKey: .url)
        self.created_at = try values.decode(Date.self, forKey: .created_at)
    }
}

extension ProductImage: ControllerSwiftProtocol {
    static func createTable<T: DatabaseConfigurationProtocol>(database: Database<T>) throws {
        try database.sql("DROP TABLE IF EXISTS \(Self.CRUDTableName)")
        try database.sql("""
            CREATE TABLE \(Self.CRUDTableName) (
            id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
            product_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            size REAL NOT NULL,
            url TEXT NOT NULL,
            created_at TEXT NOT NULL,
            FOREIGN KEY (product_id) REFERENCES \(Product.CRUDTableName) (id) ON DELETE CASCADE
            )
            """)
    }
}
