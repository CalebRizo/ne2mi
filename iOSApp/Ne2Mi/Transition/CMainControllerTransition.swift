//
//  CMainControllerTransition.swift
//  Ne2Mi
//
//  Created by Carlos Uribe on 23/06/18.
//  Copyright © 2018 AngelHack. All rights reserved.
//

import UIKit

class CMainControllerTransition{
    enum CMainControllerTransitionPoptype{
        case all
        case current
        case none
    }

    weak var main:CMain!
    var controller:UIViewController!
    var previousTransition:CMainControllerTransition?

    class func PushRight(controller:UIViewController, poptype:CMainControllerTransitionPoptype) -> CMainControllerTransitionPushRight{
        let transition:CMainControllerTransitionPushRight = CMainControllerTransitionPushRight(controller:controller, poptype:poptype)

        return transition
    }

    class func Present(controller:UIViewController) -> CMainControllerTransitionPresent{
        let transition:CMainControllerTransitionPresent = CMainControllerTransitionPresent(controller:controller)

        return transition
    }

    class func Replace(controller:UIViewController) -> CMainControllerTransitionReplace{
        let transition:CMainControllerTransitionReplace = CMainControllerTransitionReplace(controller:controller)

        return transition
    }

    init(controller:UIViewController){
        self.controller = controller
    }

    //MARK: public

    func popAllPrevious(){
        previousTransition?.popAllPrevious()
        previousTransition?.popNoAnimation()
        previousTransition = nil
    }

    func popCurrentPrevious(){
        previousTransition?.popNoAnimation()
        previousTransition = previousTransition?.previousTransition
    }

    func popNoAnimation(){
        controller?.view.removeFromSuperview()
        controller?.removeFromParentViewController()
        controller?.didMove(toParentViewController:nil)
    }

    func startTransition(main:CMain){
        self.main = main
        previousTransition = main.transition
        main.transition = self
    }

    func pop(){
        main.transition = previousTransition
        popNoAnimation()
    }
}

