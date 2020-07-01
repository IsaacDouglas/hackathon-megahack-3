//
//  UserAuthenticate.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 29/06/20.
//

import Foundation
import ControllerSwift
import PerfectCRUD

struct UserAuthenticate: Codable {
    var id: Int
    var username: String
    var password: String
    var idUser: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case password
        case idUser = "id_user"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        self.username = try values.decode(String.self, forKey: .username)
        self.password = try values.decode(String.self, forKey: .password)
        self.idUser = try values.decode(Int.self, forKey: .idUser)
    }
}

extension UserAuthenticate: ControllerSwiftProtocol {
    static func createTable<T: DatabaseConfigurationProtocol>(database: Database<T>) throws {
        try database.sql("DROP TABLE IF EXISTS \(Self.CRUDTableName)")
        try database.sql("""
            CREATE TABLE \(Self.CRUDTableName) (
            id INTEGER AUTO_INCREMENT PRIMARY KEY UNIQUE,
            username VARCHAR(128) NOT NULL UNIQUE,
            password CHAR(64) NOT NULL,
            id_user INTEGER NOT NULL UNIQUE
            )
            """)
    }
    
    static func select<T: DatabaseConfigurationProtocol>(database: Database<T>, username: String) throws -> UserAuthenticate? {
        let table = database.table(Self.self)
        return try table.where(\Self.username == username).first()
    }
}
