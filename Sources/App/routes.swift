import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // MARK: Frontend

    let workFrontendController = FrontendWorkController()
    router.get("/", use: workFrontendController.renderList)
    router.get("/create", use: workFrontendController.renderCreate)
    router.post("/create", use: workFrontendController.create)

    // MARK: API

    let workAPIController = APIWorkController()
    router.get(API.Endpoint.workList.route, use: workAPIController.workList)
    router.get(API.Endpoint.work(0).route, use: workAPIController.work)
}

extension API.Endpoint {
    var route: [PathComponentsRepresentable] {
        switch self {
        case .workList: return ["api", "work"]
        case .work(_): return ["api", "work", Work.parameter]
        }
    }
}
