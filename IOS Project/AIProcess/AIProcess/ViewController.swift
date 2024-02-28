//
//  ViewController.swift
//  AIProcess
//
//  Created by user on 26/02/24.
//

import UIKit
import Foundation
import SAPCommon
import SAPFoundation

class ViewController: UIViewController {
    @IBOutlet weak var txtAreperBedrooms: UITextField!
    @IBOutlet weak var txtBBRatio: UITextField!
    @IBOutlet weak var txtParking: UITextField!
    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var txtBedrooms: UITextField!
    @IBOutlet weak var txtBathrooms: UITextField!
    @IBOutlet weak var bttnClick:UIButton!
    @IBOutlet weak var txtGUest: UITextField!
    @IBOutlet weak var txtStories: UITextField!
    @IBOutlet weak var txtBasement: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func displayInfoMessage(MessageTitle title: String, MessageText msg: String)->UIAlertController{
        let oMsg = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        oMsg.addAction(UIAlertAction.init(title: "ok", style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
            oMsg.dismiss(animated: true, completion: nil)
        }))
        return oMsg
    }
    
    func sFetchAPIRespone(apiURL: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: apiURL) else {
            completion(nil)
            return
        }
        
        let sapSession = SAPURLSession()
        
        let task = sapSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(data)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func fetchAPIResponse(apiURL: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: apiURL) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(data)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }

    func extractHousePrice(from jsonData: Data) -> Double? {
        do {
            // Deserialize JSON data
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                // Extract "House Price" value
                if let housePrice = json["House Price"] as? Double {
                    return housePrice
                }
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
        return nil
    }
    
    
    @IBAction func bttnClickEvent(_ sender: Any) {
        let sBaseUrl = "https://.........hana.ondemand.com/?"
        let lvArea = txtArea.text!
        let lvBedrooms = txtBedrooms.text!
        let lvBathrooms = txtBathrooms.text!
        let lvStories = txtStories.text!
        let lvGuest = txtGUest.text!
        let lvBasement = txtBasement.text!
        let lvParking = txtParking.text!
        let lvAreaPerBedrooms = txtAreperBedrooms.text!
        let lvBBRatio = txtBBRatio.text!
        
        let sValueWith = sBaseUrl + "Area=\(lvArea)&Bedrooms=\(lvBedrooms)&Bathrooms=\(lvBathrooms)&Stories=\( lvStories)&Guest=\(lvGuest)&Basement=\(lvBasement)&Parking=\(lvParking)&AreaPerBedRoom=\(lvAreaPerBedrooms)&BBRatio=\(lvBBRatio)"
        
        self.sFetchAPIRespone(apiURL: sValueWith) { responseString in
            if let responseString = responseString {
                let lprice = String(self.extractHousePrice(from: responseString)!)
                let omsg = self.displayInfoMessage(MessageTitle: "House Price Prediction value", MessageText: lprice)
                DispatchQueue.main.sync {
                    self.present(omsg, animated: true, completion: nil)
                }
            } else {    
                print("Failed to fetch API response")
            }
        }
        
    }
    
}

