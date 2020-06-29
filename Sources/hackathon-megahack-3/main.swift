import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import ControllerSwift
import PerfectCRUD
import PerfectSession

// MARK: - Init Server
let server = HTTPServer()
server.serverPort = 8181

SessionConfig.CORS.enabled = true
SessionConfig.CORS.maxAge = 86400
SessionConfig.CORS.acceptableHostnames = ["*"]
SessionConfig.CORS.methods = [.get, .post, .put, .delete, .options]
SessionConfig.CORS.withCredentials = true
SessionConfig.CORS.customHeaders = ["*", "Content-Range", "Timezone-Offset-Header", "Authorization"]

let sessionDriver = SessionMemoryDriver()
server.setRequestFilters([sessionDriver.requestFilter])
server.setResponseFilters([sessionDriver.responseFilter])

// MARK: - Routes
var routes = Routes()
routes.add(method: .get, uri: "/", handler: { request, response in
    response.setBody(string: "Hello world!").completed()
})

func reset() throws {
    let database = try DatabaseSettings.getDB(reset: true)
    try User.createTable(database: database)
    try UserAuthenticate.createTable(database: database)
    try Goal.createTable(database: database)
}

routes.add(method: .get, uri: "/reset", handler: { request, response in
    do {
        try reset()
    } catch {
        Log("\(error)")
        response.completed(status: .internalServerError)
    }
    response.completed()
})

routes.add(method: .options, uri: "/authenticate", handler: { request, response in
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
    routes.add(Goal.routes(database: database, useAuthenticationWith: Payload.self))
} catch {
    Log("\(error)")
}

server.addRoutes(routes)

#if os(Linux)
do {
    try reset()
} catch {
    Log("\(error)")
}
#endif

// MARK: - Start server
do {
    Log("[INFO] Starting HTTP server on \(server.serverAddress):\(server.serverPort)")
    try server.start()
} catch PerfectError.networkError(let err, let msg){
    Log("Network error thrown: \(err) \(msg)")
}
