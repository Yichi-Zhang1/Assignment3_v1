//
//  RecipeViewModel.swift
//  Assignment3
//
//  Created by Danny on 2020-11-03.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class NetworkController: NSObject {
    
    let apiBaseURL = "https://api.spoonacular.com";
    //let apiToken = "410fe30a635c455aae8aeadb43718cee";
    let apiToken = "83e3d9f6c0184a41afda8ee420df6313";
    
    var listener: NetworkListener
    
    init(listener: NetworkListener) {
        self.listener = listener
    }
    
    func searchRecipes(query: String, type: String?, diet: String? ,cuisine: [String]?, includeIngredients: [String]?, maxReadyTime: Int?, offset: Int?){
        
        var urlComp = URLComponents(string: apiBaseURL + "/recipes/complexSearch")!
        
        var urlQueryItems = [URLQueryItem(name: "apiKey", value: apiToken), URLQueryItem(name: "query", value: query)]
        
        if type != nil {
            urlQueryItems.append(URLQueryItem(name: "type", value: type!))
        }
        
        if diet != nil {
            urlQueryItems.append(URLQueryItem(name: "diet", value: diet!))
        }
        
        if cuisine != nil {
            var result = ""
            for str in cuisine! {
                if result.isEmpty {
                    result.append(str)
                }else{
                    result.append(",")
                    result.append(str)
                }
            }
            urlQueryItems.append(URLQueryItem(name: "cuisine", value: result))
        }
        
        if includeIngredients != nil {
            var result = ""
            for str in includeIngredients! {
                if result.isEmpty {
                    result.append(str)
                }else{
                    result.append(",")
                    result.append(str)
                }
            }
            urlQueryItems.append(URLQueryItem(name: "includeIngredients", value: result))
        }
        
        if maxReadyTime != nil {
            urlQueryItems.append(URLQueryItem(name: "maxReadyTime", value: String(maxReadyTime!)))
        }
        
        if offset != nil {
            urlQueryItems.append(URLQueryItem(name: "offset", value: String(offset!)))
        }
        
        urlComp.queryItems = urlQueryItems
        
        self.listener.onRequest();
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: urlComp.url!)) { (data, response, error) in
            
            do{
                let decoder = JSONDecoder();
                
                let recipeResponse = try decoder.decode(RecipeResponse.self, from: data!);
                
                DispatchQueue.main.async {
                    self.listener.onResponse(response: recipeResponse, error: nil);
                }
                
            } catch let error {
                print(error);
                
                DispatchQueue.main.async {
                    self.listener.onResponse(response: nil, error: error);
                }
            }
        }
        
        task.resume();
    }
    
    func getRecipeById(id: Int) {
        self.listener.onRequest()
        
        var urlComp = URLComponents(string: apiBaseURL + "/recipes/" + String(id) + "/information")!
        
        let urlQueryItems = [URLQueryItem(name: "apiKey", value: self.apiToken),URLQueryItem(name: "includeNutrition", value: "true")]
        
        urlComp.queryItems = urlQueryItems
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: urlComp.url!)) { (data, response, error) in
            
            do{
                let decoder = JSONDecoder();
                
                let recipeDetail = try decoder.decode(RecipeDetail.self, from: data!);
                
                DispatchQueue.main.async {
                    self.listener.onResponse(response: recipeDetail, error: nil);
                }
                
            } catch let error {
                print(error);
                
                DispatchQueue.main.async {
                    self.listener.onResponse(response: nil, error: error);
                }
            }
        }
        
        task.resume()
    }
    
    func generateMealPlan(targetCalories: Int?, diet: String?, exclude: String?){
        self.listener.onRequest();
        
        var urlComp = URLComponents(string: apiBaseURL + "/mealplanner/generate")!
        
        var urlQueryItems = [URLQueryItem(name: "apiKey", value: self.apiToken),URLQueryItem(name: "timeFrame", value: "day")]
        
        if targetCalories != nil {
            urlQueryItems.append(URLQueryItem(name: "targetCalories", value: String(targetCalories!)))
        }
        
        if targetCalories != nil {
            urlQueryItems.append(URLQueryItem(name: "diet", value: diet!))
        }

        if targetCalories != nil {
            urlQueryItems.append(URLQueryItem(name: "exclude", value: exclude!))
        }
        
        urlComp.queryItems = urlQueryItems

        let task = URLSession.shared.dataTask(with: urlComp.url!) { (data, response, error) in
            
            do{
                let decoder = JSONDecoder();
                
                let mealPlanResponse = try decoder.decode(MealPlanResponse.self, from: data!);
                
                DispatchQueue.main.async {
                    self.listener.onResponse(response: mealPlanResponse, error: nil);
                }
                
            } catch let error {
                print(error);
                
                DispatchQueue.main.async {
                    self.listener.onResponse(response: nil, error: error);
                }
            }
        }
        
        task.resume();
    }
    
