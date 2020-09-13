//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Hannah Brake on 2020-08-26.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell",
                     bundle: nil)
    
}
    
    func configure(with model: DailyWeather){
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.textAlignment = .center
        
        self.lowTempLabel.text = "\(Int((model.temp?.min!)!))°"
        self.highTempLabel.text = "\(Int((model.temp?.max!)!))°"
        self.dayLabel.text = getDayForDate(date: Date(timeIntervalSince1970: Double(model.dt!)))
        self.iconImageView.contentMode = .scaleAspectFit
        
        let icon = model.weather[0].icon.lowercased()
        
        if icon.contains("01d") {
            self.iconImageView.image = UIImage(named: "Sun")
        }
        
        else if icon.contains("02d") {
            self.iconImageView.image = UIImage(named: "PartlyDay")
            
        }
        
        else if icon.contains("03d") || icon.contains("04d") {
            self.iconImageView.image = UIImage(named: "Cloudy")
            
        }
        
        else if icon.contains("09d") {
            self.iconImageView.image = UIImage(named: "Rain")
            
        }
        
        else if icon.contains("10d") {
            self.iconImageView.image = UIImage(named: "SunShowers")
            
        }
        
        else if icon.contains("11d") {
            self.iconImageView.image = UIImage(named: "ThunderStorm")
            
        }
        
        else if icon.contains("13d") {
            self.iconImageView.image = UIImage(named: "Snow")
            
        }
        
        else if icon.contains("50d") {
            self.iconImageView.image = UIImage(named: "Mist")
            
        }
        

       
    }
    
    func getDayForDate( date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday
        return formatter.string(from: inputDate)
        
    }
}
