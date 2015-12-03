//
//  TodayViewController.swift
//  SSG PAY2
//
//  Created by Sucheol Ha on 11/12/15.
//  Copyright © 2015 Regina. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var BarCode: UILabel!
    var basicBool = true;
    
    override func viewDidLoad() {
        self.preferredContentSize = CGSizeMake(0, 340);
        super.viewDidLoad()

        if (basicBool == true){
            NCWidgetController.widgetController().setHasContent(false, forWidgetWithBundleIdentifier: "com.ssg.platform.lbs.SSG-LBS-Platform.SSG-PAY3")

            basicBool = false
        } else {
            NCWidgetController.widgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.ssg.platform.lbs.SSG-LBS-Platform.SSG-PAY3")
        }
        
        /*
        buttonView.hidden = true
        NCWidgetController.widgetController().setHasContent(false, forWidgetWithBundleIdentifier: "com.ssg.platform.lbs.SSG-LBS-Platform.SSG-PAY3")
        */
        //[[NCWidgetController widgetController] setHasContent:YES
        //    forWidgetWithBundleIdentifier:$(PRODUCT_BUNDLE_IDENTIFIER)];
        //buttonView.hidden = true;
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
    
    var accumulator: Double = 0.0 // Store the calculated value here
    @IBOutlet weak var btnHolder: UIView!
    var userInput = "" // User-entered digits

    var numStack: [Double] = [] // Number stack
    @IBOutlet weak var numField: UITextField!
    var opStack: [String] = [] // Operator stack
    
    // Looks for a single character in a string.
    /*
    func hasIndex(stringToSearch str: String, characterToFind chr: Character) -> Bool {
    for c in str {
    if c == chr {
    return true
    }
    }
    return false
    }
    */
    
    func handleInput(str: String) {
        numField.text = str;
        /*
        if str == "-" {
            if userInput.hasPrefix(str) {
        @IBOutlet weak var btn9: UIButton!
        @IBOutlet weak var btn8: UIButton!
                // Strip off the first character (a dash)
                userInput = userInput.substringFromIndex(userInput.startIndex.successor())
            } else {
                userInput = str + userInput
            }
        } else {
            userInput += str
        }
        accumulator = Double((userInput as NSString).doubleValue)
        updateDisplay()
*/
    }
    
    func updateDisplay() {
        // If the value is an integer, don't show a decimal point
        var iAcc = Int(accumulator)
        if accumulator - Double(iAcc) == 0 {
            numField.text = "\(iAcc)"
        } else {
            numField.text = "\(accumulator)"
        }
    }
    
    /*
    func doMath(newOp: String) {
    if userInput != "" && !numStack.isEmpty {
    var stackOp = opStack.last
    if !((stackOp == "+" || stackOp == "-") && (newOp == "*" || newOp == "/")) {
    var oper = ops[opStack.removeLast()]
    accumulator = oper!(numStack.removeLast(), accumulator)
    doEquals()
    }
    }
    opStack.append(newOp)
    numStack.append(accumulator)
    userInput = ""
    updateDisplay()
    }
    
    func doEquals() {
    if userInput == "" {
    return
    }
    if !numStack.isEmpty {
    var oper = ops[opStack.removeLast()]
    accumulator = oper!(numStack.removeLast(), accumulator)
    if !opStack.isEmpty {
    doEquals()
    }
    }
    updateDisplay()
    userInput = ""
    }
    */
    
    // UI Set-up
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
    
    @IBAction func btn0Press(sender: UIButton) {
        handleInput("0")
    }
    @IBAction func btn1Press(sender: UIButton) {
        handleInput("1")
    }
    @IBAction func btn2Press(sender: UIButton) {
        handleInput("2")
    }
    @IBAction func btn3Press(sender: UIButton) {
        handleInput("3")
    }
    @IBAction func btn4Press(sender: UIButton) {
        handleInput("4")
    }
    @IBAction func btn5Press(sender: UIButton) {
        handleInput("5")
    }
    @IBAction func btn6Press(sender: UIButton) {
        handleInput("6")
    }
    @IBAction func btn7Press(sender: UIButton) {
        handleInput("7")
    }
    @IBAction func btn8Press(sender: UIButton) {
        handleInput("8")
    }
    @IBAction func btn9Press(sender: UIButton) {
        handleInput("9")
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
    
    @IBAction func btnACPress(sender: UIButton) {
        userInput = ""
        accumulator = 0
        updateDisplay()
        numStack.removeAll()
        opStack.removeAll()
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
    
    @IBAction func btnEqualsPress(sender: UIButton) {
    doEquals()
    }
    */
    
}
