//
//  MainViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var currentConditionsView: UIView!
    
    // current condition outlets
    
    @IBOutlet weak var cityState: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentCondition: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // dynamic auto layout constraint outlets for lanscape and portrait
    
    @IBOutlet weak var portraitConstraintARCV: NSLayoutConstraint!
    @IBOutlet weak var portraitConstraintAROV: NSLayoutConstraint!
    @IBOutlet weak var portraitConstraintBAOV: NSLayoutConstraint!
    @IBOutlet weak var portraitConstraintTSOV: NSLayoutConstraint!
    @IBOutlet weak var portraitConstraintLSCV: NSLayoutConstraint!
    @IBOutlet weak var portraitConstraintTPCV: NSLayoutConstraint!
    
    @IBOutlet weak var landscapeConstraintWTOV: NSLayoutConstraint!
    @IBOutlet weak var landscapeConstraintBLOV: NSLayoutConstraint!
    @IBOutlet weak var landscapeConstraintLSCV: NSLayoutConstraint!
    @IBOutlet weak var landscapeConstraintTPCV: NSLayoutConstraint!
    
    // array for hourly forcast
    
    var hourlyForecastArray = [Any]()
    
    // int for how many hours in first day of hourly forecast
    
    var hoursLeftOnDayOne = Int()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //TODO: remove
        
        // self.applyLandScapeConstraint()

        // add self as observer to device orientation changes
        
        // NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // set current conditions view to default color
        
        self.currentConditionsView.backgroundColor = UIColor(0xFF9800)
        
        // set image of settings button
        
        // self.settingsButton.imageView?.image = UIImage(named: "settingsCog")
        
        // start activity view
        
        self.activityIndicator.startAnimating()
        
        // setup weather data for current conditions view
        // it would be wise to put this into a func if it should be called more than once after the main view is displayed
        
        getWeatherData(callType: "conditions/hourly")
        {
            weatherData in
            
            self.activityIndicator.stopAnimating()
            
            if let dictionary = weatherData as? [String: Any]
            {
                if let currentConditions = dictionary["current_observation"] as? [String:Any]
                {
                    // get current temperature and display it
                    
                    let currentTempIntF = currentConditions["temp_f"] as? Int
                    
                    // print("Current Temp \(currentTempIntF!)°")
                    
                    self.currentTemp.text = String(format: "%d°", currentTempIntF!)
                    
                    // get current city and display it
                    
                    if let displayLocation = currentConditions["display_location"] as? [String:Any]
                    {                        
                        self.cityState.text = displayLocation["full"] as? String
                    }
                    
                    // get current weather data and display it
                    
                    self.currentCondition.text = currentConditions["weather"] as? String
                    
                    // set background color of currentconditionsview to reflect temp
                    
                    if (currentTempIntF! < 60)
                    {
                        self.currentConditionsView.backgroundColor = UIColor(0x03A9F4)
                    }
                    else
                    {
                        self.currentConditionsView.backgroundColor = UIColor(0xFF9800)
                    }
                }
            }
        }
        
        // get hourly conditions for the next 10 days
        
        getWeatherData(callType: "hourly10day")
        {
            weatherData in
            
            self.activityIndicator.stopAnimating()
            
            if let dictionary = weatherData as? [String: Any]
            {
                
                self.hourlyForecastArray = dictionary["hourly_forecast"] as! [Any]
 
                print("number of items: \(self.hourlyForecastArray.count)")
                
                self.collectionView.reloadData()
            }
        }
        
    }
    
    // MARK: - Navigation
    
    @IBAction func returnFromSettingsSegue(_: UIStoryboardSegue)
    {
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Set the popover presentation style delegate to always force a popover
    }
    
    // TODO: detect device orientation and change layout for lanscape vs portrait
    
    /*
    func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.shared.statusBarOrientation
            
            switch orient {
            case .portrait:
                print("Portrait")
                self.ApplyportraitConstraint()
                break
            // Do something
            default:
                print("LandScape")
                // Do something else
                self.applyLandScapeConstraint()
                break
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            print("rotation completed")
        })
        self.viewWillTransitionToSize(size: size, withTransitionCoordinator: coordinator)
    }*/
    /*
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            
            let orient = UIApplication.shared.statusBarOrientation
            
            switch orient {
            case .portrait:
                print("Portrait")
                self.ApplyportraitConstraint()
                break
            // Do something
            default:
                print("LandScape")
                // Do something else
                self.applyLandScapeConstraint()
                break
            }
        })
 
    }*/
    /*
    func rotated()
    {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            print("Landscape")
            self.applyLandScapeConstraint()
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            print("Portrait")
            self.ApplyportraitConstraint()
        }
        
    }*/

    func ApplyportraitConstraint()
    {
        
        // try setting priorities instead of adding and removing constraints
        if(self.portraitConstraintARCV == nil)
        {
            self.view.addConstraint(self.portraitConstraintARCV)
            self.view.addConstraint(self.portraitConstraintAROV)
            self.view.addConstraint(self.portraitConstraintBAOV)
            self.view.addConstraint(self.portraitConstraintTSOV)
            self.view.addConstraint(self.portraitConstraintLSCV)
            self.view.addConstraint(self.portraitConstraintTPCV)

        }
        /*
        self.portraitConstraintARCV.priority = 1000
        self.portraitConstraintAROV.priority = 1000
        self.portraitConstraintBAOV.priority = 1000
        self.portraitConstraintTSOV.priority = 1000
        self.portraitConstraintLSCV.priority = 1000
        self.portraitConstraintTPCV.priority = 1000
        */
        if (self.landscapeConstraintWTOV != nil)
        {
            self.view.removeConstraint(self.landscapeConstraintWTOV)
            self.view.removeConstraint(self.landscapeConstraintBLOV)
            self.view.removeConstraint(self.landscapeConstraintLSCV)
            self.view.removeConstraint(self.landscapeConstraintTPCV)
        }
        /*
        self.landscapeConstraintWTOV.priority = 999
        self.landscapeConstraintBLOV.priority = 999
        self.landscapeConstraintLSCV.priority = 999
        self.landscapeConstraintTPCV.priority = 999
        */
    }
    
    func applyLandScapeConstraint()
    {
        if(self.portraitConstraintARCV != nil)
        {
            self.view.removeConstraint(self.portraitConstraintARCV)
            self.view.removeConstraint(self.portraitConstraintAROV)
            self.view.removeConstraint(self.portraitConstraintBAOV)
            self.view.removeConstraint(self.portraitConstraintTSOV)
            self.view.removeConstraint(self.portraitConstraintLSCV)
            self.view.removeConstraint(self.portraitConstraintTPCV)
        }
        /*
        self.portraitConstraintARCV.priority = 999
        self.portraitConstraintAROV.priority = 999
        self.portraitConstraintBAOV.priority = 999
        self.portraitConstraintTSOV.priority = 999
        self.portraitConstraintLSCV.priority = 999
        self.portraitConstraintTPCV.priority = 999
         */
        if(self.landscapeConstraintWTOV == nil)
        {
            self.view.addConstraint(self.landscapeConstraintWTOV)
            self.view.addConstraint(self.landscapeConstraintBLOV)
            self.view.addConstraint(self.landscapeConstraintLSCV)
            self.view.addConstraint(self.landscapeConstraintTPCV)
        }
        /*
        self.landscapeConstraintWTOV.priority = 1000
        self.landscapeConstraintBLOV.priority = 1000
        self.landscapeConstraintLSCV.priority = 1000
        self.landscapeConstraintTPCV.priority = 1000
         */
    }

    
}

