//
//  ViewController.swift
//  gtd_test
//
//  Created by 聂润泽 on 2018/1/12.
//  Copyright © 2018年 Razr. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications

class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            if indexPath[0] == 0 && events?.isEmpty == false {
                previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
                let s = UIStoryboard(name: "Main", bundle: nil)
                let controller = s.instantiateViewController(withIdentifier: "EventDetailsController") as! EventDetailsController
                controller.event = self.events?[indexPath.row]
                controller.eventStore = eventStore
                
                return controller
            }
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
    @IBOutlet weak var calStateLabel: UILabel!
    @IBOutlet weak var remStateLabel: UILabel!
    

    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let eventStore = EKEventStore()
    var reminderList: [EKCalendar]?
    var calendarList: [EKCalendar]?
    var reminders: [EKReminder]?
    var events: [EKEvent]?
    var titleString: String!
    var titleStringPlus: String!
    var defaultSource: EKSource!
    var sources: [EKSource]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isEnabled = false
        
        calStateLabel.textColor = UIColor.black
        remStateLabel.textColor = UIColor.black
        
        let backImageView = UIImageView()
        backImageView.image = UIImage(named: "background.png")
        backImageView.alpha = 0.7
        tableView.backgroundView = backImageView
        welcomeView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.tableView.backgroundColor = UIColor.white
        // 设置导航栏半透明
        self.navigationController?.navigationBar.isTranslucent = true
        
        // 设置导航栏背景图片
       self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)

        // 设置导航栏阴影图片
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        
        //获取当前日期 显示为标题
        let date = Date()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year,.month, .day, .hour,.minute,.second], from: date)
        titleString = String(dateComponents.month!) + "月" + String(dateComponents.day!) + "日"

        switch dateComponents.hour {
        case 0,1,2,3,4:
            titleStringPlus = "🌠"
        case 5,6,7,8,9,10:
            titleStringPlus = "🌅"
        case 11,12,13,14:
            titleStringPlus = "🌇"
        case 15,16,17:
            titleStringPlus = "🌆"
        case 18,19,20:
            titleStringPlus = "🏙"
        case 21,22,23:
            titleStringPlus = "🌃"
        default:
            titleStringPlus = nil
        }
        
        self.title = titleString + titleStringPlus
        //******************
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        calStateLabel.text = nil
        remStateLabel.text = nil
        
        checkState()
        
        let nib = UINib(nibName: "CalendarTableViewCell", bundle: nil)
        let nib_2 = UINib(nibName: "ReminderTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CalendarTableViewCell")
        self.tableView.register(nib_2, forCellReuseIdentifier: "ReminderTableViewCell")
        
        self.tableView.separatorStyle = .none
        
        registerForPreviewing(with: self, sourceView: tableView)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (success, error) in
            if success {
                print("success")
            } else {
                print("error")
            }
        }
    }
    
    //test notification
    func testNotification() {
        let content = UNMutableNotificationContent()
        content.title = "买胶带"
        content.subtitle = ""
        content.body = ""
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshTableView()
        testNotification()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if events?.isEmpty != true {
                if let events = self.events {
                    return events.count
                }
            }
            return 1
            
        }
        
        if section == 1 {
            if reminders?.isEmpty != true {
                if let reminders = self.reminders {
                    return reminders.count
                }
            }
            return 0
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath[0] == 0 && events?.isEmpty == false {
            let s = UIStoryboard(name: "Main", bundle: nil)
            let controller = s.instantiateViewController(withIdentifier: "EventDetailsController") as! EventDetailsController
            controller.event = self.events?[indexPath.row]
            controller.eventStore = eventStore
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath[0] == 1{
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.isEditing = false
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let details = UITableViewRowAction(style: .normal, title: "编辑") { (action, indexPath) in
            let s = UIStoryboard(name: "Main", bundle: nil)
            let controller = s.instantiateViewController(withIdentifier: "NewItemController") as! NewItemController
            controller.eventStore = self.eventStore
            controller.reminder = self.reminders?[indexPath.row]
            controller.identifier = 1
            self.present(controller, animated: true, completion: nil)
        }
        let delete = UITableViewRowAction(style: .default, title: "删除") { (action, indexPath) in
            do{
                try self.eventStore.remove((self.reminders?[indexPath.row])!, commit: true)
                self.reminders?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.refreshTableView()
            }catch{
                print("error")
            }
        }
        return [delete,details]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let timeFormatter = DateFormatter()
        let dateTimeFormatter_date = DateFormatter()
        
        timeFormatter.dateFormat = "HH:mm"
        dateTimeFormatter_date.dateFormat = "dd"
        
        //日历
        if indexPath[0] == 0 {
            
            let initIdentifier = "CalendarTableViewCell"
            let cell:CalendarTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: initIdentifier)as? CalendarTableViewCell)!
            
            cell.backgroundColor = UIColor.clear
            
            if events?.isEmpty == true {
                cell.eventLabel.text = "空闲的一天 🤗"
                cell.eventLabel.textColor = UIColor.gray
                cell.calendarIdentifier.text = nil
                cell.eventStartTime.text = nil
                return cell
            }else{
                let calendarColor = UIColor(cgColor: (events?[indexPath.row].calendar.cgColor)!)
                if events?[indexPath.row].calendar.type == .birthday {
                    cell.calendarIdentifier.text = "🎂"
                }else{
                    cell.calendarIdentifier.textColor = calendarColor
                }
                
                cell.eventLabel.text = events?[indexPath.row].title
                
                let date = Date()
                let currentDate = dateTimeFormatter_date.string(from: date)
                let eventDate = dateTimeFormatter_date.string(from: (events?[indexPath.row].startDate)!)
                
                switch(events?[indexPath.row].isAllDay) {
                //全天事件
                case true:
                    if eventDate != currentDate {
                        cell.eventStartTime.text = "明天"
                    }else{
                        cell.eventStartTime.text = "全天"
                    }
                //非全天事件
                case false:
                    let startTime = timeFormatter.string(from: (events?[indexPath.row].startDate)!)
                    let endTime = timeFormatter.string(from: (events?[indexPath.row].endDate)!)
                    
                    if eventDate != currentDate {
                        cell.eventStartTime.text = "🌙 " + startTime + " - " + endTime
                    }else{
                        cell.eventStartTime.text = startTime + " - " + endTime
                        
                    }
                default:
                    return cell
                }

                return cell
            }
        }
        //提醒事项
        if indexPath[0] == 1 {
            
            
            let initIdentifier = "ReminderTableViewCell"
            let cell:ReminderTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: initIdentifier)as? ReminderTableViewCell)!
            //半透明
            cell.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
            cell.reminderLabel?.backgroundColor = UIColor.clear
            cell.propertyLabel.backgroundColor = UIColor.clear
            cell.dueTime.backgroundColor = UIColor.clear
            cell.completeButton.backgroundColor = UIColor.clear
            //
            let reminderListColor = UIColor(cgColor: (reminders?[indexPath.row].calendar.cgColor)!)
            cell.completeButton.titleLabel?.font = UIFont(name: "IconFont", size: 26)
            cell.completeButton.setTitle("\u{e651}", for: .normal)
            //重置 cell 样式
            cell.reminderLabel.textColor = UIColor.black
            //
            cell.reminderLabel.text = reminders?[indexPath.row].title
            cell.completeButton.tintColor = reminderListColor
            cell.propertyLabel.textColor = reminderListColor
            switch(reminders?[indexPath.row].priority) {
            case 1?:
                cell.propertyLabel.text = "!!!"
            case 5?:
                cell.propertyLabel.text = "!!"
            case 9?:
                cell.propertyLabel.text = "!"
            default:
                cell.propertyLabel.text = nil
            }
            cell.reminder = reminders?[indexPath.row]
            cell.eventStore = eventStore
            //***********
            let date = Date()
            let dateTimeFormatter_year = DateFormatter()
            let dateTimeFormatter_month = DateFormatter()
            let dateTimeFormatter_date = DateFormatter()
            
            dateTimeFormatter_year.dateFormat = "yy"
            dateTimeFormatter_month.dateFormat = "MM"
            dateTimeFormatter_date.dateFormat = "dd"
            
            let currentMonth = dateTimeFormatter_month.string(from: date)
            let currentDate = dateTimeFormatter_date.string(from: date)
