//
//  DetailViewController.swift
//  CLDebugger
//
//  Created by Taiju Aoki on 2016/09/25.
//  Copyright © 2016年 Taiju Aoki. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var detailDescription: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = detailDescription
    }

}
