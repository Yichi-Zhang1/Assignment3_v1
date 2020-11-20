//
//  RecipeDetailViewController.swift
//  Assignment3
//
//  Created by admin on 2020/11/15.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("\(recipe?.calories ?? "no result")")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        detailImage.image = recipe?.image as! UIImage as UIImage
        titleLabel.text = recipe?.name
        nameLabel.text = recipe?.title
        timeLabel.text = "\(recipe?.readyInMinutes ?? 0) mintues"
        servingLabel.text = "\(recipe?.servings ?? 0) people"
        priceLabel.text = "\(String(format: "%.2f", Float(recipe!.pricePerServing)/10))$"
        
        //proteinLabel.text = "  * \(recipe?.protein ?? " ")"
        let proteinarr = ["\(recipe?.protein ?? " ")"]
        let fatarr = ["\(recipe?.fat ?? " ")"]
        let cararr = ["\(recipe?.protein ?? " ")"]
        proteinLabel.attributedText = addBullet(stringList: proteinarr, font: proteinLabel.font,bullet: "   •")
        fatLabel.attributedText = addBullet(stringList: fatarr, font: fatLabel.font,bullet: "   •")
        carLabel.attributedText = addBullet(stringList: cararr, font: carLabel.font,bullet: "   •")
        
        ingredientLabel.attributedText = addBullet(stringList: (recipe?.ingredents)!, font: ingredientLabel.font, bullet: "   •")
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //add bullet point for a string array
    //source from : https://stackoverflow.com/questions/5533851/format-uilabel-with-bullet-points
    func addBullet(stringList: [String],
             font: UIFont,
             bullet: String = "\u{2022}",
             indentation: CGFloat = 20,
             lineSpacing: CGFloat = 2,
             paragraphSpacing: CGFloat = 12,
             textColor: UIColor = .gray,
             bulletColor: UIColor = .orange) -> NSAttributedString {

        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]

        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        //paragraphStyle.firstLineHeadIndent = 0
        //paragraphStyle.headIndent = 20
        //paragraphStyle.tailIndent = 1
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation

        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)

            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))

            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))

            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }

        return bulletList
    }

}
