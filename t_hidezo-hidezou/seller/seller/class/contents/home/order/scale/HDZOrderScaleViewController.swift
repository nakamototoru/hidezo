//
//  HDZOrderScaleViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/25/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

protocol HDZOrderScaleViewControllerDelegate: NSObjectProtocol {
    func didSelectRow(numScale: String, row: Int)
}

class HDZOrderScaleViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    
    private var orderDetailItem: OrderDetailItem! = nil
    
    private lazy var numScale: [String] = []
    
    private weak var delegate: HDZOrderScaleViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let index: Int = self.numScale.indexOf(self.orderDetailItem.order_num) {
            self.pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HDZOrderScaleViewController {
    
    internal class func createViewController(viewController: HDZOrderDetailTableViewController, cell: HDZOrderDetailCell, orderDetailItem: OrderDetailItem) -> HDZOrderScaleViewController {
        
        let controller: HDZOrderScaleViewController = UIViewController.createViewController("HDZOrderScaleViewController")
        controller.orderDetailItem = orderDetailItem
        //controller.numScale = orderDetailItem.num_scale
        controller.delegate = cell
        
        let size: CGSize = UIScreen.mainScreen().bounds.size
        controller.preferredContentSize = CGSize(width: size.width, height: 216.0)
        controller.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        if let presentationController = controller.popoverPresentationController {
            presentationController.permittedArrowDirections = [UIPopoverArrowDirection.Up, UIPopoverArrowDirection.Down]
            presentationController.sourceView = cell.editButton
            presentationController.sourceRect = cell.editButton.bounds
            presentationController.delegate = viewController
            presentationController.backgroundColor = UIColor.lightGrayColor()
        }

        return controller
    }
}

// MARK: - UIPickerViewDelegate
extension HDZOrderScaleViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.numScale.count <= 0 {
            return
        }
        
        self.delegate?.didSelectRow(self.numScale[row], row: row)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.numScale[row] + (self.orderDetailItem.scale ?? "")
    }
}

// MARK: - UIPickerViewDataSource
extension HDZOrderScaleViewController: UIPickerViewDataSource  {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.numScale.count
    }
}

extension HDZOrderScaleViewController {
	
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
