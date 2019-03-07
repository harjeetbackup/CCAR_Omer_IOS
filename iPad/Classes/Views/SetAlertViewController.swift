//
//  SetAlertViewController.swift
//  Omer_Flash_Card
//
//  Created by Lavanya on 10/30/18.
//

import UIKit
import Foundation
import UserNotifications
import CoreLocation

@objc protocol GetTodaysReadingDelegate  {
    func getTodaysReading()
}

@objc class SetAlertViewController: UIViewController,CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet var datePickerHeight: NSLayoutConstraint!
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var setAlertAtSunsetButton: UIButton!
    @IBOutlet var sendAlertSwitch: UIButton!
    var isFromIphone = false
    var delegate : GetTodaysReadingDelegate?
    var locationmanager = CLLocationManager()
    let notification = UILocalNotification()
    @IBOutlet var verticalSpacing: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.layer.borderColor = UIColor.black.cgColor
        timePicker.layer.borderWidth = 1.0
        timePicker.layer.cornerRadius = 4.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in}
            
        } else {
            self.navigationController?.popViewController(animated: true)
            return
            // Fallback on earlier versions
        }
        setUpUserDefualtsValues()
        if isFromIphone == false {
            self.leftBarButtonItem.image = #imageLiteral(resourceName: "Omer-new-cover-text")
        }
    }
    
    
    func setUpUserDefualtsValues() {
        if let setTime = UserDefaults.standard.object(forKey: "TIME_SET_IN_PICKER") as? Date {
            print(setTime)
            UserDefaults.standard.synchronize()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd,hh:mm:ss aa"
            formatter.timeZone = NSTimeZone.local
            formatter.dateStyle = .short
            //if let dte = formatter.date(from: setTime)  {
                self.timePicker.setDate(setTime, animated: true)
           // }
        }
        let state = UserDefaults.standard.object(forKey: "SWITCH_STATE")
        UserDefaults.standard.synchronize()
        if state as? Bool == true {
            sendAlertSwitch.setImage(#imageLiteral(resourceName: "check-box-filled.png"), for: .normal)
            datePickerHeight.constant = 250.0
            verticalSpacing.constant = 25.0
        } else {
            sendAlertSwitch.setImage(#imageLiteral(resourceName: "check-box-empty.png"), for: .normal)
            datePickerHeight.constant = 0.0
            verticalSpacing.constant = 0.0
        }
//      sendAlertSwitch.setOn((state as? Bool ?? false), animated: true)
        let val:Bool = (UserDefaults.standard.object(forKey: "SUNSETBUTTON_STATE") as? Bool ?? false)
        if val == true {
            SunsetAlert()
            setAlertAtSunsetButton.setImage(#imageLiteral(resourceName: "check-box-filled.png"), for: .normal)
        }else {
            setAlertAtSunsetButton.setImage(#imageLiteral(resourceName: "check-box-empty.png"), for: .normal)
        }
    }
    
    @IBAction func sendAlertSwitchButtonTapped(_ sender: Any) {
        if sendAlertSwitch.imageView?.image == #imageLiteral(resourceName: "check-box-empty.png") {
            self.removeAllActiveNotification()
            getDatePicketSetTime()
            sendAlertSwitch.setImage(#imageLiteral(resourceName: "check-box-filled.png"), for: .normal)
            datePickerHeight.constant = 250.0
            verticalSpacing.constant = 25.0
            UserDefaults.standard.removeObject(forKey: "SWITCH_STATE")
            UserDefaults.standard.set(true, forKey: "SWITCH_STATE")
            UserDefaults.standard.synchronize()
            setAlertAtSunsetButton.setImage(#imageLiteral(resourceName: "check-box-empty.png"), for: .normal)
            UserDefaults.standard.removeObject(forKey: "SUNSETBUTTON_STATE")
            UserDefaults.standard.set(false, forKey: "SUNSETBUTTON_STATE")
            UserDefaults.standard.synchronize()
            return
        } else {
            UserDefaults.standard.removeObject(forKey: "SWITCH_STATE")
            UserDefaults.standard.set(false, forKey: "SWITCH_STATE")
            UserDefaults.standard.synchronize()
            sendAlertSwitch.setImage(#imageLiteral(resourceName: "check-box-empty.png"), for: .normal)
            datePickerHeight.constant = 0.0
            verticalSpacing.constant = 0.0
            self.removeAllActiveNotification()
            return
        }
    }
    
    @IBAction func timePickerTapped(_ sender: UIDatePicker){
        if datePickerHeight.constant == 250.0 {
            self.removeAllActiveNotification()
            getDatePicketSetTime()
        } else {
            //return
        }
    }
    
    func getDatePicketSetTime() {
        for item in Server.shared.array {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let dte = item.date {
            let dateFromString = dte
            print(dateFromString)
            dateFormatter.dateFormat = "hh:mm:ss aa"
            dateFormatter.timeZone = TimeZone.current
            let TimeFromPicker = dateFormatter.string(from: timePicker.date)
            let dateWithTimeInStr = dateFromString + "," + TimeFromPicker
            dateFormatter.dateFormat = "yyyy-MM-dd,hh:mm:ss aa"
//          dateFormatter.timeZone = TimeZone.current
            UserDefaults.standard.removeObject(forKey: "TIME_SET_IN_PICKER")
//          UserDefaults.standard.set(dateWithTimeInStr, forKey: "TIME_SET_IN_PICKER")
            UserDefaults.standard.set(timePicker.date, forKey: "TIME_SET_IN_PICKER")
            UserDefaults.standard.synchronize()
            let time = dateFormatter.date(from: dateWithTimeInStr)!
            print(time)
                triggerNotification(date: time, title: item.title!)
            }
        }
    }
    
    @IBAction func setAlertAtSunsetTapped(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled()  {
            SunsetAlert()

        } else {
            showAcessDeniedAlert()
        }
    }
    
    func showAcessDeniedAlert() {
        let alertController = UIAlertController(title: "Location Accees Requested",
                                                message: "The location permission was not authorized. Please enable it in Settings to continue.",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            
            // THIS IS WHERE THE MAGIC HAPPENS!!!!
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appSettings as URL)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func SunsetAlert() {
        if setAlertAtSunsetButton.imageView?.image == #imageLiteral(resourceName: "check-box-empty.png") {
            setAlertAtSunsetButton.setImage(#imageLiteral(resourceName: "check-box-filled.png"), for: .normal)
            sendAlertSwitch.setImage(#imageLiteral(resourceName: "check-box-empty.png"), for: .normal)
            datePickerHeight.constant = 0.0
            verticalSpacing.constant = 0.0
            UserDefaults.standard.removeObject(forKey: "SUNSETBUTTON_STATE")
            UserDefaults.standard.set(true, forKey: "SUNSETBUTTON_STATE")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.removeObject(forKey: "SWITCH_STATE")
            UserDefaults.standard.set(false, forKey: "SWITCH_STATE")
            UserDefaults.standard.synchronize()
            if setAlertAtSunsetButton.imageView?.image == #imageLiteral(resourceName: "check-box-filled.png") {
                self.removeAllActiveNotification()
                self.findMyCurrentLocation()
            }
        } else {
            UserDefaults.standard.removeObject(forKey: "SUNSETBUTTON_STATE")
            UserDefaults.standard.set(false, forKey: "SUNSETBUTTON_STATE")
            UserDefaults.standard.synchronize()
            setAlertAtSunsetButton.setImage(#imageLiteral(resourceName: "check-box-empty.png"), for: .normal)
            self.removeAllActiveNotification()
        }
    }
    
    func findMyCurrentLocation() {
        locationmanager = CLLocationManager()
        locationmanager.delegate = self
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.stopUpdatingLocation()
        locationmanager.startUpdatingLocation()
    }

    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for item in Server.shared.array {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd,hh:mm:ss z"
            let currentLocalDateTime = dateFormatter.date(from: item.date! + ",00:00:00 +0000")
           // let smapledate = dateFormatter.date(from: "2018-11-16,11:40:00 +0000")
         //   print(smapledate)
          //  let location = CLLocation()
            locationmanager.stopUpdatingLocation()
            let startDateSunInfo = EDSunriseSet.sunriseset(with: currentLocalDateTime ,timezone:  TimeZone.current,latitude: (locations.first?.coordinate.latitude)!, longitude: (locations.first?.coordinate.longitude)!)
            let startSunsetTime: Date? = startDateSunInfo?.sunset
            print("SunsetTime time \(String(describing: startSunsetTime))")
            let dateWithTimeString = dateFormatter.string(from: startSunsetTime ?? Date())
            print("local sunset time \(dateWithTimeString)")
            //sunset time varying
           // let time = dateFormatter.date(from: dateWithTimeString)!
            if startSunsetTime != nil {
                triggerNotification(date: (startSunsetTime)!, title: item.title!)
                print("Local time \(String(describing: startDateSunInfo?.sunset))")
            }
        }
    }
    
    func triggerNotification(date: Date, title:String) {
        notification.fireDate = date
        if #available(iOS 8.2, *) {
            notification.alertTitle = title
        } else {
            // Fallback on earlier versions
        }
        notification.alertBody = "click here to see card of the day"
        notification.applicationIconBadgeNumber = 1
        UIApplication.shared.scheduleLocalNotification(notification)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: self)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func removeAllActiveNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            // Fallback on earlier versions
        }
    }
//    @available(iOS 10.0, *)
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
//        print("@@@@@")
//        delegate?.getTodaysReading()
//        completionHandler()
//    }
}
