//
//  MainViewController.swift
//  Forecast
//
//  Created by Matthew D Mayberry on 7/31/16.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    var currentWeather = CurrentWeatherModel?() {
        didSet {
            modelDidChange()
        }
    }
    
    internal lazy var forecastManager = ForecastManager()
	let locationManager = CLLocationManager()
    
    private var cLat: CLLocationDegrees?
    private var cLon: CLLocationDegrees?
    
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var currentZipLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func locationButtonTouched(sender: AnyObject) {
		// print("Touched the current location button")
    }
    
    @IBAction func refresh(sender: AnyObject) {
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        
        fetchWeatherForecast(cLat: self.locationManager.location!.coordinate.latitude, cLon: self.locationManager.location!.coordinate.longitude)
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
	
        refreshActivityIndicator.hidden = true
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.locationManager.distanceFilter = 5000
        
        switch CLLocationManager.authorizationStatus() {
            case .AuthorizedWhenInUse:
                print("Good to go on location access")
            case .NotDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .Restricted, .Denied:
				presentAlert(title: "Location Services Required", message: "Local weather cannot be loaded without location services. Please approve to use the app.")
            default:
				presentAlert(title: "Location Services Failed", message: "Unable to determine location service autorization status.")
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func modelDidChange() {
        if let weather = self.currentWeather {
            self.temperatureLabel.text = "\(Int(weather.temperature))\u{00B0}"
            self.iconView.image = weather.icon!
            self.descriptionLabel.text = "\(weather.summary)"
            
            let humidityPercentage = (weather.humidity * 100)
            self.humidityLabel.text = "\(Int(humidityPercentage))%"
            let precipitationPercentage = (weather.precipProbability * 100)
            self.precipitationLabel.text = "\(Int(precipitationPercentage))%"
            
        } else {
			presentAlert(title: "Error", message: "Unable to load data. Connectivity error.")
        }
        // Stop refresh animation
        self.refreshActivityIndicator.stopAnimating()
        self.refreshActivityIndicator.hidden = true
        self.refreshButton.hidden = false
    }
	
	/// Initiate request for weather with new lat and lon
    func fetchWeatherForecast(cLat cLat: CLLocationDegrees, cLon: CLLocationDegrees, completion: (Void -> Void)? = nil) {
        
        let requestWeather = ForecastRequest(cLat: cLat, cLon: cLon)
        forecastManager.fetchWeatherResults(requestWeather) { [weak self] currentWeather in
            self?.currentWeather = currentWeather
            completion?()
        }
    }
	
	/// Update location labels with placemark names
	func displayLocationInfo(placemark: CLPlacemark) {
		if let locality = placemark.locality {
			currentCityLabel.text = String(locality)
			print(placemark.locality)
		}
		if let postalCode = placemark.postalCode {
			currentZipLabel.text = String(postalCode)
			print(placemark.postalCode)
		}
	}
	
// MARK: - Presentation Helpers
	
	/// Simple reusable function to present a dismissable alert to the User
	func presentAlert(title title:String, message:String, style:UIAlertActionStyle = .Cancel) {
		let alert = UIAlertController(title: title, message: message,
			preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Dismiss", style: style, handler: nil))
		self.presentViewController(alert, animated:true, completion: nil)
	}
}


// MARK: - Location Manager Delegate Methods
extension MainViewController: CLLocationManagerDelegate {
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Error: " + error.localizedDescription)
		presentAlert(title: "Location Error", message: "Location services failed with an error: \(error.localizedDescription)")
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let loc = locations.last else {
			print("Locations array assignment failed.")
			return
		}
		
		self.cLat = loc.coordinate.latitude
		self.cLon = loc.coordinate.longitude
		
		CLGeocoder().reverseGeocodeLocation(loc) { (placemarks, error) -> () in
			guard error == nil else {
				print("Error: " + error!.localizedDescription)
				return
			}
			
			if placemarks?.count > 0 {
				if let pm = placemarks?.first {
					self.displayLocationInfo(pm)
				}
			} else {
				print("Error with the placemark location data.")
			}
		}
		
		print("Looks like the location signigicantly changed, update the weather.")
		fetchWeatherForecast(cLat: loc.coordinate.latitude, cLon: loc.coordinate.longitude)
	}
}
