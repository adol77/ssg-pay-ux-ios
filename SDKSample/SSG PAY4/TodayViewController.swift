//
//  TodayViewController.swift
//  SSG PAY4
//
//  Created by Sucheol Ha on 11/13/15.
//  Copyright © 2015 Regina. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    @IBOutlet weak var BarCode: UILabel!
    
    
    
    static var basicBool = true;
    static var authorized = false;
    static var cursor = 0;
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(0, 340);
        // Do any additional setup after loading the view from its nib.

        if (TodayViewController.basicBool == true){
            NCWidgetController.widgetController().setHasContent(false, forWidgetWithBundleIdentifier: "com.ssg.platform.lbs.SSG-LBS-Platform.SSG-PAY4")
        
            TodayViewController.basicBool = false
        } else {
            NCWidgetController.widgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.ssg.platform.lbs.SSG-LBS-Platform.SSG-PAY4")
        }

        if (TodayViewController.authorized){
            BarCode.hidden = false;
            btnHolder.hidden = true;
            numField.hidden = true;
            numField2.hidden = true;
            numField3.hidden = true;
            numField4.hidden = true;
            numField5.hidden = true;
            numField6.hidden = true;
            
            self.preferredContentSize = CGSizeMake(0, 120);
        } else {
            BarCode.hidden = true;
        }

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
    
    // UI Set-up
    @IBOutlet var btnHolder: UIView!
    
    
    @IBOutlet weak var numField: UITextField!
    @IBOutlet weak var numField2: UITextField!
    @IBOutlet weak var numField3: UITextField!
    @IBOutlet weak var numField4: UITextField!
    @IBOutlet weak var numField5: UITextField!
    @IBOutlet weak var numField6: UITextField!
    
    
    
    @IBOutlet var btnClear: UIButton!
    @IBOutlet var bntEquals: UIButton!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnSubtract: UIButton!
    @IBOutlet var btnMultiply: UIButton!
    @IBOutlet var btnDivide: UIButton!
    @IBOutlet var btnDecimal: UIButton!
    
    @IBOutlet var btn0: UIButton!
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn4: UIButton!
    @IBOutlet var btn5: UIButton!
    @IBOutlet var btn6: UIButton!
    @IBOutlet var btn7: UIButton!
    @IBOutlet var btn8: UIButton!
    @IBOutlet var btn9: UIButton!
    
    @IBOutlet var buttonView: UIView!
    
    func hideContainerView(){
        self.buttonView.hidden = true
    }
    
    func showContainerView(){
        self.buttonView.hidden = false
    }
    
    func handleInput(str: String) {
        switch(TodayViewController.cursor){
        case 0 : numField.text = str; break;
        case 1 : numField2.text = str; break;
        case 2 : numField3.text = str; break;
        case 3 : numField4.text = str; break;
        case 4 : numField5.text = str; break;
        case 5 : numField6.text = str; break;
        default:
            TodayViewController.cursor++;
        }
        TodayViewController.cursor++;
        
    }
    
    /*
    @IBAction func btnDecPress(sender: UIButton) {
    if hasIndex(stringToSearch: userInput, characterToFind: ".") == false {
    handleInput(".")
    }
    }
    
    @IBAction func btnCHSPress(sender: UIButton) {
    if userInput.isEmpty {
    userInput = numField.text
    }
    handleInput("-")
    }
    */
    @IBAction func btn0Press(sender: UIButton) {
        handleInput("0 ")
    }
    @IBAction func btn1Press(sender: UIButton) {
        handleInput("1 ")
    }
    @IBAction func btn2Press(sender: UIButton) {
        handleInput("2 ")
    }
    @IBAction func btn3Press(sender: UIButton) {
        handleInput("3 ")
    }
    @IBAction func btn4Press(sender: UIButton) {
        handleInput("4 ")
    }
    @IBAction func btn5Press(sender: UIButton) {
        handleInput("5 ")
    }
    @IBAction func btn6Press(sender: UIButton) {
        handleInput("6 ")
    }
    @IBAction func btn7Press(sender: UIButton) {
        handleInput("7 ")
    }
    @IBAction func btn8Press(sender: UIButton) {
        handleInput("8 ")
    }
    @IBAction func btn9Press(sender: UIButton) {
        handleInput("9 ")
    }
    
    /*
    @IBAction func btnPlusPress(sender: UIButton) {
    doMath("+")
    }
    
    @IBAction func btnMinusPress(sender: UIButton) {
    doMath("-")
    }
    
    @IBAction func btnMultiplyPress(sender: UIButton) {
    doMath("*")
    }
    
    @IBAction func btnDividePress(sender: UIButton) {
    doMath("/")
    }
*/
    
    @IBAction func btnEqualsPress(sender: UIButton) {
        TodayViewController.authorized = true;
        self.viewDidLoad();
    }
    
}
