//
//  CHDayCollectionViewCell
//  CalendarView
//
//  Created by AJK on 04/11/2016.
//  Copyright © 2016 AJK. All rights reserved.
//

import UIKit

let unmarkedColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1)
let markedColor = UIColor(red: 30/255, green: 191/255, blue: 216/255, alpha: 1)

class CHDayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var monthAndDateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    
    func mark() {
        monthAndDateLabel.textColor = markedColor
        dayLabel.textColor = markedColor
    }
    
    func unmark() {
        monthAndDateLabel.textColor = unmarkedColor
        dayLabel.textColor = unmarkedColor
    }
}
