//
//  AlertViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/24.
//

import UIKit

protocol DialogProtocol where Self: UIView {
    var alertController: DialogDelegate? { get set }
    func set(title: String, message: String)
}

class AlertController: UIViewController, UIViewControllerTransitioningDelegate {
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "MainLabel")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var alertView: DialogProtocol!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //init時に宣言しないと、前の画面を透過しない
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = UIModalPresentationStyle.custom
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
    }
    
    func layoutView() {
        view.addSubview(baseView)
        view.addSubview(alertView)
        
        baseView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        baseView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        baseView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        baseView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        alertView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        alertView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertAnimation(true)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertAnimation(false)
    }

}

extension AlertController: DialogDelegate {
    func tapped() {
        dismiss(animated: true, completion: nil)
    }
}

class AlertAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    //true: dismiss
    //false: present
    let isPresent: Bool
    
    init(_ isPresent: Bool) {
        self.isPresent = isPresent
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            dismissAnimation(transitionContext)
        } else {
            presentAnimation(transitionContext)
        }
    }
    
    //表示時のアニメーション
    func presentAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        let alert = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! AlertController
        
        let container = transitionContext.containerView
        
        alert.baseView.alpha = 0
        alert.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        //すでにfromのviewControllerはaddSubviewされているので、addSubviewやinsertSubviewの必要はない
        container.addSubview(alert.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        alert.baseView.alpha = 0.7
                        alert.alertView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) },
                       completion: { bool in
                        UIView.animate(withDuration: 0.1, animations: {
                            alert.alertView.transform = CGAffineTransform.identity
                        })
                        transitionContext.completeTransition(true) })
        
    }
    
    //閉じる時のアニメーション
    func dismissAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let alert = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! AlertController
        
        UIView.animate(withDuration: 0.3, animations: {
            alert.baseView.alpha = 0
            alert.alertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { finished in
            transitionContext.completeTransition(true)
        })
    }
    
}
