//
//  MLKBeanDetailController.swift
//  Malik Alayli
//
//  Created by Malik Alayli on 13/06/15.
//  Copyright (c) 2015 Malik Alayli. All rights reserved.
//

import UIKit

import Bean_iOS_OSX_SDK

class MLKBeanDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate, PTDBeanManagerDelegate, PTDBeanDelegate {
    
    var beanManager : PTDBeanManager?
    
    var bean: PTDBean?
    
    @IBOutlet weak var connectButton: UIBarButtonItem?
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.update()
    }
    
    func update() {
        if (self.bean!.state == BeanState.Discovered) {
            self.connectButton!.title = "Connect"
            self.connectButton!.enabled = true
            
        } else if (self.bean!.state == BeanState.ConnectedAndValidated) {
            self.connectButton!.title = "Disconnect"
            self.connectButton!.enabled = true
        }
        
        self.tableView?.reloadData()
    }
    
    // MARK: - BeanManagerDelegate Callbacks
    
    func beanManagerDidUpdateState(beanManager: PTDBeanManager!) {
        
    }
    
    func beanManager(beanManager: PTDBeanManager!, didDiscoverBean bean: PTDBean!, error: NSError!) {
        
    }
    
    func beanManager(beanManager: PTDBeanManager!, didConnectBean bean: PTDBean!, error: NSError! = nil) {
        if ((error) != nil) {
            NSLog("%@", error.localizedDescription);
            return
        }
        
        var theError: NSError?
        
        self.beanManager?.stopScanningForBeans_error(&theError)
        
        if ((theError) != nil) {
            NSLog("%@", theError!.localizedDescription);
            return
        }
        self.update()
    }
    
    func beanManager(beanManager: PTDBeanManager!, didDisconnectBean bean: PTDBean!, error: NSError!) {
        if (bean == self.bean) {
            self.update()
        }
    }
    
    // MARK: - BeanDelegate
    
    func bean(bean: PTDBean!, error: NSError!) {
        let alert: UIAlertView = UIAlertView(title: "Error", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok")
        alert.show()
    }
    
    // MARK: - IBActions
    
    @IBAction func connectButtonPressed(sender: AnyObject) {
        if (self.bean!.state == BeanState.Discovered) {
            self.bean!.delegate = self
            self.beanManager?.connectToBean(self.bean, error: nil)
            self.beanManager?.delegate = self
            self.connectButton?.enabled = false
            
        } else {
            self.bean!.delegate = self
            self.beanManager?.disconnectBean(self.bean, error: nil)
        }
        
        self.tableView?.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    let CellIdentifier = "BeanListCell";
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MLKBeanHeaderCell?
        
        if (indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? MLKBeanHeaderCell
            cell!.bean = self.bean
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.configureSubviews()
        }
        
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Beans";
    }
    
    deinit {
        self.bean?.delegate = nil
    }
}
