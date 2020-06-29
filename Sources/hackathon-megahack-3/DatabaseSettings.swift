//
//  DatabaseSettings.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 29/06/20.
//

import Foundation
import PerfectCRUD
import PerfectSQLite

typealias DBConfiguration = SQLiteDatabaseConfiguration

class DatabaseSettings {
    static func getDB(reset: Bool) throws -> Database<DBConfiguration> {
        let dbPath = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("db/database/megahack3.db")
        
        if reset {
            unlink(dbPath.absoluteString)
        }
        return Database(configuration: try DBConfiguration(dbPath.path))
    }
}
