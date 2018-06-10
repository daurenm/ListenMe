//
//  Coordinator.swift
//  Testing
//
//  Created by Dauren Muratov on 6/10/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

protocol BaseCoordinatorType: class {
    func start()
}

protocol PresentableCoordinatorType: BaseCoordinatorType, Presentable {}

class PresentableCoordinator: NSObject, PresentableCoordinatorType {
    
    override init() {
        super.init()
    }
    
    func start() {}
    
    func toPresent() -> UIViewController {
        fatalError("Must override toPresent")
    }
}

protocol CoordinatorType: PresentableCoordinatorType {
    var router: RouterType { get }
}

class Coordinator: PresentableCoordinator, CoordinatorType {
    var childCoordinators: [Coordinator] = []
    var router: RouterType
    
    init(router: RouterType = Router()) {
        self.router = router
        super.init()
    }
    
    override func toPresent() -> UIViewController {
        return router.toPresent()
    }
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator, let index = childCoordinators.index(of: coordinator) else { return }
        childCoordinators.remove(at: index)
    }
}