//    func generateMealPlan(){
//        self.listener.onRequest();
//
//        let searchString = apiBaseURL + "/mealplanner/generate?timeFrame=day" + "&apiKey=" + apiToken;
//        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!);
//
//        let task = URLSession.shared.dataTask(with: jsonURL!) { (data, response, error) in
//
//            do{
//                let decoder = JSONDecoder();
//
//                let mealPlanResponse = try decoder.decode(MealPlanResponse.self, from: data!);
//
//                DispatchQueue.main.async {
//                    self.listener.onResponse(response: mealPlanResponse, error: nil);
//                }
//
//            } catch let error {
//                print(error);
//
//                DispatchQueue.main.async {
//                    self.listener.onResponse(response: nil, error: error);
//                }
//            }
//        }
//
//        task.resume();
//    }
    
    func findQuickAnswer(query: String) {
        self.listener.onRequest();
        
        let searchString = apiBaseURL + "/food/converse" + "?apiKey=" + apiToken + "&text=" + query;
        
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!);
        
        
        let task = URLSession.shared.dataTask(with: jsonURL!) { (data, response, error) in
            
            do{
                let decoder = JSONDecoder();
                
                let qAResponse = try decoder.decode(QAResponse.self, from: data!);
                
                DispatchQueue.main.async {
                    self.listener.onResponse(response: qAResponse, error: nil);
                }
                
            } catch let error {
                print(error);
                
                DispatchQueue.main.async {
                    self.listener.onResponse(response: nil, error: error);
                }
            }
        }
        task.resume();
        
    }
    
    func imageClassification(url: String){
        self.listener.onRequest();
        
        let searchString = self.apiBaseURL + "/food/images/analyze" + "?apiKey=" + self.apiToken + "&imageUrl=" + url;
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!);
        
        let task = URLSession.shared.dataTask(with: jsonURL!) { (data, response, error) in
            
            do{
                let decoder = JSONDecoder();
                
                let imageAnalysisResponse = try decoder.decode(ImageAnalysisResponse.self, from: data!);
                
                DispatchQueue.main.async {
                    self.listener.onResponse(response: imageAnalysisResponse, error: nil);
                }
                
            } catch let error {
                print(error);
                
                DispatchQueue.main.async {
                    self.listener.onResponse(response: nil, error: error);
                }
            }
        }
        
        task.resume();
    }
    
    func imageAnalysis(image: UIImage){
        self.listener.onRequest();
        
        let storageRef = Storage.storage().reference()
        
        let imageRef = storageRef.child(String(NSDate().timeIntervalSince1970))
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        imageRef.putData(image.pngData()!, metadata: metaData) { (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                //store downloadURL
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    
                    
                    //analysis
                    
//                    let searchString = self.apiBaseURL + "/food/images/analyze" + "?apiKey=" + self.apiToken + "&imageUrl=" + downloadURL.absoluteString;
//                    print(searchString);
                    
                    
                    let urlParms = [URLQueryItem(name: "apiKey", value: self.apiToken), URLQueryItem(name: "imageUrl", value: downloadURL.absoluteString)];
                    
                    var urlComps = URLComponents(string: self.apiBaseURL + "/food/images/analyze")!
                    
                    urlComps.queryItems = urlParms
                    
                    //print(urlComps.url?.absoluteURL)
                    
                    var request = URLRequest(url: urlComps.url!)
                    
                    request.httpMethod = "GET";
                    
                    //let imageData = image.pngData()
                    
                    //request.httpBody = imageData;
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        
                        do{
                            //print(response as Any)
                            
                            let decoder = JSONDecoder();
                            
                            let imageAnalysisResponse = try decoder.decode(ImageAnalysisResponse.self, from: data!);
                            
                            DispatchQueue.main.async {
                                self.listener.onResponse(response: imageAnalysisResponse, error: nil);
                            }
                            
                        } catch let error {
                            print(error);
                            
                            DispatchQueue.main.async {
                                self.listener.onResponse(response: nil, error: error);
                            }
                        }
                    }
                    
                    task.resume();
                }
            }
        }
        
        
    }
    
}
