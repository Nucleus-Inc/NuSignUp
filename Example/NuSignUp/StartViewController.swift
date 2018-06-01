//
//  StartViewController.swift
//  NuSignUp_Example
//
//  Created by Nucleus on 30/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import NuSignUp
import UserNotifications

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SignUpStack.config.baseStepDelegateType(ExampleSignUpDelegate.self)
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else {
                UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "Local Notification", Message: "These notifications will only be used to simulate receiving a code for sign up.")
                return
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
