//
//  ShowsAlerts.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/8/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

enum Alert {
    case error(String)
    case alert(String)
}

protocol ShowsAlerts: class {
    func presentAlert(in viewController: UIViewController, alert: Alert)
}

extension ShowsAlerts {
    func presentAlert(in viewController: UIViewController, alert: Alert) {
        let title: String
        let message: String
        switch alert {
        case .alert(let text):
            title = "Alert"
            message = text
        case .error(let text):
            title = "Error"
            message = text
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = .activeText
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true)
    }
}
