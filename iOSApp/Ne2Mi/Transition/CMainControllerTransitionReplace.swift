//
//  CMainControllerTransitionReplace.swift
//  Ne2Mi
//
//  Created by Carlos Uribe on 23/06/18.
//  Copyright © 2018 AngelHack. All rights reserved.
//

import UIKit

class  CMainControllerTransitionReplace:CMainControllerTransition{
    override func startTransition(main:CMain){
        main.addChildViewController(controller)
        main.view.addSubview(controller.view)
        controller.view.frame = main.view.bounds
        controller.didMove(toParentViewController:main)

        super.startTransition(main:main)

        popAllPrevious()
        previousTransition = nil
    }
}

