import Vapor

final class ClientController {

    func index(_ req: Request) throws -> Future<[Client]> {
        return Client.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<Client> {
        return try req.content.decode(Client.self).flatMap { client in
            print("\(Date()) [create] \(client.hostName)")
            return client.save(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Client.self).flatMap { client in
            return client.delete(on: req)
        }.transform(to: .ok)
    }
    
    func resetStats(_ req: Request) throws -> Future<HTTPStatus> {
        print("\(Date()) [resetStats]")
        return Client.query(on: req).all().map { clients in
            clients.forEach { client in
                client.state = "unavailable"
                client.cpuUsage = nil
                client.freeRAM = nil
                client.update(on: req)
            }
        }.transform(to: .ok)
    }
}
