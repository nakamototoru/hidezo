//
//  HDZOrderDateViewController.swift
//  seller
//
//  Created by NakaharaShun on 10/07/2016.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

protocol HDZOrderDateViewControllerDelegate: NSObjectProtocol {
    func didSelectedDate(dateString: String?)
}

class HDZOrderDateViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    
    private var orderDates: [String] = [
        "最短納品日",
        "月曜日",
        "火曜日",
        "水曜日",
        "木曜日",
        "金曜日",
        "土曜日",
        "日曜日",
    ]
    
    private weak var delegate: HDZOrderDateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HDZOrderDateViewController {
    
    internal class func createViewController(label: UIView!, delegate: HDZOrderDateViewControllerDelegate, presentDelegate: UIPopoverPresentationControllerDelegate) -> HDZOrderDateViewController {
        let controller: HDZOrderDateViewController = UIViewController.createViewController("HDZOrderDateViewController")
        
        controller.delegate = delegate
        
        let size: CGSize = UIScreen.mainScreen().bounds.size
        controller.preferredContentSize = CGSize(width: size.width, height: 216.0)
        controller.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        if let presentationController: UIPopoverPresentationController = controller.popoverPresentationController {
            presentationController.permittedArrowDirections = [UIPopoverArrowDirection.Up, UIPopoverArrowDirection.Down]
            presentationController.sourceView = label
            presentationController.sourceRect = label.bounds
            presentationController.delegate = presentDelegate
            presentationController.backgroundColor = UIColor.lightGrayColor()
        }
        
        return controller
    }
}

extension HDZOrderDateViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.didSelectedDate(self.orderDates[row])
    }
}

extension HDZOrderDateViewController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return orderDates.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.orderDates[row]
    }
}

extension HDZOrderDateViewController {
	
	@IBAction func didSelectedDoneWithButton(button: UIBarButtonItem) {
		//        self.dismiss(animated: true) {
		//            self.delegate?.didSelectedPlace(place: self.deliverToTextField.text)
		//        }
		//		self.dismissViewControllerAnimated(true) {
		//			self.delegate?.didSelectedPlace(self.deliverToTextField.text)
		//		}
	}
	
	@IBAction func didSelectedCloseWithButton(button: UIBarButtonItem) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}
