import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // MARK: Frontend

    let workFrontendController = FrontendWorkController()
    router.get("/", use: workFrontendController.renderList)
    router.get("/create", use: workFrontendController.renderCreate)
    router.post("/create", use: workFrontendController.create)

    // MARK: API

    let api = router.grouped("api")
    let workAPIController = APIWorkController()
    api.get("/work", use: workAPIController.workList)
    api.get("/work", Work.parameter, use: workAPIController.work)
}
