//
//  MLKBeanListViewController.swift
//  Malik Alayli
//
//  Created by Malik Alayli on 13/06/15.
//  Copyright (c) 2015 Malik Alayli. All rights reserved.
//

import UIKit

import Bean_iOS_OSX_SDK

class MLKBeanListViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, PTDBeanManagerDelegate, PTDBeanDelegate {
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    var beans: NSMutableDictionary?
    
    var beanManager : PTDBeanManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.beans = NSMutableDictionary()
        
        // instantiating the bean starts a scan. make sure you have you delegates implemented
        // to receive bean info
        self.beanManager = PTDBeanManager(delegate: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.beanManager?.delegate = self
        
        self.tableView.reloadData()
    }
    
    // MARK: - Private functions
    
    func beanForRow(row: NSInteger) -> PTDBean {
        return self.beans!.allValues[row] as! PTDBean
    }
    
    // MARK: - BeanManagerDelegate Callbacks
    
    func beanManagerDidUpdateState(beanManager: PTDBeanManager!) {
        if(self.beanManager!.state == BeanManagerState.PoweredOn){
            self.beanManager?.startScanningForBeans_error(nil)
            
        } else if (self.beanManager!.state == BeanManagerState.PoweredOff) {
            let alert: UIAlertView = UIAlertView(title: "Error", message: "Turn on bluetooth to continue", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok")
            alert.show()
            return
        }
    }
    
    func beanManager(beanManager: PTDBeanManager!, didDiscoverBean bean: PTDBean!, error: NSError!) {
        var key: NSUUID = bean.identifier
        
        if (self.beans!.objectForKey(key) == nil) {
            // New bean
            NSLog("BeanManager:didDiscoverBean:error %@", bean);
            
            self.beans?.setObject(bean, forKey: key)
        }
        self.tableView.reloadData()
    }
    
    func beanManager(beanManager: PTDBeanManager!, didConnectBean bean: PTDBean!, error: NSError! = nil) {
        if ((error) != nil) {
            let alert: UIAlertView = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok")
            alert.show()
            return;
        }
        
        var theError: NSError? = nil
        
        self.beanManager?.stopScanningForBeans_error(&theError)
    
        if ((theError) != nil) {
            let alert: UIAlertView = UIAlertView(title: "Error", message: theError!.localizedDescription, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok")
            alert.show()
            return;
        }
        
        self.tableView.reloadData()
    }
    
    func beanManager(beanManager: PTDBeanManager!, didDisconnectBean bean: PTDBean!, error: NSError!) {
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    let CellIdentifier = "BeanListCell"
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var bean: PTDBean = self.beans!.allValues[indexPath.row] as! PTDBean
        
        var cell: MLKBeanHeaderCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! MLKBeanHeaderCell
        cell.bean = bean;
        cell.configureSubviews()
        return cell;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beans!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Beans";
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath: NSIndexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)!
        
        var bean: PTDBean = self.beans!.allValues[indexPath.row] as! PTDBean
        
        let destController: MLKBeanDetailController = segue.destinationViewController as! MLKBeanDetailController;
        destController.bean = bean
        destController.beanManager = self.beanManager
    }
    
    // MARK: - Actions
    
    @IBAction func handleRefresh(sender: AnyObject) {
        if(self.beanManager!.state == BeanManagerState.PoweredOn){
            var theError: NSError? = nil
            
            self.beanManager?.startScanningForBeans_error(&theError)
            
            if ((theError) != nil) {
                let alert: UIAlertView = UIAlertView(title: "Error", message: theError!.localizedDescription, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok")
                alert.show()
            }
        }
        
        (sender as! UIRefreshControl).endRefreshing()
    }
}
