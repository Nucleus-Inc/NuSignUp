//
//  SignUpNavController.swift
//
//  Created by Nucleus on 08/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

class SignUpNavController: UINavigationController,SignUpStackC {

    private var progressView:UIProgressView!

    @IBInspectable var numbOfSteps:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationAppearance()
        addProgressView()
        // Do any additional setup after loading the view.
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

    
    private func setUpNavigationAppearance(){
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = UIColor.clear//insivible
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        let subViews = navigationBar.subviews.filter({ (view) -> Bool in
            return view.tag == 100
        })
    }
    
    private func addProgressView(){
        let subViews = navigationBar.subviews.filter({ (view) -> Bool in
            return view.tag == 100
        })
        
        if subViews.count == 1{
            progressView = subViews[0] as! UIProgressView
        }
        else{
            progressView = UIProgressView()
            progressView.progressTintColor = self.navigationBar.tintColor
            progressView.trackTintColor = UIColor.lightGray.withAlphaComponent(0.3)
            progressView.translatesAutoresizingMaskIntoConstraints = false
            
            let heightC = NSLayoutConstraint(item: progressView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2)
            progressView.addConstraint(heightC)
            
            self.navigationBar.addSubview(progressView)
            
            let topDistC = NSLayoutConstraint(item: progressView, attribute: .top, relatedBy: .equal, toItem: self.navigationBar, attribute: .top, multiplier: 1, constant: 2)
            self.navigationBar.addConstraint(topDistC)
            
            let leadingDistC = NSLayoutConstraint(item: progressView, attribute: .leading, relatedBy: .equal, toItem: self.navigationBar, attribute: .leading, multiplier: 1, constant: 5)
            self.navigationBar.addConstraint(leadingDistC)
            
            let trailingDistC = NSLayoutConstraint(item: progressView, attribute: .trailing, relatedBy: .equal, toItem: self.navigationBar, attribute: .trailing, multiplier: 1, constant: -5)
            self.navigationBar.addConstraint(trailingDistC)
        }
    }
    
    
    public func updateForStep(step:Int){
        self.progressView.setProgress(Float(step)/Float(numbOfSteps), animated: true)
    }

    
    
}
