//
//  LocalNotification.swift
//  NuSignUp_Example
//
//  Created by Nucleus on 30/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotification{
    
    class func showValidationCodeNotif(WithCode code:String,Delay delay:TimeInterval = 3){
        let content = UNMutableNotificationContent()

        content.title = "NuSignUp Example"
        content.body = "VALIDATION CODE: "+code//"Avaliação \(index + 1) de \(times.count)"
        
        let id = "\(Date().timeIntervalSince1970)"
        
        var trigger:UNCalendarNotificationTrigger?
        if delay > 0{
            let calendar = Calendar.current
            let component = calendar.dateComponents([.year,.day,.month,.hour,.minute,.second], from: Date()+delay)
            trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        }

        let localNotif = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(localNotif, withCompletionHandler: { (error) in
            guard let _ = error else{
                return
            }
        })
    }
    
}
