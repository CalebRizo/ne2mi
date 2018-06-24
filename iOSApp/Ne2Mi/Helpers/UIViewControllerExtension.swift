//
//  UIViewControllerExtension.swift
//  Ne2Mi
//
//  Created by Carlos Uribe on 23/06/18.
//  Copyright © 2018 AngelHack. All rights reserved.
//

import UIKit

extension UIViewController{
    var parentController:CMain{
        get{
            return self.parent as! CMain
        }
    }
}
