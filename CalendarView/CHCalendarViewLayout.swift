//
//  CHCalendarViewLayout.swift
//  Tripperz
//
//  Created by AJK on 05/11/2016.
//  Copyright © 2016 AJK. All rights reserved.
//

import UIKit

class CHCalendarViewLayout: UICollectionViewFlowLayout {
    
    private var size: CGSize!
    
    init(withItemSize itmSize: CGSize) {
        super.init()
        size = itmSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        itemSize = size
    }
}
