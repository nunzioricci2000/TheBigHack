//
//  UIViewController+Helper.swift
//
//  Copyright (c) 2022 STMicroelectronics.
//  All rights reserved.
//
//  This software is licensed under terms that can be found in the LICENSE file in
//  the root directory of this software component.
//  If no LICENSE file comes with this software, it is provided AS-IS.
//

import UIKit
import SafariServices

public extension UIViewController {

    var stTabBarView: TabBarView? {
        if let controller = parent as? TabBarViewController {
            return controller.mainView.tabBarView
        } else if let controller = parent?.parent as? TabBarViewController {
            return controller.mainView.tabBarView
        }

        return nil
    }

    func embeddedInNav() -> UINavigationController {
        UINavigationController(rootViewController: self)
    }

    static func make<T>() -> T? where T: UIViewController {
        guard let view: T = self.viewControllerFromNib() else {
            return nil
        }

        return view
    }

    private static func viewControllerFromNib<T>() -> T? where T: UIViewController {
        let bundle = Bundle(for: self)

        return T(nibName: String(describing: self), bundle: bundle)
    }

    public func open(url: String, presentationStyle: UIModalPresentationStyle = .fullScreen) {
        guard let url = URL(string: url) else { return }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = presentationStyle
        
        self.present(safariViewController, animated: true)
    }
}
