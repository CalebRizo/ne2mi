//
//  CMainControllerInteraction.swift
//  Ne2Mi
//
//  Created by Carlos Uribe on 23/06/18.
//  Copyright © 2018 AngelHack. All rights reserved.
//

import UIKit

class CMainControllerInteraction{
    let width:CGFloat
    let height:CGFloat
    let width_2:CGFloat
    let kMoveControllerDuration:TimeInterval = 0.35
    let kPeekHorizontalAmount:CGFloat = 100

    lazy var rectFromHalfLeft:CGRect = {
        let rect:CGRect = CGRect(
            x:-self.width_2,
            y:0,
            width:self.width,
            height:self.height)

        return rect
    }()

    lazy var rectFromHalfRight:CGRect = {
        let rect:CGRect = CGRect(
            x:self.width_2,
            y:0,
            width:self.width,
            height:self.height)

        return rect
    }()

    lazy var rectFromRight:CGRect = {
        let rect:CGRect = CGRect(
            x:self.width,
            y:0,
            width:self.width,
            height:self.height)

        return rect
    }()

    lazy var rectFromLeft:CGRect = {
        let rect:CGRect = CGRect(
            x:-self.width,
            y:0,
            width:self.width,
            height:self.height)

        return rect
    }()

    lazy var rectFromDown:CGRect = {
        let rect:CGRect = CGRect(
            x:0,
            y:self.height,
            width:self.width,
            height:self.height)

        return rect
    }()

    lazy var peekRectRight:CGRect = {
        let rect:CGRect = CGRect(
            x:self.width - self.kPeekHorizontalAmount,
            y:0,
            width:self.width,
            height:self.height)

        return rect
    }()

    lazy var peekedRectRight:CGRect = {
        let rect:CGRect = CGRect(
            x:-self.kPeekHorizontalAmount,
            y:0,
            width:self.width,
            height:self.height)

        return rect
    }()

    lazy var peekRectLeft:CGRect = {
        let rect:CGRect = CGRect(
            x:self.kPeekHorizontalAmount - self.width,
            y:0,
            width:self.width,
            height:self.height)

        return rect
    }()

    lazy var peekedRectLeft:CGRect = {
        let rect:CGRect = CGRect(
            x:self.kPeekHorizontalAmount,
            y:0,
            width:self.width,
            height:self.height)

        return rect
    }()

    init(){
        let rect:CGRect = UIScreen.main.bounds
        width = rect.width
        height = rect.height
        width_2 = width / 2.0
    }
}
