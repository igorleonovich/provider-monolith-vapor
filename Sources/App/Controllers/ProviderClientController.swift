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
        print("\(Date()) [resetStats] [all]")
        let _ = container.withPooledConnection(to: .sqlite, closure: { worker in
            return ProviderClient.query(on: worker).all().map { clients in
                return clients.compactMap { client -> Future<ProviderClient> in
                    return resetStats(on: worker, client: client)
                }
            }
        })
    }
    
    static func resetStats(on worker: DatabaseConnectable, client: ProviderClient) -> Future<ProviderClient> {
        print("\(Date()) [resetStats] [\(client.userName)@\(client.hostName)]")
        client.state = "unavailable"
        client.cpuUsage = nil
        client.freeRAM = nil
        return client.update(on: worker)
    }
}
