//
//  ViewController.swift
//  DatePicker
//
//  Created by Maher on 12/3/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var dateview: DateViewPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.dateview.delegate = self
        self.lbl.alpha = 0
    }


}


extension ViewController : DateShare {
    func share(date: String) {
        self.lbl.alpha = 1
        self.lbl.text = date
    }
    
    
}
