//
//  ViewController.swift
//  WeatherApp
//
//  Created by Hannah Brake on 2020-08-26.
//

import UIKit
import CoreLocation
// custom cell: collection view
// API / request to get data

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    @IBOutlet var table: UITableView!
    
    var models = [DailyWeather]()
    
    let locationManager = CLLocationManager()
    
    let locationManagerForDisplay = LocationManager()
    
    var locationForDisplay = ""
    
    var currentLocation: CLLocation?
    
    var current: CurrentWeather?
    
    var hourlyModels = [HourlyWeather]()
    
    var currentCity: String = "Current Location"
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Register 2 cells
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
      
    }
      
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    //Location
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            
            guard let exposedLocation = self.locationManagerForDisplay.exposedLocation else {
                        print("*** Error in \(#function): exposedLocation is nil")
                        return
                    }
                    
                    self.locationManagerForDisplay.getPlace(for: exposedLocation) { placemark in
                        guard let placemark = placemark else { return }
                        
                        if let town = placemark.locality {
                            self.locationForDisplay = self.locationForDisplay + "\(town)"
                        }

                        if let province = placemark.administrativeArea {
                            self.locationForDisplay = self.locationForDisplay + " \(province)"
                        }

                        print(self.locationForDisplay)
                    }
            requestWeatherForLocation()
            
        }
    }
    


    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&units=metric&exclude=minutely&appid=XXXXX"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            // Validation
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            // Convert data to models/some object
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch{
                print("error: \(error)")
            }
            
            guard let result = json else {
                return
            }
            
            let entries  = result.daily
            
            self.models.append(contentsOf: entries)
            
            let current = result.current
            self.current = current
            
            self.hourlyModels = result.hourly
            // Update UI
            DispatchQueue.main.async {
                self.table.reloadData()
                
                self.table.tableHeaderView = self.createTableHeader()
            }
        }).resume()
         
        

    }
    
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        headerView.backgroundColor = .clear
        
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width - 20, height: headerView.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20 + locationLabel.frame.size.height, width: view.frame.size.width - 20, height: headerView.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20 + locationLabel.frame.size.height + summaryLabel.frame.size.height, width: view.frame.size.width - 20, height: headerView.frame.size.height/2))
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(summaryLabel)
        
        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        
        tempLabel.text = String(Int((self.current?.temp)!)) + "°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 96)
        //tempLabel.font = UIFont.systemFont(ofSize: 96, weight: UIFont.Weight.bold)
        locationLabel.font = UIFont.systemFont(ofSize: 32)
        locationLabel.text = self.locationForDisplay
        summaryLabel.font = UIFont.systemFont(ofSize: 18)
        summaryLabel.text = self.current?.weather[0].description
        
        return headerView
    }
    // Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return models.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row + 1])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

    


struct WeatherResponse: Codable {
    let lat: Float
    let lon: Float
    let timezone: String
    let timezone_offset: Int
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}

struct CurrentWeather: Codable {
    let dt: Int?
    let sunrise: Int?
    let sunset: Int?
    let temp: Float?
    let feels_like: Float?
    let pressure: Int?
    let humidity: Int?
    let dew_point: Float?
    let uvi: Float?
    let clouds: Int?
    let visibility: Int?
    let wind_speed: Float?
    let wind_gust: Float?
    let wind_deg: Int?
    let weather: [WeatherSpecs]
    let rain: TimeSpec?
    let snow: TimeSpec?
}



struct TimeSpec: Codable {
    let lh: Float?
}

struct HourlyWeather: Codable {
    let dt: Int?
    let temp: Float?
    let feels_like: Float?
    let pressure: Int?
    let humidity: Int?
    let dew_point: Float?
    let clouds: Int?
    let visibility: Int?
    let wind_speed: Float?
    let wind_gust: Float?
    let wind_deg: Int?
    let weather: [WeatherSpecs]
    let pop: Float?
    let rain: TimeSpec?
    let snow: TimeSpec?
    
}

struct DailyWeather: Codable {
    let dt: Int?
    let sunrise: Int?
    let sunset: Int?
    let temp: TempSpecs?
    let feels_like: FeelsLikeSpecs?
    let pressure: Int?
    let humidity: Int?
    let dew_point: Float?
    let clouds: Int?
    let visibility: Int?
    let wind_speed: Float?
    let wind_gust: Float?
    let wind_deg: Int?
    let weather: [WeatherSpecs]
    let pop: Float?
    let rain: Float?
    let snow: Float?
    let uvi: Float?
}

struct TempSpecs: Codable {
    let day: Float?
    let min: Float?
    let max: Float?
    let night: Float?
    let eve: Float?
    let morn: Float?
}
struct FeelsLikeSpecs: Codable {
    let day: Float?
    let night: Float?
    let eve: Float?
    let morn: Float?
}

struct WeatherSpecs: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
