import Vapor

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    
    print("\(Date()) [resetStats]")
    
    let future = app.withPooledConnection(to: .sqlite, closure: { db in
        return ProviderClient.query(on: db).all()
    }).map { clients in
        print(clients)
    }
    
//    return Client.query(on: req).all().map { clients in
//        clients.forEach { client in
//            client.state = "unavailable"
//            client.cpuUsage = nil
//            client.freeRAM = nil
//            client.update(on: req)
//        }
//    }.transform(to: .ok)
}
