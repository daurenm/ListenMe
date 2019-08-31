//
//  Router.swift
//  Testing
//
//  Created by Dauren Muratov on 6/10/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

protocol RouterType: Presentable {
    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }
    
    func present(_ module: Presentable, animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
    func popModule(animated: Bool)
    
    func setRootModule(_ module: Presentable, hideBar: Bool)
    func popToRootModule(animated: Bool)
    
    func presentAlert(_ alert: Alert)
}

extension RouterType {
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)? = nil) {
        push(module, animated: animated, completion: completion)
    }
    
    func setRootModule(_ module: Presentable, hideBar: Bool = false) {
        setRootModule(module, hideBar: hideBar)
    }
}

final class Router: NSObject, RouterType, ShowsAlerts {
    
    // MARK: - Properties
    var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }

    private var completions: [UIViewController: () -> Void]
    let navigationController: UINavigationController
    
    // MARK: - Lifecycle methods
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isTranslucent = false
        completions = [:]
        
        super.init()
        
        self.navigationController.delegate = self
    }
    
    // MARK: - RouterType
    func present(_ module: Presentable, animated: Bool) {
        navigationController.present(module.toPresent(), animated: animated)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)? = nil) {
        let controller = module.toPresent()
        if let completion = completion {
            completions[controller] = completion
        }
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func popModule(animated: Bool) {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func setRootModule(_ module: Presentable, hideBar: Bool = false) {
        completions.forEach { $0.value() }
        completions = [:]
        navigationController.setViewControllers([module.toPresent()], animated: false)
        navigationController.isNavigationBarHidden = hideBar
    }
    
    func popToRootModule(animated: Bool) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
    func presentAlert(_ alert: Alert) {
        presentAlert(in: toPresent(), alert: alert)
    }
}

extension Router: Presentable {
    func toPresent() -> UIViewController {
        return navigationController
    }
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController) else { return }
        
        runCompletion(for: poppedViewController)
    }
}












