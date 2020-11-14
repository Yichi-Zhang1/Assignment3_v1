//
//  HomeViewController.swift
//  Assignment3
//
//  Created by admin on 2020/10/31.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, NetworkListener{
    func onRequest() {
        
    }
    
    func onResponse(response: AnyObject?, error: Error?) {
        print(response as! RecipeDetail)
    }
    
    var net: NetworkController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        net = NetworkController(listener: self)
        net?.getRecipeById(id: 716429)
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
