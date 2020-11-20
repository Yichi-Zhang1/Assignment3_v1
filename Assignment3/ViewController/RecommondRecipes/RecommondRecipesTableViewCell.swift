//
//  RecommondRecipesTableViewCell.swift
//  Assignment3
//
//  Created by admin on 2020/11/19.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class RecommondRecipesTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var dietField: UITextField!
    @IBOutlet weak var excludeField: UITextField!
    @IBOutlet weak var calField: UITextField!
    @IBOutlet weak var generateBtn: UIButton!
    
    @IBAction func TappedBtn(_ sender: Any) {
        let diet = dietField.text ?? "nil"
        let type = excludeField.text ?? "nil"
        let cal = calField.text ?? "nil"
        print("\(diet),\(type),\(cal)")
    }
    let diet = ["nil","Gluten Free","Ketogenic","Vegetarian","Lacto-Vegetarian","Ovo-Vegetarian","Vegan"]
    let exclude = ["nil","shellfish","olives"]
    let cal = [500,1000,1500,2000,2500,3000]
    
    var pickerview = UIPickerView()
    var expickerview = UIPickerView()
    var calpickerview = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        pickerview.delegate = self
        pickerview.dataSource = self
        dietField.inputView = pickerview
        dietField.textAlignment = .center
        dietField.attributedPlaceholder = NSAttributedString(string: "choose diet", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        expickerview.delegate = self
        expickerview.dataSource = self
        excludeField.inputView = expickerview
        excludeField.textAlignment = .center
        excludeField.attributedPlaceholder = NSAttributedString(string: "choose exclude", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])

        calpickerview.delegate = self
        calpickerview.dataSource = self
        calField.inputView = calpickerview
        calField.textAlignment = .center
        calField.attributedPlaceholder = NSAttributedString(string: "choose calories", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        // Configure the view for the selected state
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == pickerview){
            return diet.count
        }
        if(pickerView == expickerview){
            return exclude.count
        }
        if(pickerView == calpickerview){
            return cal.count
        }
        return 1
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == pickerview){
            return diet[row]
        }
        if(pickerView == expickerview){
            return exclude[row]
        }
        if(pickerView == calpickerview){
            return "\(cal[row])"
        }
        return ""
        
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if(pickerView == pickerview){
            dietField.text = diet[row]
            dietField.resignFirstResponder()
        }
        if(pickerView == expickerview){
            excludeField.text = exclude[row]
            excludeField.resignFirstResponder()
        }
        if(pickerView == calpickerview){
            calField.text = "\(cal[row])"
            calField.resignFirstResponder()
        }
        
    }
    
    

}
