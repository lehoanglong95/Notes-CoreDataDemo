//
//  CategoryViewController.swift
//  Notes
//
//  Created by LongLH on 12/15/17.
//  Copyright © 2017 LongLH. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryNameTextField: UITextField!
    
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        guard let category = category else { return }
        categoryNameTextField.text = category.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let name = categoryNameTextField.text, !name.isEmpty else { return }
        category?.name = name
    }

    @IBAction func pickColor(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let colorVc = storyBoard.instantiateViewController(withIdentifier: "ColorViewController") as! ColorViewController
        colorVc.delegate = self
        colorVc.color = category?.color ?? . white
        navigationController?.pushViewController(colorVc, animated: true)
    }
}

extension CategoryViewController: ColorViewControllerDelegate {
    func controller(_ controller: ColorViewController, didPick color: UIColor) {
        category?.color = color
    }
}
