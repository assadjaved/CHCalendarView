//
//  MainViewController.swift
//  CalendarView
//
//  Created by AJK on 22/02/2017.
//  Copyright © 2017 AJK. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Embedded segue is performed when view is first loaded.
        // You can configure CHCalenderView here
        if segue.identifier == "CHCalendarViewSegue" {
            let CHCalendarVC = segue.destination as! CHCalendarViewController
            CHCalendarVC.dateFormat = "MM.dd.yy"
            CHCalendarVC.startDate = Date()
            CHCalendarVC.endDate = Date.distantFuture
            CHCalendarVC.delegate = self
        }
    }
}

extension MainViewController: CHCalendarViewControllerDelegate {
    
    func CHCalendarViewController(controller: CHCalendarViewController, didSelectDate date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
    }
}
