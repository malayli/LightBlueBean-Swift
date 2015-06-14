//
//  MLKBeanHeaderCell.swift
//  Malik Alayli
//
//  Created by Malik Alayli on 13/06/15.
//  Copyright (c) 2015 Malik Alayli. All rights reserved.
//

import UIKit

import Bean_iOS_OSX_SDK

class MLKBeanHeaderCell: UITableViewCell {
    
    var bean: PTDBean?
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var rssiLabel: UILabel?
    @IBOutlet weak var statusLabel: UILabel?

    func configureSubviews() {
        self.nameLabel!.text = self.bean!.name
        self.rssiLabel!.text = self.bean!.RSSI?.stringValue
        
        var state: String?
        
        switch (self.bean!.state) {
            case BeanState.Unknown:
                state = "Unknown"
                break
            
            case BeanState.Discovered:
                state = "Disconnected"
                break
            
            case BeanState.AttemptingConnection:
                state = "Connecting..."
                break
            
            case BeanState.AttemptingValidation:
                state = "Connecting..."
                break
            
            case BeanState.ConnectedAndValidated:
                state = "Connected"
                break
            
            case BeanState.AttemptingDisconnection:
                state = "Disconnecting..."
                break
            
            default:
                state = "Invalid"
                break
        }
        self.statusLabel!.text = state
    }
}
