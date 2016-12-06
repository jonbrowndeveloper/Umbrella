 //
//  MainViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var currentConditionsView: UIView!
    
    // current condition outlets
    
    @IBOutlet weak var cityState: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentCondition: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
    // array for hourly forcast
    
    var hourlyForecastArray = [Any]()
    
    // int for how many hours in first day of hourly forecast
    
    var hoursLeftOnDayOne = Int()
    
    // simple completion counter to know when all code completes
    
    var simpleCompletionCounter = 0
    
    // icon dict filled with icons needed for hourly forecast
    
    var iconImageDict = [String:UIImage]()
    
    // create var for unique icon names
    
    var uniqueIcons = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {

    }
    
    func initializeView()
    {
        // set current conditions view to default color
        
        self.currentConditionsView.backgroundColor = UIColor(0xFF9800)
        
        // start activity view
        
        self.activityIndicator.startAnimating()
        
        // setup weather data for current conditions view
        // it would be wise to put this into a func if it should be called more than once after the main view is displayed
        
        getWeatherData(callType: "conditions")
        {
            weatherData in
            
            if let dictionary = weatherData as? [String: Any]
            {
                if let dictionary = weatherData as? [String: Any]
                {
                    // check if there was an error with the zip code
                    
                    if let response = dictionary["response"] as? [String:Any]
                    {
                        if let error = response["error"] as? [String:Any]
                        {
                            if let description = error["description"] as? String
                            {
                                self.displayError(title: "Error", message: description, toSettings: true)
                            }
                        }
                    }
                }
                
                
                if let currentConditions = dictionary["current_observation"] as? [String:Any]
                {
                    // get current temperature and display it
                    
                    if (UserDefaults.standard.value(forKey: "isEnglish") as! Bool)
                    {
                        let currentTempInt = currentConditions["temp_f"] as? Int
                        
                        self.currentTemp.text = String(format: "%d°", currentTempInt!)
                        
                        // set background color of currentconditionsview to reflect temp
                        
                        if (currentTempInt! < 60)
                        {
                            self.currentConditionsView.backgroundColor = UIColor(0x03A9F4)
                        }
                        else
                        {
                            self.currentConditionsView.backgroundColor = UIColor(0xFF9800)
                        }
                    }
                    else
                    {
                        let currentTempInt = currentConditions["temp_c"] as? Int
                        
                        self.currentTemp.text = String(format: "%d°", currentTempInt!)
                        
                        // set background color of currentconditionsview to reflect temp
                        
                        if (currentTempInt! < 16)
                        {
                            self.currentConditionsView.backgroundColor = UIColor(0x03A9F4)
                        }
                        else
                        {
                            self.currentConditionsView.backgroundColor = UIColor(0xFF9800)
                        }
                    }
                    
                    // get current city and display it
                    
                    if let displayLocation = currentConditions["display_location"] as? [String:Any]
                    {
                        self.cityState.text = displayLocation["full"] as? String
                    }
                    
                    // get current weather data and display it
                    
                    self.currentCondition.text = currentConditions["weather"] as? String
                }
                
                // update UI if all completion blocks have finished
                
                self.simpleCompletionCounter = self.simpleCompletionCounter + 1
                
                self.reloadDataUponDownloadCompletion()
            }
        }
        
        // get hourly conditions for the next 10 days
        
        getWeatherData(callType: "hourly10day")
        {
            weatherData in
            
            // check if there was an error with the zip code
            
            if let dictionary = weatherData as? [String: Any]
            {
                if let response = dictionary["response"] as? [String:Any]
                {
                    if let error = response["error"] as? [String:Any]
                    {
                        if let description = error["description"] as? String
                        {
                            self.displayError(title: "Error", message: description, toSettings: true)
                        }
                    }
                }
                
                if let hourlyForecastArraySafe = dictionary["hourly_forecast"] as? [Any]
                {
                    self.hourlyForecastArray = hourlyForecastArraySafe
                }
                
                // update UI if all completion blocks have finished
                
                self.simpleCompletionCounter = self.simpleCompletionCounter + 1
                
                self.reloadDataUponDownloadCompletion()
                
                // get unique hourly icons
                
                var fullHourlyArray = [String]()
                
                for hour in 0 ..< self.hourlyForecastArray.count
                {
                    if let dictionary = self.hourlyForecastArray[hour] as? [String:Any]
                    {
                        let icon = dictionary["icon"] as? String
                        
                        fullHourlyArray.append(icon!)
                    }
                }
                
                // get unique icon values
                
                self.uniqueIcons = Array(Set(fullHourlyArray))
                
                // get icons 
                
                self.getIcons()
            }
        }
        
    }
    
    func getIcons()
    {
        // get weather icons
        // for the sake of the project, it looks like the specifications are calling for the download of these icons every time the application runs. If these Icons never change, I would prefer to simply save these icons in the assets for the application rather than have all of these network calls.
        
        // get both solid and outlined weather icons for collection view
        
        for icon in 0 ..< self.uniqueIcons.count
        {
            getIconData(iconURL: self.uniqueIcons[icon].nrd_weatherIconURL(highlighted: true)!)
            {
                iconData in
                
                // full icon string
                
                let iconString = String(format: "%@-highlighted", self.uniqueIcons[icon])
                
                // add icon to icon dict
                
                self.iconImageDict[iconString] = UIImage(data: iconData as! Data)
                
                // update UI if all completion blocks have finished
                
                self.simpleCompletionCounter = self.simpleCompletionCounter + 1
                
                self.reloadDataUponDownloadCompletion()
                
            }
            
            getIconData(iconURL: self.uniqueIcons[icon].nrd_weatherIconURL()!)
            {
                iconData in
                
                self.iconImageDict[self.uniqueIcons[icon]] = UIImage(data: iconData as! Data)
                
                // update UI if all completion blocks have finished
                
                self.simpleCompletionCounter = self.simpleCompletionCounter + 1
                
                self.reloadDataUponDownloadCompletion()
            }
            
        }

    }
    
    func reloadDataUponDownloadCompletion()
    {
        if(uniqueIcons.count > 0)
        {
            if(self.simpleCompletionCounter == (2 + (self.uniqueIcons.count * 2)))
            {
                self.collectionView.reloadData()
                
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func clearViews()
    {
        self.currentTemp.text = ""
        self.cityState.text = ""
        self.currentCondition.text = ""
        
        self.hourlyForecastArray.removeAll()
        
        collectionView.reloadData()
    }
    
    // MARK: - Error Handling
    
    func displayError(title: String,message: String, toSettings: Bool)
    {
        // alert controller with completion action
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            if (toSettings == true)
            {
                self.performSegue(withIdentifier: "toSettingsView", sender: self)
            }
            else
            {
                // action called when modal view controller is dismissed
                
                self.simpleCompletionCounter = 0
                
                self.clearViews()
                
                self.initializeView()
            }
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
    
    // MARK: - Network Calls

    func getWeatherData(callType: String, completionHandler: @escaping (_ weatherData: Any?) -> ())
    {
        let url = HelperMethods.weatherURL(callType: callType,zipCode: (UserDefaults.standard.value(forKey: "zipCode") as! String))
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url)
        {
            data, response, error in
            
            var statusCode = 0
            
            if let httpResponse = response as? HTTPURLResponse
            {
                statusCode = httpResponse.statusCode
            }
            
                if (statusCode == 200)
                {
                    let weatherData: Data = data!
                    
                    let json = try? JSONSerialization.jsonObject(with: weatherData, options: [])
                    
                    // dispatch completion handler on main queue for UI update
                    DispatchQueue.main.async(execute: { () -> Void in
                        completionHandler(json)

                    })
                    
                }
                else if (statusCode != 0)
                {
                    // error with http status code
                    
                    self.displayError(title: "Error", message: String(format: "Unable to establish network connetion. Error: %@\nMake sure you are connected to the internet.",statusCode), toSettings: false)
                    
                    
                }
                else
                {
                    // error with swift httpurl error message
                    
                    self.displayError(title: "Error", message: String(format: "Unable to establish network connetion. Error: %@\nMake sure you are connected to the internet.",(error?.localizedDescription)!), toSettings: false)
                }
            
            }
        
            task.resume()
    }
    
    func getIconData(iconURL: URL, completionHandler: @escaping (_ iconData: Any?) -> ())
    {
        let session = URLSession.shared
        
        let task = session.dataTask(with: iconURL)
        {
            data, response, error in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200)
            {
                // dispatch completion handler on main queue for UI update
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(data)
                    
                })
                
            }
            else if (statusCode != 0)
            {
                // error with http status code
                
                self.displayError(title: "Error", message: String(format: "Unable to establish network connetion. Error: %@\nMake sure you are connected to the internet.",statusCode), toSettings: false)
                
                
            }
            else
            {
                // error with swift httpurl error message
                
                self.displayError(title: "Error", message: String(format: "Unable to establish network connetion. Error: %@\nMake sure you are connected to the internet.",(error?.localizedDescription)!), toSettings: false)
            }
        }
        
        task.resume()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Set the popover presentation style delegate to always force a popover
    }

    @IBAction func returnedToMainViewController(segue:UIStoryboardSegue)
    {
        // action called when modal view controller is dismissed
        
        self.simpleCompletionCounter = 0
        
        self.clearViews()
        
        self.initializeView()

    }
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
                    let firstHourInt = firstHourFCTDict["hour"] as! String
                    
                    hoursLeftOnDayOne = 24 - Int(firstHourInt)!
                    
                    return (hoursLeftOnDayOne)
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
        
        var cellNumber = Int()
        
        if (indexPath.section == 0)
        {
            cellNumber = indexPath.row
        }
        else if (indexPath.section == 1)
        {
           cellNumber = indexPath.row + self.hoursLeftOnDayOne
        }
        else if (indexPath.section > 1)
        {
            cellNumber = indexPath.row + self.hoursLeftOnDayOne + ((indexPath.section - 1) * 24)
        }
        
        // cell icon
        
        var cellIconImageType = String()
        
        // set labels of cell
        
        if let currentHourDict = self.hourlyForecastArray[cellNumber] as? [String:Any]
        {
            // set hour label
            
            if let currentHourDictFCT = currentHourDict["FCTTIME"] as? [String:Any]
            {
                cell.timeLabel.text = currentHourDictFCT["civil"] as? String
                
            }
            
            // set temp label

            if let tempDict = currentHourDict["temp"] as? [String:Any]
            {
                if ((UserDefaults.standard.value(forKey: "isEnglish") as! Bool))
                {
                    cell.tempLabel.text = String(format: "%@°", (tempDict["english"] as? String)!)
                }
                else
                {
                    cell.tempLabel.text = String(format: "%@°", (tempDict["metric"] as? String)!)
                }
                
                
            }
            
            cellIconImageType = (currentHourDict["icon"] as? String)!
        }
        
        // for getting high and low of the day
        
        let firstHourOfCurrentDay = (cellNumber - indexPath.row)
        
        let lastHourOfCurrentDay = firstHourOfCurrentDay + hoursLeftOnDayOne
        
        // array for storing and comparing temps of the current day
        
        var tempsArray = [Int]()
        
        for dayNumber in firstHourOfCurrentDay...(lastHourOfCurrentDay - 1)
        {
            if let currentHourDict = self.hourlyForecastArray[dayNumber] as? [String:Any]
            {
                // set hour label
                
                if let currentTempDict = currentHourDict["temp"] as? [String:Any]
                {
                    let temp = currentTempDict["english"] as? String
                    
                    tempsArray.append(Int(temp!)!)
                }
            }
        }
        
        // first occurance of high and low
        
        let highTemp = tempsArray.max()!
        let lowTemp = tempsArray.min()!
        
        var firstHigh = Int()
        var firstLow = Int()
        
        // for high temp
        
        for i in 0 ..< tempsArray.count
        {
            if(tempsArray[i] == highTemp)
            {
                firstHigh = i + firstHourOfCurrentDay
                
                break
            }
        }
        
        // for low temp
        
        for i in 0 ..< tempsArray.count
        {
            if(tempsArray[i] == lowTemp)
            {
                firstLow = i + firstHourOfCurrentDay
                
                break
            }
        }
        
        let outlineIcon = self.iconImageDict[cellIconImageType]
        let solidIcon = self.iconImageDict[String(format: "%@-highlighted", cellIconImageType)]
        
        // set icon for cell imageview
        
        if (firstLow == firstHigh)
        {
            cell.imageView.image = outlineIcon?.withRenderingMode(.alwaysTemplate)
            cell.imageView.tintColor = UIColor.black
        }
        else if (cellNumber == firstHigh)
        {
            cell.imageView.image = solidIcon?.withRenderingMode(.alwaysTemplate)
            cell.imageView.tintColor = UIColor(0xFF9800)
        }
        else if (cellNumber == firstLow)
        {
            cell.imageView.image = solidIcon?.withRenderingMode(.alwaysTemplate)
            cell.imageView.tintColor = UIColor(0x03A9F4)
        }
        else
        {
            cell.imageView.image = outlineIcon?.withRenderingMode(.alwaysTemplate)
            cell.imageView.tintColor = UIColor.black
        }
        
        return cell
    }
        
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        // switch if there later are other types of reusable views
        switch kind
        {
        
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "HeaderView",
                                                                             for: indexPath) as! HeaderCollectionReusableView
            // check if there is data to load in collection view, if not, set day label to Loading...
            if (self.hourlyForecastArray.count == 0)
            {
                headerView.dayLabel.text = "Loading..."
            }
            else
            {
                if (indexPath.section == 0)
                {
                    headerView.dayLabel.text = "Today"

                }
                else if (indexPath.section == 1)
                {
                    headerView.dayLabel.text = "Tomorrow"
                }
                else
                {
                    headerView.dayLabel.text = "Today"
                    
                    // going into hourly forcast to grab
                    
                    if let currentHourDict = self.hourlyForecastArray[(self.hoursLeftOnDayOne + ((indexPath.section - 1) * 24))] as? [String:Any]
                    {
                        if let currentHourDictFCT = currentHourDict["FCTTIME"] as? [String:Any]
                        {
                            headerView.dayLabel.text = currentHourDictFCT["weekday_name"] as? String
                        }

                    }
                }
                
            }
            return headerView
        default:
            
            assert(false, "unknown element")
        }
    }
    
}
