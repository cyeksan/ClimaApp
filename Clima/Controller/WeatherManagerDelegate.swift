//
//  WeatherDelegate.swift
//  Clima
//
//  Created by Cansu Aktas on 2023-09-22.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel)
    func didFailWithError(error: Error)
}
