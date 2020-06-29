import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import ControllerSwift
import PerfectCRUD

// MARK: - Init Server
let server = HTTPServer()
server.serverPort = 80

// MARK: - Routes
var routes = Routes()
routes.add(method: .get, uri: "/", handler: { request, response in
    response.setBody(string: "Hello world!").completed()
})

routes.add(method: .get, uri: "/reset", handler: { request, response in
    do {
        let database = try DatabaseSettings.getDB(reset: true)
        try User.createTable(database: database)
        try UserAuthenticate.createTable(database: database)
    } catch {
        Log("\(error)")
        response.completed(status: .internalServerError)
    }
    response.completed()
})

routes.add(method: .post, uri: "/authenticate", handler: { request, response in
    guard let authenticate = request.getBodyJSON(Authenticate.self) else {
        response.completed(status: .internalServerError)
        return
    }
    
    if authenticate.username == "admin" && authenticate.password == "admin" {
        let timeInterval = Date.timeInterval
        let exp = timeInterval + TimeIntervalType.minutes(10).totalSeconds
        let payload = Payload(sub: 0, exp: exp, iat: timeInterval)
        
        do {
            let token = try Token(payload: payload)
            
            try response
                .setBody(json: token)
                .addHeader(.contentType, value: "application/json")
                .completed(status: .ok)
        } catch {
            Log("\(error)")
            response.completed(status: .internalServerError)
        }
        return
    }
    
    do {
        let database = try DatabaseSettings.getDB(reset: false)
        guard
            let userAuth = try UserAuthenticate.select(database: database, username: authenticate.username),
            userAuth.password == authenticate.password.sha256
            else {
                response.completed(status: .unauthorized)
                return
        }
        
        let timeInterval = Date.timeInterval
        let exp = timeInterval + TimeIntervalType.minutes(10).totalSeconds
        let payload = Payload(sub: userAuth.idUser, exp: exp, iat: timeInterval)
        let token = try Token(payload: payload)
        
        try response
            .setBody(json: token)
            .addHeader(.contentType, value: "application/json")
            .completed(status: .ok)
    } catch {
        Log("\(error)")
        response.completed(status: .internalServerError)
    }
})

// MARK: - ControllerSwift
do {
    let database = try DatabaseSettings.getDB(reset: false)
    routes.add(User.routes(database: database, useAuthenticationWith: Payload.self))
} catch {
    Log("\(error)")
}

server.addRoutes(routes)

// MARK: - Start server
do {
    Log("[INFO] Starting HTTP server on \(server.serverAddress):\(server.serverPort)")
    try server.start()
} catch PerfectError.networkError(let err, let msg){
    Log("Network error thrown: \(err) \(msg)")
}