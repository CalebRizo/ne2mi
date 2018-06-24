//
//  CWelcomeController.swift
//  Ne2Mi
//
//  Created by Carlos Uribe on 23/06/18.
//  Copyright © 2018 AngelHack. All rights reserved.
//

import UIKit

class CWelcomeController:UIViewController{
    weak var welcomeView:VWelcomeView!

    override func loadView() {
        let welcomeView:VWelcomeView = VWelcomeView(controller:self)
        self.welcomeView = welcomeView
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge()
        extendedLayoutIncludesOpaqueBars = false
    }

    override var preferredStatusBarStyle:UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

    override var prefersStatusBarHidden:Bool{
        return false
    }
}
