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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // set current conditions view to default color
        
        self.currentConditionsView.backgroundColor = UIColor(0xFF9800)
        
        // set image of settings button
        
        // self.settingsButton.imageView?.image = UIImage(named: "settingsCog")
        
        // start activity view
        
        self.activityIndicator.startAnimating()
        
        // setup weather data for current conditions view
        
        getWeatherData
        {
            weatherData in
            
            self.activityIndicator.stopAnimating()
            
            if let dictionary = weatherData as? [String: Any]
            {
                print(dictionary)
                
                if let currentConditions = dictionary["current_observation"] as? [String:Any]
                {
                    // get current temperature and display it
                    
                    let currentTempIntF = currentConditions["temp_f"] as? Int
                    
                    print("Current Temp \(currentTempIntF!)°")
                    
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
        
        // set color based off of temperature
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func returnFromSettingsSegue(_: UIStoryboardSegue) {
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Set the popover presentation style delegate to always force a popover
    }
}

func getWeatherData(completionHandler: @escaping (_ weatherData: Any?) -> ())
{
    let url = HelperMethods.weatherURL(zipCode: "55317")
    
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
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // fatalError()
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // fatalError()
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // fatalError()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        // TODO: Add alias for custom UICollectionViewCell
        //   as! UICollectionViewCell
        
        return cell
    }
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        fatalError()
    }
     */
}
