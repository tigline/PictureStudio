//
//  ViewControllerExtensions.swift
//  PictureStudio
//
//  Created by mickey on 2018/8/27.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

import UIKit
/**
 * Shortcut helpful methods for instantiating UIViewController
 *
 * @author Cindy Qin
 * @version 1.0
 */
public typealias ActionHandler = () -> ()
enum StoryboardType: String {
    case Main = "Main"
    case EQStoryboard = "EQStoryboard"
}

extension UIViewController {
    
    func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    /**
     Instantiate given view controller.
     The method assumes that view controller is identified the same as its class
     and view is defined in the same storyboard.
     
     :param: viewControllerClass the class name
     
     :returns: view controller or nil
     */
    func create<T: UIViewController>(_ viewControllerName: String, storyBoardName: String = "Main") -> T? {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: viewControllerName) as? T
    }
    
    func create<T: UIViewController>(_ viewControllerClass: AnyClass, storyBoardName: String = "Main") -> T? {
        
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let className = NSStringFromClass(viewControllerClass).components(separatedBy: ".").last!
        return storyboard.instantiateViewController(withIdentifier: className) as? T
    }
    
    func create<T: UIViewController>(_ viewControllerClass: AnyClass, storyBoardType: StoryboardType) -> T? {
        let storyboard = UIStoryboard(name: storyBoardType.rawValue, bundle: nil)
        let className = NSStringFromClass(viewControllerClass).components(separatedBy: ".").last!
        return storyboard.instantiateViewController(withIdentifier: className) as? T
    }
}



/**
 * Extends UIViewController with a few methods that help
 * to load and remove child view controllers.
 *
 * @author Cindy Qin
 * @version 1.0
 */
extension UIViewController {
    
    /**
     Wraps the given view controller into NavigationController
     
     - returns: NavigationController instance
     */
    func wrapInNavigationController() -> UINavigationController {
        let navigation = UINavigationController(rootViewController: self)
        navigation.navigationBar.isTranslucent = false
        return navigation
    }
    
    /**
     Load view from the given view controller into given containerView.
     Uses autoconstraints.
     
     - parameter childVC:       the view controller to load
     - parameter containerView: the view to load in
     */
    func loadChildViewToView(_ childVC: UIViewController, _ containerView: UIView, animation: Bool = false) {
        let childView = childVC.view
        childView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight];
        loadChildViewToViewWithBounds(childVC, containerView, bounds: containerView.bounds, animation: animation)
    }
    
    
    /**
     Load view from the given view controller into given containerView with fixed bounds.
     
     - parameter childVC:       the view controller to load
     - parameter containerView: the view to load in
     - parameter bounds:        the bounds of the loading view
     */
    func loadChildViewToViewWithBounds(_ childVC: UIViewController, _ containerView: UIView, bounds: CGRect, animation: Bool) {
        let childView = childVC.view
        
        childView?.frame = bounds
        
        // Adding new VC and its view to container VC
        self.addChildViewController(childVC)
        
        childVC.beginAppearanceTransition(true, animated: true)
        containerView.addSubview(childView!)
        
        childVC.endAppearanceTransition()
        // Finally notify the child view
        childVC.didMove(toParentViewController: self)
        
        
    }
    
    /**
     Add the view controller and view into the current view controller
     and given containerView correspondingly without animation.
     Uses autoconstraints.
     
     - parameter childVC:       view controller to load
     - parameter containerView: view to load into
     */
    func loadViewController(_ childVC: UIViewController, _ containerView: UIView) {
        let childView = childVC.view
        childView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight];
        loadViewController(childVC, containerView, withBounds: containerView.bounds)
    }
    
    /**
     Add the view controller and view into the current view controller
     and given containerView correspondingly.
     Sets fixed bounds for the loaded view in containerView.
     Constraints can be added manually or automatically.
     
     - parameter childVC:       view controller to load
     - parameter containerView: view to load into
     - parameter bounds:        the view bounds
     */
    func loadViewController(_ childVC: UIViewController, _ containerView: UIView, withBounds bounds: CGRect) {
        let childView = childVC.view
        
        childView?.frame = bounds
        
        // Adding new VC and its view to container VC
        self.addChildViewController(childVC)
        containerView.addSubview(childView!)
        
        // Finally notify the child view
        childVC.didMove(toParentViewController: self)
    }
    
    
    /**
     Removes view controller form its parent
     
     */
    func removeViewController(_ animation: Bool = false) {
        self.willMove(toParentViewController: nil)
        
        
        // Finally remove previous VC
        self.beginAppearanceTransition(false, animated: true)
        self.view.removeFromSuperview()
        self.endAppearanceTransition()
        
        self.removeFromParentViewController()
        
        
    }
    
    /**
     Remove view controller and view from their parents
     */
    func removeFromParent() {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    func forceSynExcuteOnMainThread(_ block: ActionHandler) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync {
                block()
            }
        }
    }
}

