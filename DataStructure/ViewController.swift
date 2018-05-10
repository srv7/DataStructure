//
//  ViewController.swift
//  DataStructure
//
//  Created by liubo on 2018/5/2.
//  Copyright © 2018年 cloudist. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var linked = LinkedList([1, 2, 3])
        linked.remove(at: 0)
        print(linked)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

