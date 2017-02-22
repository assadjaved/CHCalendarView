//
//  CHCalendarViewController.swift
//  CalendarView
//
//  Created by AJK on 04/11/2016.
//  Copyright © 2016 AJK. All rights reserved.
//

import UIKit

//MARK: Constants
let reuseID = "CHDayCollectionViewCell"
let cellWidth: CGFloat = UIScreen.main.bounds.size.width / 7
let cellHeight: CGFloat = 50

//MARK: CHCalendarViewControllerDelegate
protocol CHCalendarViewControllerDelegate: class {
    func CHCalendarViewController(controller: CHCalendarViewController, didSelectDate date: Date)
}

class CHCalendarViewController: UIViewController {

    var dateFormat: String! {
        didSet {
            dateFormatter.dateFormat = dateFormat
        }
    }
    var startDate: Date!
    var endDate: Date!
    
    weak var delegate: CHCalendarViewControllerDelegate? = nil
    
    fileprivate var dateFormatter: DateFormatter = DateFormatter()
    fileprivate var inBetweenDates: [Date] = []
    fileprivate var lastMarkedDayCell: CHDayCollectionViewCell? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configue calendar collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: reuseID, bundle: Bundle.main), forCellWithReuseIdentifier: reuseID)
        
        // Configure collection view layout
        collectionView.collectionViewLayout = CHCalendarViewLayout(withItemSize: CGSize(width: cellWidth, height: cellHeight))
        
        collectionView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: cellHeight)
        
        // Calculating dates between start and end dates
        var strtDate: Date! = startDate
        while strtDate.compare(endDate) != .orderedDescending {
            inBetweenDates.append(strtDate)
            strtDate = Calendar.current.date(byAdding: .day, value: 1, to: strtDate)
        }
    }
    
    
    //MARK: Get day string for week day
    fileprivate func getWeekDayString(fromDay weekDay: Int) -> String? {
        switch weekDay {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return ""
        }
    }
}

extension CHCalendarViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inBetweenDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! CHDayCollectionViewCell
        
        let date = inBetweenDates[indexPath.row]
        let calendar = Calendar.current
        
        // getting date componenets
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let weekDay = calendar.component(.weekday, from: date)
        
        // setting up UI
        dayCell.monthAndDateLabel.text = "\(month)/\(day)"
        dayCell.dayLabel.text = getWeekDayString(fromDay: weekDay)
        
        // unmark all by default
        dayCell.unmark()
        
        return dayCell
    }
}

extension CHCalendarViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if lastMarkedDayCell != nil {
            // unmark last selected date
            lastMarkedDayCell!.unmark()
        }
        
        // mark new date
        let dayCell = collectionView.cellForItem(at: indexPath) as! CHDayCollectionViewCell
        dayCell.mark()
        
        // update last marked date
        lastMarkedDayCell = dayCell
        
        // call delegate
        let date = inBetweenDates[indexPath.row]
        delegate?.CHCalendarViewController(controller: self, didSelectDate: date)
    }
}

