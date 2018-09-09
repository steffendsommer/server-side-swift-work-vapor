import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let workController = FrontendWorkController()
    router.get("/", use: workController.renderList)
    router.get("/create", use: workController.renderCreate)
    router.post("/create", use: workController.create)
}
