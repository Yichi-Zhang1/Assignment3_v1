//
//  RecipeViewModel.swift
//  Assignment3
//
//  Created by Danny on 2020-11-03.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class NetworkController: NSObject {
    
    let apiBaseURL = "https://api.spoonacular.com";
    let apiToken = "410fe30a635c455aae8aeadb43718cee";
    
    var listener: NetworkListener
    
    func searchRecipes(query: String){
        
        self.listener.onRequest();
        
        let searchString = apiBaseURL + "/recipes/complexSearch" + "?query=" + query + "&apiKey=" + apiToken;
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!);
        
        let task = URLSession.shared.dataTask(with: jsonURL!) { (data, response, error) in
            
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
    
    func generateMealPlan(){
        self.listener.onRequest();
        
        let searchString = apiBaseURL + "/mealplanner/generate?timeFrame=day" + "&apiKey=" + apiToken;
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!);
        
        let task = URLSession.shared.dataTask(with: jsonURL!) { (data, response, error) in
            
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
        
}
