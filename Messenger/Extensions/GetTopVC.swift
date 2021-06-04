//
//  GetTopVC.swift
//  Messenger
//
//  Created by Леонид on 31.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//
// MARK: UIApplication extensions

import UIKit

//extension UIApplication {
//
//    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? { //тут либо первый, либо последний.
//
//        if let nav = base as? UINavigationController {
//            return getTopViewController(base: nav.visibleViewController)
//
//        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
//            return getTopViewController(base: selected)
//
//        } else if let presented = base?.presentedViewController {
//            return getTopViewController(base: presented)
//        }
//        return base
//    }
//}
