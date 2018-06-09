//
//  NewItemController.swift
//  gtd_test
//
//  Created by 聂润泽 on 2018/1/16.
//  Copyright © 2018年 Razr. All rights reserved.
//

import UIKit
import EventKit
import IQKeyboardManagerSwift

class NewItemController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alertSwitch: UISwitch!

    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var priorityToTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var prioritySegmented: UISegmentedControl!
    @IBOutlet weak var reminderListLabel: UILabel!
    @IBOutlet weak var titleToNavigationConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var nav: UINavigationItem!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var reminderLIstLabel: UILabel!
    
    @IBOutlet weak var reminderListPickerView: UIPickerView!
    
    
    var eventStore: EKEventStore!
    var reminderlist: [EKCalendar]?
    var reminder: EKReminder!
    var newEvent: EKEvent!
    var identifier = 0
    var defaultRow: Int!
    var returnKeyHandler:IQKeyboardReturnKeyHandler?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.returnKeyHandler = IQKeyboardReturnKeyHandler.init(controller: self)
        self.returnKeyHandler!.lastTextFieldReturnKeyType =  UIReturnKeyType.done
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        titleTextField.backgroundColor = UIColor.clear
        priorityLabel.backgroundColor = UIColor.clear
        listLabel.backgroundColor = UIColor.clear
        reminderListPickerView.backgroundColor = UIColor.clear
        
        reminderListPickerView.delegate = self
        reminderListPickerView.dataSource = self
        
        nav.title = "提醒事项"
        
        //************
        // 设置导航栏前景色：设置item指示色
//        navigationBar.tintColor = UIColor.orange
        
        // 设置导航栏半透明
        navigationBar.isTranslucent = true
        
        // 设置导航栏背景图片
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        // 设置导航栏阴影图片
        navigationBar.shadowImage = UIImage()
        //*************
        
        saveButtonOutlet.isEnabled = false
        
        alertSwitch.setOn(false, animated: false)
        alertSwitch(self)
        priorityToTextFieldConstraint.constant = 20
        
        datePicker.calendar = Calendar.current
        datePicker.locale = Locale(identifier: "zh_CN")
        
        reminderlist = eventStore.calendars(for: .reminder)
        
        reminderListLabel.text = reminder.calendar.title
        
        datePicker.locale = Locale.autoupdatingCurrent
        titleToNavigationConstraint.constant = 20
        // 1表示从编辑跳转过来，0表示新建
        if identifier == 1 {

            titleToNavigationConstraint.constant = 20
            titleTextField.text = reminder.title
            if reminder.dueDateComponents != nil {
                alertSwitch.setOn(true, animated: false)
                alertSwitch(self)
                let calendar = Calendar.current
                datePicker.date = calendar.date(from: reminder.dueDateComponents!)!
                
            }else {
                
                alertSwitch.setOn(false, animated: false)
                alertSwitch(self)
            }
            
            switch reminder.priority {
            case 0:
                prioritySegmented.selectedSegmentIndex = 0
            case 9:
                prioritySegmented.selectedSegmentIndex = 1
            case 5:
                prioritySegmented.selectedSegmentIndex = 2
            case 1:
                prioritySegmented.selectedSegmentIndex = 3
            default:
                prioritySegmented.selectedSegmentIndex = 0
            }
            
        }
        
        titleTextField.addTarget(self, action: #selector(checkTextField), for: .allEditingEvents)
    }
    
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        reminderListPickerView.selectRow(defaultRow, inComponent: 0, animated: true)
        if identifier == 3 {
            self.view.makeToast(message: "当前不存在提醒事项列表，已创建新列表", duration: 2, position: HRToastPositionCenter as AnyObject)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            titleTextField.resignFirstResponder()
        }
        return true
    }
    
    @objc func checkTextField(textField:UITextField) {
        if textField.text == "" {
            saveButtonOutlet.isEnabled = false
        }else{
            saveButtonOutlet.isEnabled = true
        }
    }
    
    
    
    //pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reminderlist!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if reminderlist![row].title == reminder.calendar.title{
            defaultRow = row
            
        }
        return reminderlist![row].title
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reminderListLabel.text = reminderlist![reminderListPickerView.selectedRow(inComponent: 0)].title

    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        titleTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func alertSwitch(_ sender: Any) {
        if alertSwitch.isOn {
            priorityToTextFieldConstraint.constant = 150
            self.datePicker.isHidden = false
            titleTextField.resignFirstResponder()
        }else{
            self.datePicker.isHidden = true
            priorityToTextFieldConstraint.constant = 20
            titleTextField.becomeFirstResponder()
        }
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        saveReminder(reminder: reminder)
    }
    
    
    func saveReminder(reminder:EKReminder) -> Void {
        reminder.title = titleTextField.text
        reminder.calendar = reminderlist![reminderListPickerView.selectedRow(inComponent: 0)]
        reminder.isCompleted = false
        
        switch prioritySegmented.selectedSegmentIndex {
        case 0:
            reminder.priority = 0
        case 1:
            reminder.priority = 9
        case 2:
            reminder.priority = 5
        case 3:
            reminder.priority = 1
        default:
            reminder.priority = 0
        }
        
        if alertSwitch.isOn{
            let calendar = Calendar.current
            //拆分 Date 到 DateComponents
            let datecomponent = calendar.dateComponents(in: .autoupdatingCurrent, from: datePicker.date)
            reminder.startDateComponents = datecomponent
            reminder.dueDateComponents = datecomponent
        }else {
            reminder.startDateComponents = nil
            reminder.dueDateComponents = nil
        }
        do {
            try eventStore.save(reminder, commit: true)
            self.dismiss(animated: true, completion: nil)
        }catch{
            print("error")
        }
    }
    
    
    
}
