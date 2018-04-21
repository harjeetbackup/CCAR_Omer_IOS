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

@objc class SetAlertViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var sendAlertSwitch: UISwitch!
    @IBOutlet var setAlertAtSunsetButton: UIButton!

    var locationmanager = CLLocationManager()
    let notification = UILocalNotification()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in}
            
        } else {
            self.navigationController?.popViewController(animated: true)
            return
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUserDefualtsValues()
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
        sendAlertSwitch.setOn((state as? Bool ?? false), animated: true)
        let val:Bool = (UserDefaults.standard.object(forKey: "SUNSETBUTTON_STATE") as? Bool ?? false)
        if val == true {
            SunsetAlert()
            setAlertAtSunsetButton.setImage(#imageLiteral(resourceName: "check-box-filled.png"), for: .normal)
        }else {
            setAlertAtSunsetButton.setImage(#imageLiteral(resourceName: "check-box-empty.png"), for: .normal)
        }
    }
    
    @IBAction func sendAlertSwitchButtonTapped(_ sender: Any) {
        if sendAlertSwitch.isOn {
            self.removeAllActiveNotification()
            getDatePicketSetTime()
            sendAlertSwitch.setOn(true, animated: true)
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
            sendAlertSwitch.setOn(false, animated: true)
            self.removeAllActiveNotification()
            return
        }
    }
    
    @IBAction func timePickerTapped(_ sender: UIDatePicker){
        if sendAlertSwitch.isOn == true {
            self.removeAllActiveNotification()
            getDatePicketSetTime()
        } else {
            let alert = UIAlertController(title: "Hello!", message: "Please toggle the switch to on state to set the time", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default)
            {
                (UIAlertAction) -> Void in
                self.sendAlertSwitch.setOn(true, animated: true)
                UserDefaults.standard.removeObject(forKey: "SWITCH_STATE")
                UserDefaults.standard.set(true, forKey: "SWITCH_STATE")
                UserDefaults.standard.synchronize()
                self.removeAllActiveNotification()
                self.getDatePicketSetTime()
                self.setAlertAtSunsetButton.setImage(#imageLiteral(resourceName: "check-box-empty.png"), for: .normal)
            }
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
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
//            dateFormatter.timeZone = TimeZone.current
            UserDefaults.standard.removeObject(forKey: "TIME_SET_IN_PICKER")
           // UserDefaults.standard.set(dateWithTimeInStr, forKey: "TIME_SET_IN_PICKER")
            UserDefaults.standard.set(timePicker.date, forKey: "TIME_SET_IN_PICKER")
            UserDefaults.standard.synchronize()
            let time = dateFormatter.date(from: dateWithTimeInStr)!
            print(time)
            triggerNotification(date: time)
            }
        }
    }
    
    @IBAction func setAlertAtSunsetTapped(_ sender: Any) {
       SunsetAlert()
    }
    
    func SunsetAlert() {
        if setAlertAtSunsetButton.imageView?.image == #imageLiteral(resourceName: "check-box-empty.png") {
            setAlertAtSunsetButton.setImage(#imageLiteral(resourceName: "check-box-filled.png"), for: .normal)
            sendAlertSwitch.setOn(false, animated: true)
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
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let currentDateTime = dateFormatter.date(from: item.date!)
            let location = CLLocation()
            locationmanager.stopUpdatingLocation()
            let startDateSunInfo = EDSunriseSet.sunriseset(with:currentDateTime ,timezone:  NSTimeZone.local,latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let startSunsetTime: Date? = startDateSunInfo?.sunset
//            print("SunsetTime time \(startSunsetTime)")
//            dateFormatter.dateFormat = "yyyy-MM-dd,hh:mm aa"
//            let dateWithTimeString = dateFormatter.string(from: startSunsetTime ?? Date())
//            print("local time \(dateWithTimeString)")
//            //sunset time varying
//            let time = dateFormatter.date(from: dateWithTimeString)!
            triggerNotification(date: (startDateSunInfo?.sunset)!)
            print("utc time \(startDateSunInfo?.sunset)")
        }
    }
    
    func triggerNotification(date: Date) {
        notification.fireDate = date
        notification.alertTitle = "Test"
        notification.alertBody = "Yeh it works!"
        notification.applicationIconBadgeNumber = 1
        UIApplication.shared.scheduleLocalNotification(notification)
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
}
