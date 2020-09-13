//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Hannah Brake on 2020-08-27.
//

import UIKit
import Foundation

class WeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "WeatherCollectionViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil )
    }
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    
    func configure(with model: HourlyWeather) {
        
        let date = NSDate(timeIntervalSince1970: Double(model.dt!))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.short//Set date style
        dateFormatter.timeZone = NSTimeZone() as TimeZone
        let localDate = dateFormatter.string(from: date as Date)
        let fullArr = localDate.components(separatedBy: " ")
        let timeDisplay = fullArr[1] + " " + fullArr[2]
        self.tempLabel.font = tempLabel.font.withSize(12)
        self.tempLabel.text = timeDisplay + ": " + String(Int(model.temp!)) + "°"
        print(localDate)
        self.iconImageView.contentMode = .scaleAspectFit
        
        let icon = model.weather[0].icon.lowercased()
        

        
        
        if icon.contains("01d") {
            self.iconImageView.image = UIImage(named: "Sun")
        }
        
        else if icon.contains("01n") {
            self.iconImageView.image = UIImage(named: "Moon")
            
        }
        
        else if icon.contains("02d") {
            self.iconImageView.image = UIImage(named: "PartlyDay")
            
        }
        
        else if icon.contains("02n") {
            self.iconImageView.image = UIImage(named: "PartlyNight")
            
        }
        
        else if icon.contains("03d") || icon.contains("04d") || icon.contains("03n") || icon.contains("04n"){
            self.iconImageView.image = UIImage(named: "Cloudy")
            
        }
        
        else if icon.contains("09d") || icon.contains("09n") {
            self.iconImageView.image = UIImage(named: "Rain")
            
        }
        
        else if icon.contains("10d") {
            self.iconImageView.image = UIImage(named: "SunShowers")
            
        }
        
        else if icon.contains("10n") {
            self.iconImageView.image = UIImage(named: "NightShowers")
            
        }
        
        else if icon.contains("11d") || icon.contains("11n") {
            self.iconImageView.image = UIImage(named: "ThunderStorm")
            
        }
        
        else if icon.contains("13d") || icon.contains("13n"){
            self.iconImageView.image = UIImage(named: "Snow")
            
        }
        
        else if icon.contains("50d") || icon.contains("50n"){
            self.iconImageView.image = UIImage(named: "Mist")
            
        }
        

        

        
    
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

}
