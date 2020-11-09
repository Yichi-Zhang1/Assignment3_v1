//
//  RecipeResponseListener.swift
//  Assignment3
//
//  Created by Danny on 2020-11-03.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

protocol NetworkListener: AnyObject {
    
    func onRequest();
    
    func onResponse(response: AnyObject?, error: Error?);
}
