import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    router.get { req in
        return "/"
    }

    // Example of configuring a controller
    let clientController = ClientController()
    router.get("clients", use: clientController.index)
    router.post("clients", use: clientController.create)
    router.delete("clients", Client.parameter, use: clientController.delete)
    
//    router.get("clients", Client.parameter) { req -> Future<Client> in
//        return try req.parameters.next(Client.self)
//    }
}
