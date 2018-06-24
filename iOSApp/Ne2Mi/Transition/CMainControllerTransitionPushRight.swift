//
//  CMainControllerTransitionPushRight.swift
//  Ne2Mi
//
//  Created by Carlos Uribe on 23/06/18.
//  Copyright © 2018 AngelHack. All rights reserved.
//

import UIKit

class CMainControllerTransitionPushRight:CMainControllerTransition{
    let poptype:CMainControllerTransitionPoptype
    weak var shade:VMainShade!

    init(controller:UIViewController, poptype:CMainControllerTransitionPoptype){
        self.poptype = poptype

        super.init(controller:controller)
    }

    override func startTransition(main:CMain){
        let mainRect:CGRect = main.view.bounds
        let prevController:UIViewController = main.transition!.controller
        let shade:VMainShade = VMainShade(frame:mainRect)
        self.shade = shade

        controller.view.frame = main.interaction.rectFromRight
        prevController.willMove(toParentViewController: nil)
        main.addChildViewController(controller)
        main.view.addSubview(shade)

        main.transition(
            from:prevController,
            to:controller,
            duration:main.interaction.kMoveControllerDuration,
            options:UIViewAnimationOptions.curveEaseOut,
            animations:
            {
                shade.alphaMax()
                self.controller.view.frame = mainRect
                prevController.view.frame = main.interaction.rectFromHalfLeft
        })
        { (done) in

            super.startTransition(main:main)
            self.preparePop()
        }
    }

    override func pop(){
        let mainRect:CGRect = main.view.bounds
        let prevController:UIViewController = previousTransition!.controller
        controller.willMove(toParentViewController:nil)
        main.addChildViewController(prevController)

        main.transition(
            from: controller,
            to:prevController,
            duration:main.interaction.kMoveControllerDuration,
            options:UIViewAnimationOptions.curveEaseOut,
            animations:
            {
                self.main.view.insertSubview(prevController.view, belowSubview:self.shade)
                self.shade.alphaMin()
                self.controller.view.frame = self.main.interaction.rectFromRight
                prevController.view.frame = mainRect
        })
        { (done) in

            super.pop()
        }
    }

    override func popNoAnimation(){
        super.popNoAnimation()
        shade.removeFromSuperview()
    }

    //MARK: private

    private func preparePop(){
        switch(poptype){
        case CMainControllerTransitionPoptype.all:

            popAllPrevious()

            break

        case CMainControllerTransitionPoptype.current:

            popCurrentPrevious()

            break

        default:break
        }
    }
}

