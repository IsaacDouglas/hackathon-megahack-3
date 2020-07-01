//
//  Address.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 30/06/20.
//

import Foundation
import ControllerSwift
import PerfectCRUD

struct Address: Codable {
    var id: Int
    var user_id: Int
    var CEP: String
    var street: String
    var number: String
    var complement: String?
    var reference: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        self.user_id = try values.decode(Int.self, forKey: .user_id)
        self.CEP = try values.decode(String.self, forKey: .CEP)
        self.street = try values.decode(String.self, forKey: .street)
        self.number = try values.decode(String.self, forKey: .number)
        self.complement = try? values.decode(String.self, forKey: .complement)
        self.reference = try? values.decode(String.self, forKey: .reference)
    }
}

extension Address: ControllerSwiftProtocol {
    static func createTable<T: DatabaseConfigurationProtocol>(database: Database<T>) throws {
        try database.sql("DROP TABLE IF EXISTS \(Self.CRUDTableName)")
        try database.sql("""
            CREATE TABLE \(Self.CRUDTableName) (
            id INTEGER AUTO_INCREMENT PRIMARY KEY UNIQUE,
            user_id INTEGER NOT NULL,
            CEP TEXT NOT NULL,
            street TEXT NOT NULL,
            number TEXT NOT NULL,
            complement TEXT,
            reference TEXT,
            FOREIGN KEY (user_id) REFERENCES \(User.CRUDTableName) (id) ON DELETE CASCADE
            )
            """)
    }
}
