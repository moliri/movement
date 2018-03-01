//
//  SignUpViewController.swift
//  movement
//
//  Created by Leesha Maliakal on 2/28/18.
//  Copyright © 2018 Delta Lab. All rights reserved.
//

import Foundation
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signup: UIButton!
    
    
    var setupDate: Date = Date()
    var setupTimer: Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        username.delegate = self
        email.delegate = self
        password.delegate = self
        
        
        //set up rules for keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Flow 2 - Check WiFi, alert if not on
        if isWiFiConnected()==false {
            turnOnWiFiAlert()
        }
        
        //Flow 3 - Segue if logged in already
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "intro", sender: nil)
        }
    }
    
    
    //Interaction 1 - Check fields, Log In, and segue to next VC
    @IBAction func login(_ sender: UIButton) {
        PFUser.logInWithUsername(inBackground: username.text!, password:password.text!) {
            (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                // Successful login
                self.performSegue(withIdentifier: "intro", sender: nil)
                
            } else {
                // failed login, error displayed to user
                let errorString = (error! as NSError).userInfo["error"] as? String
                let alertController = UIAlertController(title: "Log In Error", message:
                    errorString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    //Interaction 2 - Check fields, Sign Up, and segue to next VC
    @IBAction func signup(_ sender: UIButton) {
        let user = PFUser()
        user.username = username.text
        user.password = password.text
        user.email = email.text
        
        if ((username.text?.isEmpty)! || (password.text?.isEmpty)! || (email.text?.isEmpty)!) {
            let alertController = UIAlertController(title: "Sign Up Error", message:
                "Please complete all fields to sign up.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        else {
            user.signUpInBackground {
                (succeeded: Bool, error: Error?) -> Void in
                if let error = error {
                    //failed signup, error displayed to user
                    let errorString = (error as NSError).userInfo["error"] as? String
                    let alertController = UIAlertController(title: "Sign Up Error", message:
                        errorString, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                } else {
                    //Successful signup
                    self.performSegue(withIdentifier: "intro", sender: nil)
                }
            }
        }
        
        
    }
    
    //keyboard behavior
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func keyboardWillShow(_ notification:Notification){
//        
//        var userInfo = notification.userInfo!
//        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        keyboardFrame = view.convert(keyboardFrame, from: nil)
    
//        var contentInset:UIEdgeInsets = scrollView.contentInset
//        contentInset.bottom = keyboardFrame.size.height
//        scrollView.contentInset = contentInset
//    }
    
//    func keyboardWillHide(_ notification:Notification){
//        
//        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
//        scrollView.contentInset = contentInset
//    }
    
    //Prompt user to turn on WiFi
    func turnOnWiFiAlert() {
        let alertTitle = "Location Accuracy"
        let alertController = UIAlertController(title: alertTitle, message: "Turn on Wi-Fi to improve location accuracy", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: openSettings))
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openSettings(_ alert: UIAlertAction!) {
        UIApplication.shared.openURL(URL(string:"App-Prefs:root=WIFI")!)
    }
    
    func isWiFiConnected() -> Bool {
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
                return true
            } else {
                print("Reachable via Cellular")
                return false
            }
        } else {
            print("Network not reachable")
            return false
        }
    }
    
    func sendLocalNotification_setup() {
        let localNotification = UILocalNotification()
        localNotification.alertBody = "The race will start soon. Don't forget to make sure your app is set up to track the race!"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.timeZone = TimeZone.current
        localNotification.fireDate = setupDate
        localNotification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
}
