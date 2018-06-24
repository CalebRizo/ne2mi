//
//  UICollectionReusableViewExtension.swift
//  Ne2Mi
//
//  Created by Carlos Uribe on 23/06/18.
//  Copyright © 2018 AngelHack. All rights reserved.
//

import UIKit

extension UICollectionReusableView{
    class func reusableIdentifier() -> String{
        let classType:AnyClass = object_getClass(self)!

        return NSStringFromClass(classType)
    }
}
