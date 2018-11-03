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
    var time = Date()
    var locationmanager = CLLocationManager()
    let notification = UILocalNotification()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUserDefualtsValues()
        getDatePicketSetTime()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in}
            
        } else {
               self.navigationController?.popViewController(animated: true)
               return
            // Fallback on earlier versions
        }}
    
    func setUpUserDefualtsValues() {
        if let setTime = UserDefaults.standard.object(forKey: "TIME_SET_IN_PICKER") as? String {
            print(setTime)
            UserDefaults.standard.synchronize()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd,hh:mm aa"
            if let dte = formatter.date(from: setTime) {
                timePicker.setDate(dte , animated: true)
            }
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
            return
        }
    }
    
    @IBAction func timePickerTapped(_ sender: UIDatePicker){
        if sendAlertSwitch.isOn == true {
            getDatePicketSetTime()
        }else {
            let alert = UIAlertController(title: "Hello!", message: "Please toggle the switch to on state to set the time", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default)
            {
                (UIAlertAction) -> Void in
                self.sendAlertSwitch.setOn(true, animated: true)
                self.setAlertAtSunsetButton.setImage(#imageLiteral(resourceName: "check-box-empty.png"), for: .normal)
            }
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getDatePicketSetTime() {
    //  check current date if the date in is list of array trigger notification for specified time
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: timePicker.date)
        let dateAvailableInArray = isCardAvailableForDate(date: dateString)
        notification.repeatInterval = NSCalendar.Unit.day
        dateFormatter.dateFormat = "yyyy-MM-dd,hh:mm aa"
        let dateWithTimeString = dateFormatter.string(from: timePicker.date)
        print(dateWithTimeString)
        UserDefaults.standard.removeObject(forKey: "TIME_SET_IN_PICKER")
        UserDefaults.standard.set(dateWithTimeString, forKey: "TIME_SET_IN_PICKER")
        UserDefaults.standard.synchronize()
        time = dateFormatter.date(from: dateWithTimeString)!
        if dateAvailableInArray == true && sendAlertSwitch.isOn == true {
                notification.fireDate = time
                notification.alertTitle = "Test"
                notification.alertBody = "Yeh it works!"
                notification.applicationIconBadgeNumber = 1
                UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    func isCardAvailableForDate(date:String)->Bool {
        if Server.shared.array.contains(where: { $0.date == date }) {
            print("found")
            return true
        } else {
            print("Notfound")
            return false
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
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: Date())
            let dateAvailableInArray = isCardAvailableForDate(date: dateString)
            notification.repeatInterval = NSCalendar.Unit.day
            if dateAvailableInArray == true && setAlertAtSunsetButton.imageView?.image == #imageLiteral(resourceName: "check-box-filled.png") {
                self.findMyCurrentLocation()
            }
        } else {
            UserDefaults.standard.removeObject(forKey: "SUNSETBUTTON_STATE")
            UserDefaults.standard.set(false, forKey: "SUNSETBUTTON_STATE")
            UserDefaults.standard.synchronize()
            setAlertAtSunsetButton.setImage(#imageLiteral(resourceName: "check-box-empty.png"), for: .normal)
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
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        let location = CLLocation()
        locationmanager.stopUpdatingLocation()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateSunInfo = EDSunriseSet.sunriseset(with:currentDateTime ,timezone: NSTimeZone.local,latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let startSunsetTime: Date? = startDateSunInfo?.sunset
        print(startSunsetTime as Any)
        dateFormatter.dateFormat = "yyyy-MM-dd,hh:mm:ss aa"
        let dateWithTimeString = dateFormatter.string(from: startSunsetTime!)
        print(dateWithTimeString)
        time = dateFormatter.date(from: dateWithTimeString)!
        notification.fireDate = time
        notification.alertTitle = "Test"
        notification.alertBody = "Yeh it works!"
        notification.applicationIconBadgeNumber = 1
        UIApplication.shared.scheduleLocalNotification(notification)
    
    }
}
