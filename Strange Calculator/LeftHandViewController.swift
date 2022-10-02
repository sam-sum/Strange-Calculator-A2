//
//  MAPD714 F22
//  Assignment 2
//  Group 8
//  Member: Suen, Chun Fung (Alan) 301277969
//          Sum, Chi Hung (Samuel) 300858503
//          Wong, Po Lam (Lizolet) 301258847
//  Date:   Oct 9, 2022
//
//  ViewController.swift
//  Strange Calculator - A simple calculator with a strange key layout
//  Version 0.3
//

import UIKit

class LeftHandViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnDown(_ sender: UIButton) {
        sender.backgroundColor = UIColor.white
    }

    @IBAction func btnUpOutside(_ sender: UIButton) {
        sender.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnNumbersUpInside(_ sender: UIButton) {
        sender.backgroundColor = UIColor.clear
        let button = sender as UIButton
        resultLabel.text = button.titleLabel!.text
    }
    
    @IBAction func btnOperatorsUpInside(_ sender: UIButton) {
        sender.backgroundColor = UIColor.clear
        let button = sender as UIButton
        resultLabel.text = button.titleLabel!.text
    }
    
    @IBAction func btnSpecialUpInside(_ sender: UIButton) {
        sender.backgroundColor = UIColor.clear
        let button = sender as UIButton
        if button.tag == 1000 {
            //AC button
            resultLabel.text = "0"
        } else {
            //Back button
        }
    }
}
