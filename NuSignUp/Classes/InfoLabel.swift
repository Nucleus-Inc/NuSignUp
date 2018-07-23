//
//  InfoLabel.swift
//  NuiOS
//
//  Created by Nucleus on 23/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

public class InfoLabel: UILabel {
    
    public enum Style{
        case warning
        case success
        case error
        case normal
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    @IBInspectable
    public var normalTextColor:UIColor = UIColor.black
    @IBInspectable
    public var warningTextColor:UIColor = UIColor(red: 254/255, green: 193/255, blue: 6/255, alpha: 1)
    @IBInspectable
    public var errorTextColor:UIColor = UIColor(red: 200/255, green: 38/255, blue: 71/255, alpha: 1)
    @IBInspectable
    public var successTextColor:UIColor = UIColor(red: 113/255, green: 186/255, blue: 81/255, alpha: 1)

    public var style:InfoLabel.Style = .normal{
        didSet{
            updateForStyle()
        }
    }
    
    override public var text: String?{
        didSet{
            updateForStyle()
        }
    }
    
    private func updateForStyle(){
        switch style {
        case .warning:
            self.textColor = warningTextColor
        case .normal:
            self.textColor = normalTextColor
        case .error:
            self.textColor = errorTextColor
        case .success:
            self.textColor = successTextColor
        }
    }
    
}
