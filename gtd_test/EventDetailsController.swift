//
//  EventDetailsController.swift
//  gtd_test
//
//  Created by 聂润泽 on 2018/1/15.
//  Copyright © 2018年 Razr. All rights reserved.
//

import UIKit
import EventKit

class EventDetailsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    var event: EKEvent!
    var eventStore: EKEventStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nil
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let backImageView = UIImageView()
        backImageView.image = UIImage(named: "background.png")
        backImageView.alpha = 0.7
        detailsTableView.backgroundView = backImageView


        self.navigationController?.setToolbarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.detailsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
        default:
            return 1
        }
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //第一组
        if indexPath[0] == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
            let timeFormatter = DateFormatter()
            let dateTimeFormatter_date = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            dateTimeFormatter_date.dateFormat = "dd"
            //cell半透明效果
            cell.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
            cell.textLabel?.backgroundColor = UIColor.clear
            //
            switch indexPath[1]{
            case 0:
                cell.textLabel?.text = event.title
                cell.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
                cell.detailTextLabel?.text = nil
            case 1:
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .ultraLight)
                let date = Date()
                
                let currentDate = dateTimeFormatter_date.string(from: date)
                let eventDate = dateTimeFormatter_date.string(from: event.startDate)
                if event.isAllDay == false{
                    
                    if currentDate != eventDate {
                        cell.textLabel?.text = "凌晨 " + timeFormatter.string(from: event.startDate) + " 至 " + timeFormatter.string(from: event.endDate)
                    }else {
                        cell.textLabel?.text = "今天 " + timeFormatter.string(from: event.startDate) + " 至 " + timeFormatter.string(from: event.endDate)
                    }
                
                }else {
                    if currentDate != eventDate {
                        cell.textLabel?.text = "明天"
                    }else {
                        cell.textLabel?.text = "全天"
                    }
                }
                cell.detailTextLabel?.text = nil
            default:
                return cell
            }
            return cell
        }
        
        
        //第二组
        if indexPath[0] == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
            cell.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.detailTextLabel?.backgroundColor = UIColor.clear
            switch indexPath[1] {

            case 0:
                cell.textLabel?.text = "日历"
                cell.detailTextLabel?.text = event.calendar.title
                if event.calendar.type != .subscription && event.calendar.type != .birthday {
                    cell.accessoryType = .disclosureIndicator
                }
            default:
                return cell
            }
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath[0] == 1 && tableView.cellForRow(at: indexPath)?.accessoryType == .disclosureIndicator {
            let s = UIStoryboard(name: "Main", bundle: nil)
            let controller = s.instantiateViewController(withIdentifier: "EditCalController") as! EditCalController
            controller.titleIdentifier = indexPath[1]
            controller.eventStore = eventStore
            controller.event = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    @IBAction func deleteEvent(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "删除日程", style: .destructive, handler: { _ in
            do{
                try self.eventStore.remove(self.event, span: .thisEvent, commit: true)
                self.navigationController?.popViewController(animated: true)
            }catch{
                print("error")
            }
            }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
