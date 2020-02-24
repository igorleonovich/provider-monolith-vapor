import Vapor

final class ProviderClientController {

    func index(_ req: Request) throws -> Future<[ProviderClient]> {
        return ProviderClient.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<ProviderClient> {
        return try req.content.decode(ProviderClient.self).flatMap { client in
            print("\(Date()) [create] \(client.hostName)")
            return client.save(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(ProviderClient.self).flatMap { client in
            return client.delete(on: req)
        }.transform(to: .ok)
    }
    
    static func resetStats(on container: Container) {
        print("\(Date()) [resetStats]")
        let _ = container.withPooledConnection(to: .sqlite, closure: { db in
            return ProviderClient.query(on: db).all().map { clients in
                return clients.compactMap { client -> Future<ProviderClient> in
                    client.state = "unavailable"
                    client.cpuUsage = nil
                    client.freeRAM = nil
                    return client.update(on: db)
                }
            }
        })
    }
}
