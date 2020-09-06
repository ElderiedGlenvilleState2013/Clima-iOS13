//
//  WeatherMang.swift
//  Clima
//
//  Created by dadDev on 8/30/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//


import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ca8d6839414b2dbef88c9806e6b99beb&units=imperial"
    
    var delegate: WeatherManagerDelegate?
        
    func fetchWeather(city: String) {
        let weatherStringURL = "\(weatherURL)&q=\(city)"
        performRequest(with: weatherStringURL)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String) {
        //1 create url
        if let url = URL(string: urlString) {
            //2 create urlsession
            let session = URLSession(configuration: .default)
            
            //3 Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                 if error != nil {
                           print(error)
                    self.delegate?.didFailWithError(error: error!)
                           return
                       }
                       
                if let safeData = data {
                           //let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self,weather: weather)
                    }
                    //self.parseJSON(weatherData: safeData)
                       }
            } // end of task closure
            //4 start the task
            task.resume()
        } //end pf if let url
    } // end of function
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            
           let decodeData =  try decoder.decode(WeatherData.self, from: weatherData)
            print()
            let name = decodeData.name
            print(decodeData.weather[0].description)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            print(weather.conditionName)
            print(weather.temperatureString)
        } catch {
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    } //end parseJSON function
    
   
    
    

    
   
}// end of class