func roundTopLeftAndRightCornerForView(view: UIView,radius: CGFloat) -> UIView {
    let roundView = view
    let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: roundView.bounds, byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], cornerRadii: CGSize(width: radius, height: radius))
    let maskLayer = CAShapeLayer()
    maskLayer.frame = roundView.bounds
    maskLayer.path = maskPath.cgPath
    roundView.layer.mask = maskLayer
    return roundView
    
}

//func addUnderLineForLabel(label: UILabel, title: String, underLineString: String, underFontSize: CGFloat, wholeColor: UIColor = UIColor.white, isBold: Bool = true) {
//    let attributedStr = NSMutableAttributedString(string: title)
//    let nsTitle = NSString(string: title)
//    let underLineRange = nsTitle.range(of: underLineString)
//    attributedStr.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: underLineRange)
//    attributedStr.addAttribute(NSForegroundColorAttributeName, value: wholeColor, range: NSMakeRange(0, title.count))
//    if isBold {
//        attributedStr.addAttribute(NSFontAttributeName, value: AssetsUtility.openSansBoldFont(fontSize: underFontSize)!, range: underLineRange)
//    } else {
//        attributedStr.addAttribute(NSFontAttributeName, value: AssetsUtility.openSansRegularFont(fontSize: underFontSize)!, range: underLineRange)
//    }
//    label.attributedText = attributedStr
//}

/**
 View transition type (from corresponding side)
 */
enum TRANSITION {
    case right, left, bottom, top ,none
}

/**
 * Methods for custom transitions from the sides
 *
 * @author Cindy Qin
 * @version 1.0
 */
extension UIViewController {
    
    /**
     Show view controller from the side.
     See also dismissVCToSide()
     
     * parameter fromVC: current view controller
     * parameter toVC:   the view controller will present
     * parameter side:   the side to move the view controller from
     * parameter callback:       the callback block to invoke after the view controller is shown and stopped
     */
    func presentVCFromSide(_ fromVC:UIViewController, toVC:UIViewController, side:TRANSITION, callback:(()->())?) {
        
        if let transition = buildUpTransition(side) {
            fromVC.view.window?.layer.add(transition, forKey: nil)
            fromVC.present(toVC, animated: false, completion: { () -> Void in
                callback?()
            })
        }
    }
    
    /**
     Dismiss view controller to side.
     See also presentVCFromSide()
     
     * parameter viewController: dismiss view controller
     * parameter side:   the side to move the view controller from
     * parameter callback:       the callback block to invoke after the view controller is shown and stopped
     */
    func dismissVCToSide(_ viewController:UIViewController, side:TRANSITION, callback:(()->())?) {
        
        if let transition = buildUpTransition(side) {
            viewController.view.window?.layer.add(transition, forKey: nil)
            viewController.dismiss(animated: false) { () -> Void in
                callback?()
            }
        }
        
    }
    
    /// Add custom transition to current vc
    ///
    /// - Parameter side: TRANSITION enum
    func addCustomTransition(_ side:TRANSITION) {
        if let transition =  self.buildUpTransition(side) {
            self.view.window?.layer.add(transition, forKey: nil)
        }
    }
    /**
     Create Left/Right/buttom/Top transition for view controllers
     
     :param side:    the side to move the view controller from
     
     :returns:   CATransition
     */
    func buildUpTransition(_ side:TRANSITION)->CATransition? {
        if side == .none {
            return nil
        }
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        switch(side){
        case .left:
            transition.subtype = kCATransitionFromLeft
        case .bottom:
            transition.subtype = kCATransitionFromBottom
        case .right:
            transition.subtype = kCATransitionFromRight
        case .top:
            transition.subtype = kCATransitionFromTop
        default:
            print("Error: transition function wrong")
        }
        return transition
    }
    
}

