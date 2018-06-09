//
//  editCalController.swift
//  gtd_test
//
//  Created by 聂润泽 on 2018/1/19.
//  Copyright © 2018年 Razr. All rights reserved.
//

import UIKit
import EventKit

class  EditCalController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var editCalTableView: UITableView!
    
    var titleIdentifier: Int!
    var eventStore: EKEventStore!
    var event: EKEvent!
    var calendarList: [EKCalendar]! = [EKCalendar]()
    var calendarTempList: [EKCalendar]?
    var minutes = [5,15,30,60,120,1440,2880,10080]
    var selectedIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backImageView = UIImageView()
        backImageView.image = UIImage(named: "background.png")
        backImageView.alpha = 0.7
        editCalTableView.backgroundView = backImageView
        
        switch titleIdentifier {
        
        case 0:
            self.title = "日历"
            //筛选掉订阅和生日*************
            self.calendarTempList = eventStore.calendars(for: .event)
            let count = (calendarTempList?.count)!

            for i in 0..<count {
                if calendarTempList![i].type != .subscription && calendarTempList![i].type != .birthday {
                    calendarList?.append(calendarTempList![i])
                }
    
            }
            //*************************
        default:
            self.title = nil
        }
        
        let nib = UINib(nibName: "CalendarTableViewCell", bundle: nil)
        self.editCalTableView.register(nib, forCellReuseIdentifier: "CalendarTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.titleIdentifier == 0 {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.titleIdentifier == 1 && section == 0{
            return 1
        }else if titleIdentifier == 1 && section == 1 {
            return 8
        }else if titleIdentifier == 0 {
            return calendarList!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let initIdentifier = "CalendarTableViewCell"
        let cell:CalendarTableViewCell = (self.editCalTableView.dequeueReusableCell(withIdentifier: initIdentifier)as? CalendarTableViewCell)!
        cell.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
        cell.textLabel?.backgroundColor = UIColor.clear
        
        if titleIdentifier == 1  && indexPath[0] == 0 {
            cell.textLabel?.text = "无"
            return cell
        }
        if titleIdentifier == 1  && indexPath[0] == 1{
            switch minutes[indexPath.row]{
            case 60:
                cell.textLabel?.text = "1 小时前"
            case 120:
                cell.textLabel?.text = "2 小时前"
            case 1440:
                cell.textLabel?.text = "1 天前"
            case 2880:
                cell.textLabel?.text = "2 天前"
            case 10080:
                cell.textLabel?.text = "1 周前"
            default:
                cell.textLabel?.text = String(minutes[indexPath.row]) + " 分钟前"
            }
            return cell
            
        }else if titleIdentifier == 0 {
            cell.eventStartTime.text = nil
            cell.eventLabel?.text = calendarList?[indexPath.row].title

            if calendarList?[indexPath.row] == event.calendar {
                cell.accessoryType = .checkmark
                selectedIndexPath = indexPath
            }
            let calendarColor = UIColor(cgColor: (calendarList?[indexPath.row].cgColor)!)
            cell.calendarIdentifier?.textColor = calendarColor
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
        
        selectedIndexPath = indexPath
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        
        event.calendar = calendarList![indexPath.row]
        
        do{
            try eventStore.save(event, span: .thisEvent, commit: true)
        }catch{
            print("error")
        }
    
    }
    
    
}
