import Vapor
import ProviderSDK

final class ProviderManagerController {

    func index(_ req: Request) throws -> Future<[ProviderManager]> {
        return ProviderManager.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<ProviderManager> {
        return try req.content.decode(ProviderManager.self).flatMap { manager in
            print("\(Date()) [managers] [create] \(manager.type)")
            return manager.save(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(ProviderManager.self).flatMap { manager in
            return manager.delete(on: req)
        }.transform(to: .ok)
    }
}