//            let currentYear = dateTimeFormatter_year.string(from: date)
            let MM = Int(currentMonth)
            let dd = Int(currentDate)
//            let yy = Int(currentYear)
            //**************
            
            if reminders?[indexPath.row].dueDateComponents != nil && reminders?[indexPath.row].dueDateComponents?.month == MM && reminders?[indexPath.row].dueDateComponents?.day == dd {
                cell.dueTime.text = timeFormatter.string(from: (reminders?[indexPath.row].dueDateComponents?.date)!)
            }else {
                cell.dueTime.text = nil
            }
            return cell
            
            
            
            
        }
        
        return UITableViewCell()
        
        
    }
    
    
    func loadData() {
        loadCalendarList()
        loadEvents()
        loadReminderList()
        loadReminderItems()
        
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            if accessGranted == true {
            DispatchQueue.main.async(execute: {
                self.checkState()
            })
            }else{
                print("error")
            }
        })
    }
    func requestAccessToReminder() {
        eventStore.requestAccess(to: EKEntityType.reminder, completion: {
            (accessGranted: Bool, error: Error?) in
            if accessGranted == true {
            DispatchQueue.main.async(execute: {
                self.checkState()
            })
            }else{
                print("error")
            }
        })
    }
    func loadCalendarList() {
        self.calendarList = eventStore.calendars(for: .event)
        
    }
    func loadEvents() {
        
        //获取当前日期
        let date = Date()
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yy-MM-dd"
        let currentDate = dateTimeFormatter.string(from: date)
        //设定起始时间
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yy-MM-dd HH:mm"
        let startDate = timeFormatter.date(from: currentDate + " 00:00")
        let endDate = Date(timeInterval: 104340, since: startDate!)
        //读取系统日历
        let eventsPredicate = eventStore.predicateForEvents(withStart: startDate!, end: endDate, calendars: calendarList)
        
        self.events = eventStore.events(matching: eventsPredicate).sorted() {
            (e1: EKEvent, e2: EKEvent) -> Bool in
            return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
            
        }
    }
    func loadReminderList() {
        self.reminderList = eventStore.calendars(for: .reminder)
    }
    
    func loadReminderItems() {
        
        let eventsPredicate = eventStore.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars:reminderList)
        self.eventStore.fetchReminders(matching: eventsPredicate, completion: {
            (reminders: [EKReminder]?) -> Void in
            self.reminders = reminders
        })
        
        
    }
    
    func refreshTableView() {
        self.tableView.reloadData()
    }
    
    func checkState() {
        let calStatus = EKEventStore.authorizationStatus(for: EKEntityType.event)
        let remStatus = EKEventStore.authorizationStatus(for: EKEntityType.reminder)
        
        if calStatus == EKAuthorizationStatus.notDetermined && remStatus == EKAuthorizationStatus.notDetermined {
            requestAccessToReminder()
            requestAccessToCalendar()
        }
        if calStatus == EKAuthorizationStatus.authorized && remStatus == EKAuthorizationStatus.authorized{
            loadData()
            
            sources = eventStore.sources
            if sources![0].title == "iCloud" || sources![0].title == "Default"{
                defaultSource = sources![0]
            }else if sources![1].title == "Default"{
                defaultSource = sources![1]
            }
            
            self.tableView.isHidden = false
            self.welcomeView.isHidden = true
            addButton.isEnabled = true
        }else{
        
        switch (calStatus) {
    
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            calStateLabel.text = "尚未获取日历访问权限"
        default:
            calStateLabel.text = ""
        }

        switch (remStatus) {
       
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            remStateLabel.text = "尚未获取提醒事项访问权限"
        default:
            remStateLabel.text = ""
        }
    
        }
    }
    
    
    @IBAction func privacySettingButton(_ sender: Any) {
        if let url = URL(string: UIApplicationOpenSettingsURLString){
            if (UIApplication.shared.canOpenURL(url)){
                UIApplication.shared.open(url, options:[UIApplicationOpenURLOptionUniversalLinksOnly:false], completionHandler: nil)
            }
        }
    }
    @IBAction func addButton(_ sender: Any) {
        
        let s = UIStoryboard(name: "Main", bundle: nil)
        let controller = s.instantiateViewController(withIdentifier: "NewItemController") as! NewItemController
        let newReminder = EKReminder(eventStore: eventStore)
       
        if eventStore.defaultCalendarForNewReminders() != nil {
            newReminder.calendar = eventStore.defaultCalendarForNewReminders()
            controller.identifier = 0
        }else{
            let newList = EKCalendar(for: .reminder, eventStore: eventStore)
            newList.title = "待办事项"
            newList.source = defaultSource
            controller.identifier = 3
            do {
                try eventStore.saveCalendar(newList, commit: true)
                print(1)
            }catch{
                print("error")
            }
            newReminder.calendar = newList
        }
        
        controller.eventStore = eventStore
        controller.reminder = newReminder
        self.present(controller, animated: true, completion: nil)
    }
    
}

