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

enum AlarmType: String {
    case custom
    case sunset
    case none
}

class Alarm: NSObject, NSCoding {
    static let alarmKey = "AlarmKey"
    var type: AlarmType = .none
    var time: Date

    init(type: AlarmType, time: Date) {
        self.type = type
        self.time = time
    }

    required convenience init(coder aDecoder: NSCoder) {
        let _typeString = aDecoder.decodeObject(forKey: "type") as? String ?? AlarmType.none.rawValue
        let _type = AlarmType(rawValue: _typeString) ?? .none
        let _time = aDecoder.decodeObject(forKey: "time") as? Date ?? Date(timeIntervalSince1970: 0)
        self.init(type: _type, time: _time)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(type.rawValue, forKey: "type")
        aCoder.encode(time, forKey: "time")
    }

    func save() {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(encodedData, forKey: Alarm.alarmKey)
        UserDefaults.standard.synchronize()
    }

    static func savedAlarm() -> Alarm {
        guard let decoded  = UserDefaults.standard.data(forKey: Alarm.alarmKey),
            let alarm = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Alarm else {
            return Alarm(type: .none, time: Date(timeIntervalSince1970: 0))
        }
        return alarm
    }
}

@objc class SetAlertViewController: UIViewController,CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    private enum Constants {
        static let SWITCH_STATE = "SWITCH_STATE"
        static let TIME_SET_IN_PICKER = "TIME_SET_IN_PICKER"
        static let SUNSETBUTTON_STATE = "SUNSETBUTTON_STATE"
    }

    var alarm: Alarm = Alarm.savedAlarm()

    @IBOutlet var sunsetAlarmButton: UIButton!
    @IBOutlet var customAlarmButton: UIButton!

    @IBOutlet var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet var datePickerHeight: NSLayoutConstraint!
    @IBOutlet var timePicker: UIDatePicker!
    @objc var isFromIphone = false
    var locationmanager = CLLocationManager()
    let notification = UILocalNotification()
    @IBOutlet var verticalSpacing: NSLayoutConstraint!
    let dateFormatter = DateFormatter()
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.layer.borderColor = UIColor.black.cgColor
        timePicker.layer.borderWidth = 1.0
        timePicker.layer.cornerRadius = 4.0
        setupButtons()
        findMyCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in}
        } else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        if isFromIphone == false {
            self.leftBarButtonItem.image = #imageLiteral(resourceName: "Omer-new-cover-text")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        alarm.save()
    }

    func setupButtons() {
        customAlarmButton.isSelected = (alarm.type == .custom)
        sunsetAlarmButton.isSelected = (alarm.type == .sunset)
        timePicker.date = alarm.time
    }

    // MARK: - IB ACTIONS
    @IBAction func sendAlertSwitchButtonTapped(_ button: UIButton) {
        removeAllActiveNotification()
        if button.isSelected {
            button.isSelected = false
            alarm.type = .none
        } else {
            button.isSelected = true
            sunsetAlarmButton.isSelected = false
            alarm.type = .custom
            setLocalNotificationsForCustomTime()
        }
    }
    
    @IBAction func timePickerTapped(_ sender: UIDatePicker){
        if alarm.type == .custom {
            removeAllActiveNotification()
            setLocalNotificationsForCustomTime()
        }
    }

    @IBAction func setAlertAtSunsetTapped(_ button: UIButton) {
        if CLLocationManager.locationServicesEnabled()  {
            setAlarmAtSunsetTime(button: button)
        } else {
            showAcessDeniedAlert()
        }
    }

    func setAlarmAtSunsetTime(button: UIButton) {
        removeAllActiveNotification()
        if button.isSelected {
            button.isSelected = false
            alarm.type = .none
        } else {
            button.isSelected = true
            customAlarmButton.isSelected = false
            alarm.type = .sunset
            setLocalNotificationsForSunsetTime()
        }
    }

    func sunsetTime(for dateString: String) -> Date {
        guard let location = currentLocation else {
            showAlert("Fetching location")
            return Date()
        }
        dateFormatter.dateFormat = "yyyy-MM-dd,hh:mm:ss z"
        let currentLocalDateTime = dateFormatter.date(from: dateString + ",00:00:00 +0000")
        let startDateSunInfo = EDSunriseSet.sunriseset(with: currentLocalDateTime,
                                                       timezone: TimeZone.current,
                                                       latitude: location.coordinate.latitude,
                                                       longitude: location.coordinate.longitude)

        guard let startSunsetTime: Date = startDateSunInfo?.sunset else {
            showAlert("Fetching location")
            return Date()
        }
        return startSunsetTime
    }

    func setLocalNotificationsForSunsetTime() {
        var index = 0
        for item in Server.shared.array {
            let time = sunsetTime(for: item.date!)
            var title: String = item.title ?? ""
            index += 1
            if (Server.shared.array.count > index) {
                //let nextItem = Server.shared.array[index]
                //title = nextItem.title ?? item.title ?? ""
            }
            addLocalNotification(date: time, title: title)
        }
    }

    func setLocalNotificationsForCustomTime() {
        var index = 0
        for item in Server.shared.array {
            index += 1
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let dateString = item.date else { continue }
            dateFormatter.dateFormat = "hh:mm:ss aa"
            dateFormatter.timeZone = TimeZone.current
            let TimeFromPicker = dateFormatter.string(from: timePicker.date)
            let dateWithTimeInStr = dateString + "," + TimeFromPicker
            dateFormatter.dateFormat = "yyyy-MM-dd,hh:mm:ss aa"
            alarm.time = timePicker.date
            let time = dateFormatter.date(from: dateWithTimeInStr)!
            var title: String = item.title ?? ""

            let sunSetTime = sunsetTime(for: item.date!)
            let interval = Double(NSTimeZone.system.secondsFromGMT()) as TimeInterval
            let now = Date().addingTimeInterval(interval)

            let isSunSetCompleted = now.compare(sunSetTime) == .orderedDescending

            if (isSunSetCompleted && Server.shared.array.count > index ) {
                //let nextItem = Server.shared.array[index]
                //title = nextItem.title ?? item.title ?? ""
            }
            addLocalNotification(date: time, title: title)
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
    
    func findMyCurrentLocation() {
        locationmanager = CLLocationManager()
        locationmanager.delegate = self
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
    }

    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        locationmanager.stopUpdatingLocation()
    }
    
    func addLocalNotification(date: Date, title:String) {
        notification.fireDate = date
        notification.alertTitle = title
        notification.alertBody = "Click here to see card of the day"
        notification.applicationIconBadgeNumber = 1
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func removeAllActiveNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
}

public extension UIViewController {
    @objc public func showAlert(_ title: String) {
        self.showAlert(title, message: "")
    }
    @objc public func showAlert(_ title: String, message: String) {
        self.showAlert(title, message: message, onDismiss: nil)
    }
    @objc public func showAlert(_ title: String, message: String, onDismiss:(() -> Void)?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (_ action) in
            onDismiss?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
