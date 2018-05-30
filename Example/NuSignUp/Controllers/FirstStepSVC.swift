//
//  FirstStepSVC.swift
//  NuSignUp_Example
//
//  Created by Nucleus on 30/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import NuSignUp

class FirstStepSVC: SignUpNameSVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackBtn()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpBackBtn(){
        if stepNumber <= 1 && delegate.reviewMode == .none{
            let closeAllBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(FirstStepSVC.closeAllBtnAction(sender:)))
            self.navigationItem.leftBarButtonItem = closeAllBtn
        }
    }
    
    @objc
    private func closeAllBtnAction(sender:Any){
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let alertC = UIAlertController(title: "Cancel Sign up", message: "You will lose all added informations.\n\nDo you want to continue?", preferredStyle: .alert)
        alertC.addAction(yesAction)
        alertC.addAction(noAction)
        self.present(alertC, animated: true, completion: nil)
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
