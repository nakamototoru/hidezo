//
//  HDZOrderToViewController.swift
//  seller
//
//  Created by NakaharaShun on 7/3/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

protocol HDZOrderToViewControllerDeegate: NSObjectProtocol {
    func didSelectedPlace(place: String?)
}

class HDZOrderToViewController: UIViewController {

    @IBOutlet weak var deliverToPickerView: UIPickerView!
    
    @IBOutlet weak var deliverToTextField: UITextField!
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    private lazy var deliverToList: [String] = []
    private var defaultPlace: String?
    
    private weak var delegate: HDZOrderToViewControllerDeegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HDZOrderToViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HDZOrderToViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
		
        self.deliverToTextField.text = self.defaultPlace

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

extension HDZOrderToViewController {
    
    internal class func createViewController(defaultPlace: String?, deliverToList: [String], delegate: HDZOrderToViewControllerDeegate) -> HDZOrderToViewController {
        let controller: HDZOrderToViewController = UIViewController.createViewController("HDZOrderToViewController")
        controller.deliverToList = deliverToList
        controller.delegate = delegate
        controller.defaultPlace = defaultPlace
        return controller
    }
}

extension HDZOrderToViewController {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension HDZOrderToViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.deliverToList.count <= 0 {
            return
        }
        
        self.deliverToTextField.text = self.deliverToList[row]
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.deliverToList[row]
    }
}

extension HDZOrderToViewController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView( pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.deliverToList.count
    }
}

extension HDZOrderToViewController {
    
    @IBAction func didSelectedDoneWithButton(button: UIBarButtonItem) {
//        self.dismiss(animated: true) {
//            self.delegate?.didSelectedPlace(place: self.deliverToTextField.text)
//        }
		self.dismissViewControllerAnimated(true) {
			self.delegate?.didSelectedPlace(self.deliverToTextField.text)
		}
    }
    
    @IBAction func didSelectedCloseWithButton(button: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension HDZOrderToViewController {
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            //let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue()
			let frame_new = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
			
            bottomLayoutConstraint.constant = UIScreen.mainScreen().bounds.height - frame_new.origin.y
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        bottomLayoutConstraint.constant = 0
    }
}

