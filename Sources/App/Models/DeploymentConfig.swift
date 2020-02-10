import Foundation

struct DeploymentConfig: Codable {
    struct DeploymentOS: Codable {
        struct OSConfig: Codable {
            struct Environment: Codable {
                let instances: [String]
                let image: String?
                let subprovider: String
                let config: OSConfig
            }
            let osType: String?
            let osVersion: String?
            let environments: [Environment]?
            let script: String?
            let file: String?
        }
        let image: String
        let config: OSConfig
    }
    let deploymentOS: DeploymentOS
}
