//
//  RecommondRecipesTableViewController.swift
//  Assignment3
//
//  Created by admin on 2020/11/19.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class RecommondRecipesTableViewController: UITableViewController, NetworkListener {
    func onRequest() {
        return
    }
    
    func onResponse(response: AnyObject?, error: Error?) {
        let res = response as? MealPlanResponse ?? nil
        if let res = res{
            recipelist.removeAll()
            if(res.meals?.count == 0){
                let alert = UIAlertController(title: "No result", message: "Sorry we did not find any results for you", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            for i in 0 ..< (res.meals!.count){
                let id = res.meals?[i].id
                let net = NetworkController(listener: self)
                net.getRecipeById(id: id!)
            }
        }else{
            let res2 = response as! RecipeDetail
            print("\(res2.title ?? "no result") ,  \(res2.nutrition.nutrients?[0].title ?? "no result") is : \(res2.nutrition.nutrients?[0].amount ?? 0.00)")
            
            //after get the recipe detail object, build the core data object
            let id = res2.id
            let title = res2.title
            let name = res2.sourceName
            
            let calories = "calories : \(res2.nutrition.nutrients?[0].amount ?? 0.00 )g. percent of daily need: \(String(format: "%.2f", Float(res2.nutrition.nutrients?[0].percentOfDailyNeeds ?? 0.0)))%"
            let fat = "fat : \(res2.nutrition.nutrients?[1].amount ?? 0.00)g. percent of daily need: \(String(format: "%.2f", Float(res2.nutrition.nutrients?[1].percentOfDailyNeeds ?? 0.0)))%"
            let protein = "protein : \(res2.nutrition.nutrients?[9].amount ?? 0.00)g. percent of daily need: \(String(format: "%.2f", Float(res2.nutrition.nutrients?[9].percentOfDailyNeeds ?? 0.0)))%"
            let ready = res2.readyInMinutes
            let serving = res2.servings
            let price = res2.pricePerServing
            
            var ingredients = [""]
            for index in 0...res2.extendedIngredients!.count-1{
                ingredients.append("\(res2.extendedIngredients?[index].original ?? "")")
            }
            ingredients.removeFirst()
            //let ingredent = res2.extendedIngredients
            
            //image store
            let imageurl = res2.image
            let jsonURL1 = URL(string: (imageurl!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
            DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: jsonURL1 ?? URL(fileURLWithPath: "")) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        //choosePlant.image = UIImage(data: data)
                        //self.delegate?.addNewPlant(plant: choosePlant)
                        let newRecipe = RecommondRecipe(title: title ?? "", id: id!, image: (UIImage(data: data) ?? UIImage(named: "burger"))!, name: name ?? "", serving: serving!, minute: ready!, price: price!, fat: fat, protein: protein, cal: calories, ingredents: ingredients)
                        self.recipelist.append(newRecipe)
                        self.tableView.reloadData()
                    }
                }
            }
        }
            
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recipelist = [RecommondRecipe]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return 1
        }
        return recipelist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "recommond_cell", for: indexPath) as! RecommondRecipesTableViewCell
            print(cell.dietField.text ?? "no result")
            // Configure the cell...

            cell.buttonClickCallback = {
                let diet = cell.dietField.text ?? "nil"
                let type = cell.excludeField.text ?? "nil"
                let cal = cell.calField.text ?? "10000"
                print("\(diet),\(type),\(cal)")
                
                let net = NetworkController(listener: self)
                net.generateMealPlan(targetCalories: Int(cal), diet: diet, exclude: type)

            }
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommondlist_cell", for: indexPath) as! RecommondListTableViewCell
        // Configure the cell...
        if(recipelist.count > 0){
            let recipe = recipelist[indexPath.row]
            //cell.searchImage.image = recipe.image as? UIImage
            cell.titleLabel.text = "    \(recipe.name )"
            cell.nameLabel.text = "    \(recipe.title )"
            cell.servingLabel.text = "\(recipe.serving) people"
            cell.minuteLabel.text = " \(recipe.minute) minutes"
            cell.priceLabel.text = "\(String(format: "%.2f", Float(recipe.price)/10))$"
            //configure the image
            cell.recipeImage.image = recipe.image

            
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            return
        }
        
        let recipe = recipelist[indexPath.row]
        
        
        //after get the recipe detail object, build the core data object
        let id = recipe.id
        
        //check if there is duplicate data
        let list = getData()
        var duplicate = false
        for i in 0 ..< (list.count){
            if(list[i].id == id){
                let alert = UIAlertController(title: "Duplicate data", message: "This recipe has already in the favourite list", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                duplicate = true
                break
            }
        }
        if(duplicate == true){
            return
        }
        let title = recipe.title
        let name = recipe.name
        
        let calories = recipe.cal
        let fat = recipe.fat
        let protein = recipe.protein
        let ready = recipe.minute
        let serving = recipe.serving
        let price = recipe.price
        
        var ingredients = [""]
        for index in 0...recipe.ingredents.count-1{
            ingredients.append("\(recipe.ingredents[index] )")
        }
        ingredients.removeFirst()
        //let ingredent = res2.extendedIngredients
        
        //image store
        let image = recipe.image
        
        let newrecipe = Recipe(context: self.context)
        newrecipe.id = Int64.init("\(id )") ?? 0
        newrecipe.title = title
        newrecipe.name = name
        newrecipe.calories = calories
        newrecipe.fat = fat
        newrecipe.protein = protein
        newrecipe.servings = Int16.init("\(serving )") ?? 0
        newrecipe.readyInMinutes = Int16.init("\(ready )") ?? 0
        newrecipe.image = image
        newrecipe.ingredents = ingredients
        newrecipe.pricePerServing = price
        self.saveData()
        let anotherViewController = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController

        anotherViewController.recipe = newrecipe
        anotherViewController.check = false
        anotherViewController.btn.tag = 1
        self.navigationController?.pushViewController(anotherViewController, animated: true)
    }
    
    //保存core数据
    func saveData(){
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    //读取coredata数据
    func getData() -> [Recipe]{
        var list = [Recipe]()
        do{
            try list = context.fetch(Recipe.fetchRequest())
        }catch{
            print(error)
        }
        return list
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class RecommondRecipe{
    var title: String
    var id: Int
    var image: UIImage
    var name: String
    var serving: Int
    var minute: Int
    var price: Double
    var fat: String
    var protein: String
    var cal: String
    var ingredents: [String]
    init(title: String, id: Int, image: UIImage, name: String, serving: Int, minute: Int, price: Double, fat: String, protein: String, cal: String, ingredents: [String]) {
        self.title = title
        self.id = id
        self.image = image
        self.name = name
        self.serving = serving
        self.minute = minute
        self.price = price
        self.fat = fat
        self.protein = protein
        self.cal = cal
        self.ingredents = ingredents
    }
}


