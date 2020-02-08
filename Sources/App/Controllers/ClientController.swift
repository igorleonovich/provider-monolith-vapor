import Vapor

let globalClientController = ClientController()

/// Controls basic CRUD operations on `Client`s.
final class ClientController {
    /// Returns a list of all `Client`s.
    func index(_ req: Request) throws -> Future<[Client]> {
        return Client.query(on: req).all()
    }

    /// Saves a decoded `Client` to the database.
    func create(_ req: Request) throws -> Future<Client> {
        return try req.content.decode(Client.self).flatMap { client in
            print("creating client: hostname: \(client.hostName)")
            return client.save(on: req)
        }
    }

    /// Deletes a parameterized `Client`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Client.self).flatMap { client in
            return client.delete(on: req)
        }.transform(to: .ok)
    }
}
