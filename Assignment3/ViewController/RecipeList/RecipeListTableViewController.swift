//
//  RecipeListTableViewController.swift
//  Assignment3
//
//  Created by admin on 2020/11/15.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class RecipeListTableViewController: UITableViewController {

    //定义成员变量
    //context用于调用core data方法如存入默认菜单
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    //recipelist代表显示在tableview里的所有菜单
    var recipelist = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDefaultData()
        recipelist = getData()
//        tableView.reloadData()
//
//        do{
//            try print("数据库数量： \(context.count(for: Recipe.fetchRequest()))")
//        }catch{
//            print(error)
//        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipelist = getData()
        tableView.reloadData()
        do{
            try print("数据库数量： \(context.count(for: Recipe.fetchRequest()))")
        }catch{
            print(error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipelist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipe_cell", for: indexPath) as! RecipeTableViewCell
        let recipe = recipelist[indexPath.row]
        cell.recipeImage.image = recipe.image as? UIImage
        cell.titleLabel.text = "    \(recipe.name ?? "no result")"
        cell.nameLabel.text = "    \(recipe.title ?? "no result")"
        cell.minutesLabel.text = "\(recipe.readyInMinutes ) mintues"
        cell.servingLabel.text = "\(recipe.servings ) people"


        print("\(recipe.protein ?? "nil") minutes. \(recipe.fat ?? "nil") people")
        return cell
    }
    
    //delete function
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //core data delete function
            context.delete(recipelist[indexPath.row])
            recipelist.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    
    //select the item to check details
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let anotherViewController = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController

        anotherViewController.recipe = recipelist[indexPath.row]
        anotherViewController.check = false
        anotherViewController.btn.tag=1
        self.navigationController?.pushViewController(anotherViewController, animated: true)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
//        let destination = segue.destination as! RecipeSearchTableViewController
//        destination.delegate = self
    
        
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
    
    //保存默认菜单（若当前coredata为空才保存默认菜单）
    func loadDefaultData(){
        var number = 0
        recipelist = getData()
        do{
            try number = context.count(for: Recipe.fetchRequest())
            print("初始判断数据库 \(number )")
        }catch{
            print(error)
        }
        if number == 0{
            //default recipes
            let r1 = Recipe(context: context)
            r1.name = "double beef burger"
            r1.title = "burger"
            r1.image = UIImage(named: "burger")
            r1.readyInMinutes = 30
            r1.servings = 3
            r1.id = 716429
            r1.fat = "fat is:20g, percent of daily need: 30% "
            r1.ingredents = ["wash","cut","cook","aa","ba","xa","ca","ca","ca","aa","aa","aa"]
            r1.protein = "protein is:30g, percent of daily need: 40% "
            r1.calories = "cal is:40g, percent of daily need: 50% "
            r1.pricePerServing = 1.62
            
            
            let r2 = Recipe(context: context)
            r2.name = "chicken"
            r2.title = "Coles roast chicken"
            r2.image = UIImage(named: "chicken")
            r2.readyInMinutes = 40
            r2.servings = 5
            r2.id = 716429
            r2.fat = "fat is:20g, percent of daily need: 30% "
            r2.ingredents = ["wash","cut","cook"]
            r2.protein = "protein is:30g, percent of daily need: 40% "
            r2.calories = "cal is:40g, percent of daily need: 50% "
            r2.pricePerServing = 5.3
            saveData()
        }
            
            
    }

}

extension RecipeListTableViewController: AddNewRecipeDelegate{
    func addNewRecipe(recipe: Recipe) {
        recipelist.append(recipe)
        let indexpath = IndexPath(row: recipelist.count-1, section: 0)
        tableView.insertRows(at: [indexpath], with: UITableView.RowAnimation.automatic)
        tableView.reloadData()
    }
}
