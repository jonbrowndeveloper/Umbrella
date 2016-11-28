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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // var weatherData = Data()

        getWeatherData2
        {
            weatherData in
            print(weatherData)
        }
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

func getWeatherData(url: URL, completionHandler handler: @escaping (_ data: Data) -> ())
{
    // highest priority asynch queue using weather url to get weather data
    DispatchQueue.global(qos: .userInteractive).async
        { () -> Void in
            if let weatherData = try? Data(contentsOf: url)
            {
                handler(weatherData)
            }
    }
}

func getWeatherData2(completionHandler: @escaping (_ weatherData: Any?) -> ())
{
    let url = HelperMethods.weatherURL(zipCode: "90210")
    
    let session = URLSession.shared
    
    let task = session.dataTask(with: url)
    {
        data, response, error in
        
        let httpResponse = response as! HTTPURLResponse
        let statusCode = httpResponse.statusCode
        
        print("status code \(statusCode)")
        
            if (statusCode == 200)
            {
                let json = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    
                completionHandler(json)
                    
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
