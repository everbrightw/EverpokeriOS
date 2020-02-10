//
//  InputViewController.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/18/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import Foundation
import UIKit

import Firebase
import CoreLocation

class InputViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var cashedOutTextField: UITextField!
    @IBOutlet weak var buyInTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var blindsTextField: UITextField!
    @IBOutlet weak var gameTypeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet var setCurrentLocationButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    
    var locationManager:CLLocationManager!
    
    var startDate:Date?;
    var endDate:Date?;
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(submitButton)
        determineMyCurrentLocation()
        let cityCoords = locationManager.location
        getAdressName(coords: cityCoords!)
        setUpDatePickerForTextFields()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
       // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func getAdressName(coords: CLLocation){

      CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
          if error != nil {
              print("Hay un error")
          } else {

              let place = placemark! as [CLPlacemark]
              if place.count > 0 {
                  let place = placemark![0]
                  var adressString : String = ""
                  if place.subThoroughfare != nil {
                      adressString = adressString + place.subThoroughfare! + ", "
                  }
                  if place.thoroughfare != nil {
                      adressString = adressString + place.thoroughfare! + ", "
                    
                  }
                  if place.locality != nil {
                      adressString = adressString + place.locality!
                      print("address",adressString)
                    self.setCurrentLocationButton.setTitle(adressString, for: .normal)
                      
                  }
                  if place.subAdministrativeArea != nil {
                      adressString = adressString + place.subAdministrativeArea!
                  }
                  if place.postalCode != nil {
                      adressString = adressString + place.postalCode! + "\n"
                  }
                  if place.country != nil {
                      adressString = adressString + place.country!
                  }
              }
            
          }
        }
    }
    
    // MARK: -setting up date picker for startTimeTextField and endTimeTextField
    fileprivate func setUpDatePickerForTextFields() {
        
        //date picker
        startTimeTextField.inputView = datePicker
        //create a toolbar
        let startToolbar = UIToolbar()
        startToolbar.sizeToFit()
        
        //add a done button on this toolbar
        let startDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startTimeDateDoneHandler))
        
        startToolbar.setItems([startDoneButton], animated: true)
        
        startTimeTextField.inputAccessoryView = startToolbar
        
        
        // configure end time toolbar
        endTimeTextField.inputView = datePicker
        let endToolBar = UIToolbar()
        endToolBar.sizeToFit()
    
        //add a done button on this toolbar
        let endDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endTimeDateDoneHandler))
        
        endToolBar.setItems([endDoneButton], animated: true)
        
        endTimeTextField.inputAccessoryView = endToolBar
    }
    
    
    // MARK: -handling date text field's done clicked for startTimeTextField date picker
    @objc func startTimeDateDoneHandler(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        startDate = datePicker.date
        startTimeTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    // MARK: -handling date text field's done clicked for endTimeTextField date picker
    @objc func endTimeDateDoneHandler(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        endDate = datePicker.date
        endTimeTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func validateFields()-> String? {
        //checking if all fields are filled
        if startTimeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || cashedOutTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || buyInTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Some fields are not filled"
        }
        
        
        return nil
    }
    
    func timeFormatted(totalSeconds: Int) -> String {
       let minutes: Int = (totalSeconds / 60) % 60
       let hours: Int = totalSeconds / 3600
       return String(format: "%02d:%02d", hours, minutes)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        
        let db = Firestore.firestore()
        if validateFields() == nil{
            // All textfield are filled
            
            // Store information in backend
            // get value from text fields
            let gameTypeVal = gameTypeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let locationVal = locationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let blindsVal = blindsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let buyinVal = buyInTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cashedOutVal = cashedOutTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let startDateVal = startTimeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let endDateVal = endTimeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let date = startTimeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let netResultVal : Int = (Int(cashedOutVal) ?? 0) - (Int(buyinVal) ?? 0)
            // foramte duration to HH:MM
            let interval = timeFormatted(totalSeconds: Int(endDate! - startDate!))
            print(interval)
            // Adding document to collection
            //EEEE, MMM d, yyyy
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
            print("format date", dateFormatter.string(from: startDate ?? Date()))
            var ref: DocumentReference? = nil
                   ref = db.collection("histories").addDocument(data: [
                       "user_id" : Auth.auth().currentUser!.uid,
                       "game_type": gameTypeVal,
                       "location": locationVal,
                       "blinds": blindsVal,
                       "buy_in": buyinVal,
                       "cashed_out" : cashedOutVal,
                       "duration" : interval,
                       "net_result": netResultVal,
                       "date":dateFormatter.string(from: startDate ?? Date())
                   ]) { err in
                       if let err = err {
                           print("Error adding document: \(err)")
                       } else {
                           print("Document added with ID: \(ref!.documentID)")
                       }
                   }
            
            // Dissmiss input page
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    @IBAction func setCurrentLocation(_ sender: Any) {
        locationTextField.text = setCurrentLocationButton.titleLabel?.text
    }
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
