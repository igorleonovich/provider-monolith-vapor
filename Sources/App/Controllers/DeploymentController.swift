import Vapor

final class DeploymentController {

    func index(_ req: Request) throws -> Future<[Deployment]> {
        return Deployment.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<Deployment> {
        return try req.content.decode(DeploymentConfig.self).flatMap { deploymentConfig in
                        
            print("start deployment with deploymentConfig on a client via ws...")
            print(deploymentConfig)
            
            if let ws = WebSocketsManager.clients.values.first {
                do {
                    let json = try JSONEncoder().encode(deploymentConfig)
                    ws.send(json)
                } catch {
                    print(error)
                }
            }
            
            let deployment = Deployment.init(id: UUID(), state: DeploymentState.transporting.rawValue)
            return deployment.create(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Deployment.self).flatMap { deployment in
            return deployment.delete(on: req)
        }.transform(to: .ok)
    }
}
