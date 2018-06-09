//
//  FirstLaunchViewController.swift
//  gtd_test
//
//  Created by 聂润泽 on 2018/5/2.
//  Copyright © 2018年 Razr. All rights reserved.
//

import UIKit
import EventKit
class FirstLaunchViewController: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    let eventStore = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(patternImage: UIImage(named: "background.png")!)
        
        let calStatus = EKEventStore.authorizationStatus(for: EKEntityType.event)
        let remStatus = EKEventStore.authorizationStatus(for: EKEntityType.reminder)
        
        if calStatus == EKAuthorizationStatus.notDetermined && remStatus == EKAuthorizationStatus.notDetermined {
            requestAccessToCalendar()
            requestAccessToReminder()
        }
    }
    

    @IBAction func tapButton(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "navigation")
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
//                    self.checkState()
                })
            }else{
//                print("error")
            }
        })
    }
    func requestAccessToReminder() {
        eventStore.requestAccess(to: EKEntityType.reminder, completion: {
            (accessGranted: Bool, error: Error?) in
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
//                    self.checkState()
                })
            }else{
//                print("error")
            }
        })
    }
}
