import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("/") { req in
        return "Server-Side Swift Work - TBC.."
    }
}
