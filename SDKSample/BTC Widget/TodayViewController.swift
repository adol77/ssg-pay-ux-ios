//
//  TodayViewController.swift
//  BTC Widget
//
//  Created by Sucheol Ha on 11/10/15.
//  Copyright © 2015 Regina. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var basicBool : Bool = true;

    
    override func viewDidLoad() {
        super.preferredContentSize = CGSizeMake(0, 300);
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        //if (basicBool == true){
        //    NCWidgetController.widgetController().setHasContent(false, forWidgetWithBundleIdentifier: "com.ssg.platform.lbs.SSG-LBS-Platform.BTC-Widget")
        //    basicBool = false
        //}
        //[[NCWidgetController widgetController] setHasContent:YES
        //    forWidgetWithBundleIdentifier:$(PRODUCT_BUNDLE_IDENTIFIER)];
        
        //[[NCWidgetController widgetController] setHasContent:NO       forWidgetWithBundleIdentifier:@"com.example.MyWidgetBundleIdentifier"];
    }
    
    func setHasContent(isShow :Bool) {
        //NCWidgetController.widgetController().setHasContent(isShow, forWidgetWithBundleIdentifier: "com.ssg.platform.lbs.SSG-LBS-Platform.BTC-Widget")
        
        //[[NCWidgetController widgetController] setHasContent:YES
        //    forWidgetWithBundleIdentifier:$(PRODUCT_BUNDLE_IDENTIFIER)];
        
        //[[NCWidgetController widgetController] setHasContent:NO       forWidgetWithBundleIdentifier:@"com.example.MyWidgetBundleIdentifier"];
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
