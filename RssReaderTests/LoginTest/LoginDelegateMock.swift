//
//  LoginDelegateMock.swift
//  RssReaderTests
//
//  Created by 若江照仁 on 2022/03/20.
//

import UIKit
@testable import RssReader

class LoginDelegateMock {
    // result for Transitioner
    var pushedResult: (UIViewController, Bool)?
    var poppedResult: Bool?
    var poppedToRootVCResult: Bool?
    var poppedToVCResult: (UIViewController, Bool)?
    var presentedResult: (UIViewController, Bool, (()->())?)?
    var dismissResult: Bool?
    
    // result for AutoLoginDelegate
    var autoLoginResult: Bool?
    
    // result for LogoutDelegate
    var isLogoutCompleted = false
}

extension LoginDelegateMock: Transitioner {
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedResult = (viewController, animated)
    }
    
    func popViewController(animated: Bool) {
        poppedResult = animated
    }
    
    func popToRootViewController(animated: Bool) {
        poppedToRootVCResult = animated
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool) {
        poppedToVCResult = (viewController, animated)
    }
    
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> ())?) {
        presentedResult = (viewController, animated, completion)
    }
    
    func dismiss(animated: Bool) {
        dismissResult = animated
    }
}

extension LoginDelegateMock: AutoLoginDelegate {
    func didAutoLogin(isSuccess: Bool) {
        autoLoginResult = isSuccess
    }
}

extension LoginDelegateMock: LogoutDelegate {
    func didLogout() {
        isLogoutCompleted = true
    }
}