func getWeatherData(callType: String, completionHandler: @escaping (_ weatherData: Any?) -> ())
{
    let url = HelperMethods.weatherURL(callType: callType,zipCode: "55317")
    
    let session = URLSession.shared
    
    let task = session.dataTask(with: url)
    {
        data, response, error in
        
        let httpResponse = response as! HTTPURLResponse
        let statusCode = httpResponse.statusCode
        
        print("status code \(statusCode)")
            if (statusCode == 200)
            {
                let weatherData: Data = data!
                
                let json = try? JSONSerialization.jsonObject(with: weatherData, options: [])
                
                // dispatch completion handler on main queue for UI update
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(json)

                })
                
            }
            else
            {
                // handle error and display to user
            }
        }
    
        task.resume()
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        // return 10 for number of days in forecast
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        if (self.hourlyForecastArray.count == 0)
        {
            // if array is empty return 0
            
            return 0
        }
        else if (section == 0)
        {
            // use first hour to determine how many hours are left in the day
            
            if let firstHourDict = self.hourlyForecastArray[0] as? [String:Any]
            {
                if let firstHourFCTDict = firstHourDict["FCTTIME"] as? [String:Any]
                {
                    print("hour of the day: \(firstHourFCTDict["hour"]!)")
                    
                    let firstHourInt = firstHourFCTDict["hour"] as! String
                    
                    hoursLeftOnDayOne = Int(firstHourInt)!
                    
                    return (24 - hoursLeftOnDayOne)
                }
            }
            
        }
        else if (section > 0)
        {
            // every other day than the first day returns 24
            
            return 24
        }
        
        // if all else fails, return 0
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCell", for: indexPath as IndexPath)        as! HourlyCollectionViewCell
        
        // get current cell number and access correct values in hourly forecast array
        
        print((indexPath.section)*24 + indexPath.row + self.hoursLeftOnDayOne)
        
        var cellNumber = Int()
        
        if (indexPath.section == 0)
        {
            cellNumber = indexPath.row
        }
        else if (indexPath.section > 0)
        {
            
        }
        
        if let currentHourDict = self.hourlyForecastArray[(indexPath.section)*24 + indexPath.row] as? [String:Any]
        {
            
        }

        
        return cell
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    }
     */
}
