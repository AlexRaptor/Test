//
//  PageViewController.swift
//  Test
//
//  Created by Alexander Selivanov on 28/01/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    var color: UIColor?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = color
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
