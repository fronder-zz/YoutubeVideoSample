//
//  BaseViewController.swift
//  SampleCode
//
//  Created by Hasan on 11/17/18.
//  Copyright © 2018 Hasan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // Storybord
    static func instantiate(viewControllerIdentifier: String) -> UIViewController {
        return instantiate(storyboardName: "Main", viewControllerIdentifier: viewControllerIdentifier)!
    }
    
    static func instantiate(storyboardName: String, viewControllerIdentifier: String) -> UIViewController? {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerIdentifier)
    }
    
    static func instantiate(storyboard: UIStoryboard, viewControllerIdentifier: String) -> UIViewController? {
        return storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
    }
}

extension BaseViewController {
    @objc class func instantiate() -> BaseViewController {return BaseViewController()}
}

