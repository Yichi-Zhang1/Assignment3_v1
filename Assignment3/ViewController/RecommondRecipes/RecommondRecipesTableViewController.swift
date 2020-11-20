//
//  RecommondRecipesTableViewController.swift
//  Assignment3
//
//  Created by admin on 2020/11/19.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class RecommondRecipesTableViewController: UITableViewController {

    
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

            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommondlist_cell", for: indexPath) as! RecommondListTableViewCell
        // Configure the cell...
        if(recipelist.count > 0){
            let recipe = recipelist[indexPath.row]
            //cell.searchImage.image = recipe.image as? UIImage
            cell.titleLabel.text = "    \(recipe.title )"
            cell.nameLabel.text = "    \(recipe.name )"
            cell.servingLabel.text = "    \(recipe.serving )"
            cell.minuteLabel.text = "    \(recipe.minute )"
            cell.priceLabel.text = "    \(recipe.price )"
            //configure the image
            let imageurl = recipe.image
            let jsonURL1 = URL(string: imageurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: jsonURL1 ?? URL(fileURLWithPath: "")) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        cell.recipeImage.image = UIImage(data: data)
                    }
                }
            }
            
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("\(recipelist.count)")
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "recommond_cell", for: indexPath) as! RecommondRecipesTableViewCell
            
            

            return
        }
        
    }
    
    
    //search recipe
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("\(searchBar.text ?? "error")")
//
//
//        //get the filter information from cell
//        let indexPath = NSIndexPath(row: 0, section: 0)
//        let filterCell = tableView.cellForRow(at: indexPath as IndexPath) as? RecommondRecipesTableViewCell
//        let diet = filterCell?.dietField.text ?? "nil"
//        let type = filterCell?.excludeField.text ?? "nil"
//        let cal = filterCell?.calField.text ?? "nil"
//        print("\(diet),\(type),\(cal)")
//        
//    }

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

}

class RecommondRecipe{
    var title: String
    var id: Int
    var image: String
    var name: String
    var serving: String
    var minute: String
    var price: String
    init(title: String, query: String, id: Int, image: String, name: String, serving: String, minute: String, price: String) {
        self.title = title
        self.id = id
        self.image = image
        self.name = name
        self.serving = serving
        self.minute = minute
        self.price = price
        
    }
}


