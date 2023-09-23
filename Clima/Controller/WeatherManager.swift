//
//  WeatherManager.swift
//  Clima
//
//  Created by Cansu Aktas on 2023-08-23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather?appid=b63def9d6ca05b2808b93be36b2ee119"
    
    
    func fetchWeather(city: String) {
        let urlString = "\(baseUrl)&q=\(city.lowercased())"
        performRequest(with: urlString)
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = "\(baseUrl)&lat=\(Double(lat))&lon=\(Double(lon))"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let safeWeather = self.parseJSON(safeData) {
                        delegate?.didUpdateWeather(safeWeather)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temp)
            return weather
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
