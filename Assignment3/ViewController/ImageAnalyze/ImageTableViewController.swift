//
//  ImageTableViewController.swift
//  Assignment3
//
//  Created by admin on 2020/11/21.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseStorage


class ImageTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NetworkListener {
    func onRequest() {
        return
    }
    
    func onResponse(response: AnyObject?, error: Error?) {
        let res = response as? ImageAnalysisResponse ?? nil
        if let res = res{
            recipelist.removeAll()
            if(res.recipes?.count == 0){
                let alert = UIAlertController(title: "No result", message: "Sorry we did not find any results for you", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            let indexPath = NSIndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: indexPath as IndexPath) as? ImageUploadTableViewCell

            guard let category: String = res.category?.name else{
                return
            }
            guard let probability: Double = res.category?.probability else{
                return
            }
            cell!.cateLabel.text = "\(category)"
            cell!.possibilityLabel.text = "\(String(format: "%.2f", Float(probability)*100))%"
            //cell!.possibilityLabel.text = "\(String(probability*100))%"
            print("\(res.recipes!.count)")
            
            
            //only store 3 results, otherwise cost too much tokens
            var length = Int()
            if(res.recipes!.count < 3){
                length = res.recipes!.count
            }else{
                length = 3
            }
            for i in 0 ..< length{
                let id = res.recipes?[i].id
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
    private let storage = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "upload_cell", for: indexPath) as! ImageUploadTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "imagelist_cell", for: indexPath) as! ImageListTableViewCell
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

        // Configure the cell...

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
    
    //called when user choose an image from the library
    //用户选择了照片后运行该方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        
        let indexPath = NSIndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as? ImageUploadTableViewCell
        cell?.uploadImage.image = image
        cell?.possImage.isHidden = false
        cell?.cateLabel.isHidden = false
        cell?.cateImage.isHidden = false
        cell?.possibilityLabel.isHidden = false
        cell?.messageLabel.isHidden = false
        
        guard let imageData = image.pngData() else{
            return
        }
        //upload image data
        //get download url
        //save url to userDefaults
        
        // Create file metadata including the content type
        
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        storage.child("file.png").putData(imageData, metadata: metadata, completion: {_, error in
            guard error == nil else{
                print("Failed to upload")
                return
            }
            self.storage.child("file.png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else{
                    return
                }
                let urlString = url.absoluteString
                
                //modify the url, remove token
                let modifyUrl =  urlString.components(separatedBy: "&")[0]
                
                //print("downloading the url : \(modifyUrl)")
                //self.urlLabel.text = modifyUrl
                UserDefaults.standard.set(modifyUrl, forKey: "url")
                
                let control = NetworkController(listener: self)
                control.imageClassification(url: modifyUrl)
                
            })
            
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadBtn(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true)
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
