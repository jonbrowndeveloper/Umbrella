//
//  SettingsViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var getWeatherButton: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // set textfield delegate
        
        textField.delegate = self
        textField.layer.cornerRadius = 10.0
        
        // search icon for text field
        
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        imageView.contentMode = UIViewContentMode.right
        imageView.image = #imageLiteral(resourceName: "searchGlass")
        
        textField.leftView = imageView
        
        // set selected index to current value
        
        if ((UserDefaults.standard.value(forKey: "isEnglish") as! Bool))
        {
            self.segmentedControl.selectedSegmentIndex = 0
        }
        else
        {
            self.segmentedControl.selectedSegmentIndex = 1
        }
        
        // detecting tap gesture on main view
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        // self.getWeatherButton.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getWeatherButtonPushed(_ sender: Any)
    {
        // could also use a gesture recognizer, this way I believe is a bit cleaner
        
        self.handleTap()
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil)
    {
        
        // format string so that it is only numbers
        
        let zipCodeString = textField.text
        
        let stringArray =  zipCodeString?.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let finalZipString = stringArray!.joined(separator: "")
        
        // check to see if zip code is correct format
        
        if (finalZipString.characters.count > 5 || finalZipString.characters.count < 5)
        {
            let alert = UIAlertController(title: "Error", message: "Please enter a 5 digit US zip code.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            UserDefaults.standard.setValue(finalZipString, forKey: "zipCode")
            
            self.performSegue(withIdentifier: "returnToMainViewController", sender: self)
        }

    }
    
    // change user defaults for farhenheit vs celsius 
    
    @IBAction func tempTypeSwitch(_ sender: Any)
    {
        if (segmentedControl.selectedSegmentIndex == 0)
        {
            UserDefaults.standard.setValue(true, forKey: "isEnglish")
        }
        else if (segmentedControl.selectedSegmentIndex == 1)
        {            
            UserDefaults.standard.setValue(false, forKey: "isEnglish")
        }
    }
    
    // close keyboard when hitting return
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        
        return false
    }

}
