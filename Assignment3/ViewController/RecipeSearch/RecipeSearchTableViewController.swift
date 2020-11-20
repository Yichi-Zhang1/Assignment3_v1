//
//  RecipeSearchTableViewController.swift
//  Assignment3
//
//  Created by admin on 2020/11/15.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

protocol AddNewRecipeDelegate {
    func addNewRecipe(recipe: Recipe)
}


class RecipeSearchTableViewController: UITableViewController, UISearchBarDelegate, NetworkListener {
    var diet: String?

    
    
    //定义成员变量
    //context用于调用core data方法如存入默认菜单
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    
    //recipelist代表显示在tableview里的所有菜单
    var recipelist = [CustomRecipe]()
    var query: String?
    
    var delegate: AddNewRecipeDelegate?
    
    //no use
    func onRequest() {
        return
    }
    
    func onResponse(response: AnyObject?, error: Error?) {
        let res = response as? RecipeResponse ?? nil
        if let res = res{
            recipelist.removeAll()
            print("\(res.totalResults ?? 0)")
            if(res.totalResults == 0){
                let alert = UIAlertController(title: "No result", message: "Sorry we did not find any results for you", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            for i in 0 ..< (res.results!.count){
//                print("\(res?.results?[i].title ?? "no result")")
//                print("\(query ?? "no result")")
//                print("\(res?.results?[i].image ?? "no image")")
//                print("\(res?.results?[i].id ?? 0)")
                let r = CustomRecipe(title: "\(res.results?[i].title ?? "no result")", query: "\(query ?? "no result")", id: res.results?[i].id ?? 0, image: res.results?[i].image ?? "no image")
                recipelist.append(r)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }else{
            let res2 = response as! RecipeDetail
            print("\(recipelist.count)")
            //print(res2.extendedIngredients?[0].original ?? "没得到详细菜单")
            print("\(res2.title ?? "no result") ,  \(res2.nutrition.nutrients?[0].title ?? "no result") is : \(res2.nutrition.nutrients?[0].amount ?? 0.00)")
            
            //after get the recipe detail object, build the core data object
            let id = res2.id
            let title = res2.title
            let name = query
            
            
            //\(String(format: "%.2f", Float(res2.nutrition.nutrients?[0].amount)))
            
            
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
            let jsonURL1 = URL(string: (imageurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
            DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: jsonURL1 ?? URL(fileURLWithPath: "")) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        //choosePlant.image = UIImage(data: data)
                        //self.delegate?.addNewPlant(plant: choosePlant)
                        let newrecipe = Recipe(context: self.context)
                        newrecipe.id = Int64.init("\(id ?? 0)") ?? 0
                        newrecipe.title = title
                        newrecipe.name = name
                        newrecipe.calories = calories
                        newrecipe.fat = fat
                        newrecipe.protein = protein
                        newrecipe.servings = Int16.init("\(serving ?? 0)") ?? 0
                        newrecipe.readyInMinutes = Int16.init("\(ready ?? 0)") ?? 0
                        newrecipe.image = UIImage(data: data)
                        newrecipe.ingredents = ingredients
                        newrecipe.pricePerServing = price ?? 0.00
                        //newrecipe.ingredents = ["test1","test2"]
                        self.delegate?.addNewRecipe(recipe: newrecipe)
                        self.saveData()
                        self.navigationController?.popViewController(animated: true)
                        print("\(ingredients[0] ) haha")
                        print("\(newrecipe.id)")
                    }
                }
            }
        }
    }
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recipes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        if(indexPath.section == 0){
            let filtercell = tableView.dequeueReusableCell(withIdentifier: "filter_cell", for: indexPath) as! RecipeFilterTableViewCell
           
            return filtercell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "search_recipe_cell", for: indexPath) as! RecipeSearchTableViewCell
        if(recipelist.count > 0){
            let recipe = recipelist[indexPath.row]
            //cell.searchImage.image = recipe.image as? UIImage
            cell.searchTitle.text = "    \(recipe.title )"
            //configure the image
            let imageurl = recipe.image
            let jsonURL1 = URL(string: imageurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: jsonURL1 ?? URL(fileURLWithPath: "")) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        cell.searchImage.image = UIImage(data: data)
                    }
                }
            }
            
        }
        
        return cell
    }
    
    //search recipe
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("\(searchBar.text ?? "error")")
        let net = NetworkController(listener: self)
        query = "\(searchBar.text ?? "error")"
        
        //get the filter information from cell
        let indexPath = NSIndexPath(row: 0, section: 0)
        let filterCell = tableView.cellForRow(at: indexPath as IndexPath) as? RecipeFilterTableViewCell
        //let diet = filterCell?.dietField.text ?? "nil"
        //let type = filterCell?.typeField.text ?? "nil"
        //let minute = filterCell?.minuteField.text ?? "nil"
        //print("\(diet),\(type),\(minute)")
        net.searchRecipes(query: "\(searchBar.text ?? "error")", type: filterCell?.typeField.text ?? "", diet: filterCell?.dietField.text ?? "", cuisine: [String](), includeIngredients: [String](), maxReadyTime: Int(filterCell?.minuteField.text ?? "100"), offset:0)
    }
    
    //select a recipe to add to coredata
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //search details by id
        //print("\(recipelist.count)")
        if(indexPath.section == 0){
            return
        }
        let net = NetworkController(listener: self)
        let recipe = recipelist[indexPath.row]
        //print("\(recipe.title ?? "no result") id is : \(recipe.id )")
        net.getRecipeById(id: recipe.id)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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

}

class CustomRecipe{
    var title: String
    var query: String
    var id: Int
    var image: String
    init(title: String, query: String, id: Int, image: String) {
        self.title = title
        self.query = query
        self.id = id
        self.image = image
    }
}
