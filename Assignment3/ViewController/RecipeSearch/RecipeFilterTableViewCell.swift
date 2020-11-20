//
//  RecipeFilterTableViewCell.swift
//  Assignment3
//
//  Created by admin on 2020/11/19.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit



class RecipeFilterTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var dietField: UITextField!
    @IBOutlet weak var minuteField: UITextField!
    
    let diet = ["nil","Gluten Free","Ketogenic","Vegetarian","Lacto-Vegetarian","Ovo-Vegetarian","Vegan"]
    let type = ["nil","main course","side dish","dessert","appetizer","breakfast","snack"]
    let minute = [10,20,30,40,50,60,80]
    
    var dietpickerview = UIPickerView()
    var typepickerview = UIPickerView()
    var minutepickerview = UIPickerView()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        dietpickerview.delegate = self
        dietpickerview.dataSource = self
        dietField.inputView = dietpickerview
        dietField.textAlignment = .center
        dietField.attributedPlaceholder = NSAttributedString(string: "Diet", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        typepickerview.delegate = self
        typepickerview.dataSource = self
        typeField.inputView = typepickerview
        typeField.textAlignment = .center
        typeField.attributedPlaceholder = NSAttributedString(string: "Type", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])

        minutepickerview.delegate = self
        minutepickerview.dataSource = self
        minuteField.inputView = minutepickerview
        minuteField.textAlignment = .center
        minuteField.attributedPlaceholder = NSAttributedString(string: "Max minutes", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        // Configure the view for the selected state
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == dietpickerview){
            return diet.count
        }
        if(pickerView == typepickerview){
            return type.count
        }
        if(pickerView == minutepickerview){
            return minute.count
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       if(pickerView == dietpickerview){
           return diet[row]
       }
       if(pickerView == typepickerview){
           return type[row]
       }
       if(pickerView == minutepickerview){
           return "\(minute[row])"
       }
       return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == dietpickerview){
            dietField.text = diet[row]
            dietField.resignFirstResponder()
        }
        if(pickerView == typepickerview){
            typeField.text = type[row]
            typeField.resignFirstResponder()
        }
        if(pickerView == minutepickerview){
            minuteField.text = "\(minute[row])"
            minuteField.resignFirstResponder()
        }
        
            
        
    }

}
