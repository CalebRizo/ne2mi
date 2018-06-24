//
//  VMainShade.swift
//  Ne2Mi
//
//  Created by Carlos Uribe on 23/06/18.
//  Copyright © 2018 AngelHack. All rights reserved.
//

import UIKit

class VMainShade:UIView{
    private let kAlphaMax:CGFloat = 0.9
    private let kAlphaMin:CGFloat = 0

    override init(frame:CGRect){
        super.init(frame:frame)
        isUserInteractionEnabled = false
        clipsToBounds = true
        alpha = kAlphaMin
        backgroundColor = UIColor.clear

        let visualEffect:UIBlurEffect = UIBlurEffect(style:UIBlurEffectStyle.dark)
        let blur:UIVisualEffectView = UIVisualEffectView(effect:visualEffect)
        blur.isUserInteractionEnabled = false
        blur.clipsToBounds = true
        blur.translatesAutoresizingMaskIntoConstraints = false

        addSubview(blur)

        let views:[String:UIView] = [
            "blur":blur]

        let metrics:[String:CGFloat] = [:]

        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:"H:|-0-[blur]-0-|",
            options:[],
            metrics:metrics,
            views:views))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:"V:|-0-[blur]-0-|",
            options:[],
            metrics:metrics,
            views:views))
    }

    required init?(coder:NSCoder){
        fatalError()
    }

    //MARK: public

    func alphaMax(){
        alpha = kAlphaMax
    }

    func alphaMin(){
        alpha = kAlphaMin
    }
}

