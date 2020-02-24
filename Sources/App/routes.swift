import Vapor
import ProviderSDK

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    router.get { req in
        return "👋"
    }

    let clientController = ProviderClientController()
    router.get("clients", use: clientController.index)
    router.post("clients", use: clientController.create)
    router.delete("clients", ProviderClient.parameter, use: clientController.delete)
    
    let deploymentController = DeploymentController()
    router.get("deployments", use: deploymentController.index)
    router.post("deployments", use: deploymentController.create)
    router.delete("deployments", Deployment.parameter, use: deploymentController.delete)
}
