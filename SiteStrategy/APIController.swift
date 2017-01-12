//
//  APIController.swift
//  SiteStrategy
//
//  Created by Irl D Jones on 9/28/16.
//  Copyright © 2016 inSkyLE. All rights reserved.
//

import Foundation
import UIKit

class APIController {
    
    let apiKey = "uZ2g4TXkBD19FTj6AITRGpI06CFxEfsTuhoUMsDh"
    let hotelKey = "krm3GQA183ICrelrNQnbqHa2sIqP0Jzi"
    
    func dateToString(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter.string(from: date as Date)
    }
    
    func createURLWithString(date: NSDate) -> NSURL? {
        var urlString: String = "https://api.nasa.gov/planetary/apod?"
        
        //https://api.nasa.gov/planetary/apod?api_key=uZ2g4TXkBD19FTj6AITRGpI06CFxEfsTuhoUMsDh
        /*urlString = urlString.appending("?date=" + dateToString(date: date))
        urlString = urlString.appending("&concept_tags=false")
        urlString = urlString.appending("&hd=false")*/
        urlString = urlString.appending("api_key=" + apiKey)
        
        var hotelUrlString: String = "http://terminal2.expedia.com:80/x/mhotels/search?"
        hotelUrlString = hotelUrlString.appending("city=PSP")
        hotelUrlString = hotelUrlString.appending("&filterHotelName=Hyatt")
        hotelUrlString = hotelUrlString.appending("&checkInDate=2016-12-01")
        hotelUrlString = hotelUrlString.appending("&checkOutDate=2016-12-03")
        hotelUrlString = hotelUrlString.appending("&room1=2")
        /*var hotelUrlString: String = "http://terminal2.expedia.com:80/x/mhotels/info?"
        hotelUrlString = hotelUrlString.appending("hotelId=6305")*/
        hotelUrlString = hotelUrlString.appending("&apikey=" + hotelKey)
        
        return NSURL(string: hotelUrlString)
    }
    
    func createURLWithComponents(date: NSDate) -> NSURL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https";
        urlComponents.host = "api.nasa.gov";
        urlComponents.path = "/planetary/apod";
        
        let dateQuery  = NSURLQueryItem(name: "date", value: dateToString(date: date))
        let conceptQuery = NSURLQueryItem(name: "concept_tags", value: "false")
        let hdQuery = NSURLQueryItem(name: "hd", value: "false")
        let apiKeyQuery = NSURLQueryItem(name: "api_key", value: apiKey)
        urlComponents.queryItems = [dateQuery as URLQueryItem, conceptQuery as URLQueryItem, hdQuery as URLQueryItem, apiKeyQuery as URLQueryItem]
        
        return urlComponents.url as NSURL?
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func getAPOD(date: NSDate) -> NSArray {
        var photoStrings = [String]()
        guard let url = createURLWithString(date: date) else {
            print("invalid URL")
            //let image = UIImage(named: "firePin")
            photoStrings.append("No Photos")
            return photoStrings as NSArray
        }
        
        
        let urlRequest = NSURLRequest(url: url as URL)
        print("url request")
        print(urlRequest)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var imaged: UIImage?  = UIImage(named: "firePin")!
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, _, error) in
            do {
                guard error == nil else {
                    print(error!)
                    return
                }
                if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                    print("here")
                    print("here is the json results\(json)")
                    
                    //do{
                        if let photos = json["photos"] as? [[String: AnyObject]]{
                            for photo in photos {
                                if let path = photo["thumbnailUrl"] as? String {
                                    photoStrings.append("http://images.travelnow.com\(path)")
                                }
                            }
                        }
                    if let photos = json["hotelList"] as? [[String: AnyObject]]{
                        for photo in photos {
                            if let path = photo["localizedName"] as? String, let hid = photo["hotelId"] as? String {
                                photoStrings.append("http://images.travelnow.com\(path) \(hid)")
                            }
                        }
                    }
                    /*} catch {
                        print("error serializing JSON: \(error)")
                    }*/
                    print("here are the paths \(photoStrings)")
                    
                    /*let imageURLString = photoStrings[0]
                    let testImage = "http://images.travelnow.com\(imageURLString)"
                    print("here is the image string \(testImage)")
                    
                    self.getDataFromUrl(url: NSURL(string: testImage) as! URL) { (data, response, error)  in
                        DispatchQueue.main.sync() { () -> Void in
                            guard let data = data, error == nil else { return }
                            print(response?.suggestedFilename ?? url.lastPathComponent)
                            print("Download Finished")
                            imaged = UIImage(data: data)
                        }
                    }*/
                    
                    /*let datas = try NSData(contentsOf: NSURL(string: testImage) as! URL) as Data
                    //print(datas)
                    imaged = UIImage(data: datas)!*/
                    
                }
            } catch {
                // handle the error
            }
        })
        task.resume()
        return photoStrings as NSArray
    }
        
}

