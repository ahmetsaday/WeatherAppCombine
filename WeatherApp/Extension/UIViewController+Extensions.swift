//
//  UIViewController+Extensions.swift
//  WeatherApp
//
//  Created by Saday on 27.04.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    private class var storyboardName: String {
        return String(describing: self)
    }
    
    class func createFromStoryboard() -> Self {
        let vc = createFromStoryboard(named: storyboardName, type: self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    private static func createFromStoryboard<T: UIViewController>(named storyboardName: String?, type: T.Type) -> T {
        let vc = UIStoryboard(name: storyboardName ?? self.storyboardName, bundle: Bundle.main).instantiateInitialViewController() as! T
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
}
