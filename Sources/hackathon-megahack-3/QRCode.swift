//
//  QRCode.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 30/06/20.
//

import Foundation
import ControllerSwift
import PerfectCRUD

struct QRCode: Codable {
    var id: Int
    var uuid: String
    var title: String
    var description: String
    var poits: Int
    var valid: Bool
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        self.uuid = (try? values.decode(String.self, forKey: .uuid)) ?? UUID().uuidString
        self.title = try values.decode(String.self, forKey: .title)
        self.description = try values.decode(String.self, forKey: .description)
        self.poits = try values.decode(Int.self, forKey: .poits)
        self.valid = try values.decode(Bool.self, forKey: .valid)
    }
}

extension QRCode: ControllerSwiftProtocol {
    static func createTable<T: DatabaseConfigurationProtocol>(database: Database<T>) throws {
        try database.sql("DROP TABLE IF EXISTS \(Self.CRUDTableName)")
        try database.sql("""
            CREATE TABLE \(Self.CRUDTableName) (
            id INTEGER AUTO_INCREMENT PRIMARY KEY UNIQUE,
            uuid TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            poits INTEGER NOT NULL,
            valid BOOLEAN NOT NULL CHECK (valid IN (0,1))
            )
            """)
    }
}
