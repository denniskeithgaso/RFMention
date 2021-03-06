//
//  ViewController.swift
//  RFMentionDemo
//
//  Created by Rifat Firdaus on 3/26/18.
//  Copyright © 2018 Ripatto. All rights reserved.
//

import UIKit
import RFMention

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var constraintBottom: NSLayoutConstraint!
    
    var rfMention: RFTableMentionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        
        // insert random frame, because it does not used
        rfMention = RFTableMentionView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        
        var itemsArray: [RFMentionItem]  = [RFMentionItem]()
        
        let rifat = RFMentionItem(id: 1, text: "Rifat")
        let alam = RFMentionItem(id: 2, text: "Alam Muh")
        let bungkhus = RFMentionItem(id: 3, text: "Bungkhus")
        let dodi = RFMentionItem(id: 4, text: "Dodi Dar")
        let rifki = RFMentionItem(id: 5, text: "Rifki")
        let aldi = RFMentionItem(id: 6, text: "Aldi Fir")
        
        itemsArray.append(rifat)
        itemsArray.append(alam)
        itemsArray.append(bungkhus)
        itemsArray.append(dodi)
        itemsArray.append(rifki)
        itemsArray.append(aldi)
        
        rfMention?.setUpMentionTextView(parentController: self, textView: textView, itemList: itemsArray)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotif(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotif(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }


    @IBAction func buttonSubmitPressed(_ sender: Any) {
        var people = "\n"
        rfMention?.mentionedItems.forEach { item in
            people.append(contentsOf: item.text)
            people.append(contentsOf: "\n")
        }
        let alert = UIAlertController(title: "Tagged People", message: people, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func handleKeyboardNotif(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let isKeyboardShow = notification.name == Notification.Name.UIKeyboardWillShow
            
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            constraintBottom.constant = isKeyboardShow ? keyboardFrame.height : 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.tableView.scrollToRow(at: IndexPath(row: 54, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
            })
        }
    }
    
    
    @IBAction func buttonAccPressed(_ sender: Any) {
        let nav = TableSampleViewController.instantiate()
        nav.modalPresentationStyle = .popover
        nav.modalTransitionStyle = .crossDissolve
        nav.preferredContentSize = CGSize(width: 270, height: 150)
        present(nav, animated: true, completion: nil)
    }
    
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "theCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textView.endEditing(true)
        print("\(String(describing: rfMention?.mentionedItems))")
    }
    
}
