//
//  TrackViewController.swift
//  movement
//
//  Created by Leesha Maliakal on 2/28/18.
//  Copyright © 2018 Delta Lab. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import Parse


class TrackViewController: UIViewController, UITextFieldDelegate {
    
    var user: PFUser = PFUser()
    var userMonitorTimer: Timer = Timer()
    var userMonitor: RunnerMonitor = RunnerMonitor()
    var interval: Int = Int()
    var userPath: Array<CLLocationCoordinate2D> = []
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userMonitor = RunnerMonitor()
        //        let startLine = CLLocationCoordinate2DMake(42.059182, -87.673772) //garage
        //        let startLine = CLLocationCoordinate2DMake(42.057102, -87.676943) //ford
        //        let startLine = CLLocationCoordinate2DMake(42.058175, -87.683502) //noyes el
        //        let startLine = CLLocationCoordinate2DMake(42.051169, -87.677232) //arch
        //        let startLine = CLLocationCoordinate2DMake(41.880852, -87.620669) //race
//        let startRegion = userMonitor.createStartRegion(startLine)
//        userMonitor.startMonitoringRegion(startRegion)
        
        
        interval = 60
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        
        //every 3 seconds, update the distance label and map with the runner's location if they are within the start region or have exited
        
        userMonitorTimer = Timer.scheduledTimer(timeInterval: Double(interval), target: self, selector: #selector(TrackViewController.monitorUser), userInfo: nil, repeats: true)
    }
    
    func monitorUser() {
        //monitor runner
        print("monitoring runner...")
        
        //start runner monitor
        userMonitor.monitorUserNetworkSpeed()
        userMonitor.monitorUserLocation()
        userMonitor.updateUserPath(interval)
        userMonitor.updateUserLocation()
        
        
        if UIApplication.shared.applicationState == .background {
            print("app status: \(UIApplication.shared.applicationState)")
            
            userMonitor.enableBackgroundLoc()
        }
        
        //create user path
        if (userMonitor.locationMgr.location!.coordinate.latitude == 0.0 && userMonitor.locationMgr.location!.coordinate.longitude == 0.0) {  //NOTE: nil here
            print("skipping coordinate")
        }
        else {
            userPath.append((userMonitor.locationMgr.location?.coordinate)!)
        }
    }
}
