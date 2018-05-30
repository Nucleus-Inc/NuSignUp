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
    
    class func showValidationCodeNotif(WithCode code:String){
        let content = UNMutableNotificationContent()

        content.title = "NuSignUp Example"
        content.body = "VALIDATION CODE: "+code//"Avaliação \(index + 1) de \(times.count)"
        
        let id = "\(Date().timeIntervalSince1970)"
        let localNotif = UNNotificationRequest(identifier: id, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(localNotif, withCompletionHandler: { (error) in
            guard let _ = error else{
                return
            }
        })
    }
    
}
