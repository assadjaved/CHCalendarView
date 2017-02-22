//
//  CHCalendarViewController.swift
//  CalendarView
//
//  Created by AJK on 04/11/2016.
//  Copyright © 2016 Mac Mini. All rights reserved.
//

import UIKit

let reuseID = "CHDayCollectionViewCell"
let cellWidth: CGFloat = UIScreen.main.bounds.size.width / 7
let cellHeight: CGFloat = 50

protocol CHCalendarViewControllerDelegate: class {
    func CHCalendarViewController(controller: CHCalendarViewController, didSelectDate date: Date)
}

class CHCalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var startDate: Date!
    var endDate: Date!
    var dateFormat: String!
    var paginationEnabled: Bool = false
    weak var delegate: CHCalendarViewControllerDelegate? = nil
    
    private var inBetweenDates: [Date] = []
    private var lastMarkedDayCell: CHDayCollectionViewCell? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewLayout: LGHorizontalLinearFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configue calendar collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: reuseID, bundle: Bundle.main), forCellWithReuseIdentifier: reuseID)
        
        collectionViewLayout = LGHorizontalLinearFlowLayout.init(configuredWith: collectionView, itemSize: CGSize(width: cellWidth, height: cellHeight), minimumLineSpacing: 0)
        collectionViewLayout.scaleItems = false
        
        collectionView.isPagingEnabled = paginationEnabled
        collectionView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: cellHeight)
        
        // Calculate in between dates for StartDate and EndDate
        let dateFormatter = DateFormatter()
        dateFormat = "MM.dd.yy"
        dateFormatter.dateFormat = dateFormat
        
        startDate = dateFormatter.date(from: "04.01.16")
        endDate = dateFormatter.date(from: "04.30.16")
        
        var strtDate: Date! = startDate
        while strtDate.compare(endDate) != .orderedDescending {
            inBetweenDates.append(strtDate)
            strtDate = Calendar.current.date(byAdding: .day, value: 1, to: strtDate)
        }
    }
    
    
    //MARK: UICollectionView Data Source
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    //MARK: UICollectionView Delegate
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
    
    
    //MARK: Helpers
    private func getWeekDayString(fromDay weekDay: Int) -> String? {
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

