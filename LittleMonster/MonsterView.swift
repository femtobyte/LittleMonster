//
//  MonsterView.swift
//  LittleMonster
//
//  Created by C Sinclair on 11/10/15.
//  Copyright © 2015 femtobyte. All rights reserved.
//

import UIKit

class MonsterView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        MonsterKit.drawRestart()
    }
    

}
