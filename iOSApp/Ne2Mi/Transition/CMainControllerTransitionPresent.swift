//
//  CMainControllerTransitionPresent.swift
//  Ne2Mi
//
//  Created by Carlos Uribe on 23/06/18.
//  Copyright © 2018 AngelHack. All rights reserved.
//

import UIKit

class CMainControllerTransitionPresent:CMainControllerTransition{
    override func startTransition(main:CMain){
        let mainRect:CGRect = main.view.bounds
        controller.view.frame = mainRect
        controller.view.alpha = 0
        main.addChildViewController(controller)
        main.view.addSubview(controller.view)
        controller.didMove(toParentViewController:main)
        controller.view.frame = main.view.bounds
        controller.didMove(toParentViewController:main)

        UIView.animate(withDuration:main.interaction.kMoveControllerDuration, animations:
            {
                self.controller.view.alpha = 1
        })
        { (done) in

            super.startTransition(main:main)
        }
    }

    override func pop(){
        UIView.animate(withDuration:main.interaction.kMoveControllerDuration, animations:
            {
                self.controller.view.alpha = 0
        })
        { (done) in

            self.controller.willMove(toParentViewController:nil)
            self.controller.view.removeFromSuperview()
            self.controller.removeFromParentViewController()

            super.pop()
        }
    }
}

