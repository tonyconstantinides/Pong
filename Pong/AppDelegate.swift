//
//  AppDelegate.swift
//  Pong
//
//  Created by Tony Constantinides on 7/11/14.
//  Copyright (c) 2014 Tony Constantinides. All rights reserved.
//

import UIKit
import SpriteKit

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let log = XCGLogger.defaultInstance()
    
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        log.setup(logLevel: .Debug, showLogLevel: true, showFileNames: true, showLineNumbers: true)
        log.debug("----------------------------------------")
        log.debug("application: - Initial entry point")
        log.debug("----------------------------------------")
        return true
    }
    
    func applicationWillResignActive(application: UIApplication!) {
        log.debug("applicationWillResignActive: - moving to inactive state")
    }
    
    func applicationDidEnterBackground(application: UIApplication!) {
        log.debug("applicationDidEnterBackground: - calling when the user quits")
    }
    
    func applicationWillEnterForeground(application: UIApplication!) {
        log.debug("applicationWillEnterForeground(: ")
    }
    
    func applicationDidBecomeActive(application: UIApplication!) {
        log.debug("applicationDidBecomeActive(application: ")
    }
    
    func applicationWillTerminate(application: UIApplication!) {
        log.debug("applicationWillTerminate:")
    }
    
}