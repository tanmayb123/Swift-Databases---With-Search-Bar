//
//  ViewController.swift
//  DatabaseTest
//
//  Created by Tanmay Bakshi on 2014-09-02.
//  Copyright (c) 2014 TBSS. All rights reserved.
//

import UIKit

extension String {
    
    func findInString(stringToFind: String) -> Bool {
        if self != "" {
            if (self as NSString).containsString(stringToFind.lowercaseString) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}

var onAdd = false

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var inputFriendName: UITextField!
    @IBOutlet var inputFriendInfo: UITextField!
    @IBOutlet var textFieldSearch: UITextField!
    
    var dataSecond: NSMutableArray = []
    var search = false
    var data: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = dataOfJson("YOURLINK_RECIEVE")
        print(data)
        if onAdd {
            onAdd = false
        } else {
            onAdd = true
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dataSecond = []
        if textField.text == "" {
            search = false
            self.reload()
        } else {
            for i in data {
                if (i["Name"] as! String!).lowercaseString.findInString(textField.text!) {
                    dataSecond.addObject(i)
                }
            }
            search = true
            self.reload()
        }
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if onAdd {
            textField.text = (NSString(string: textField.text!)).stringByReplacingOccurrencesOfString(" ", withString: "")
            textField.text = (NSString(string: textField.text!)).stringByReplacingOccurrencesOfString("\n", withString: "")
        }
    }
    
    @IBAction func reload() {
        data = dataOfJson("YOURLINK_RECIEVE")
        self.tableview.reloadData()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        inputFriendName.text = (NSString(string: inputFriendName.text!)).stringByReplacingOccurrencesOfString(" ", withString: "")
        inputFriendName.text = (NSString(string: inputFriendName.text!)).stringByReplacingOccurrencesOfString("\n", withString: "")
        inputFriendInfo.text = (NSString(string: inputFriendInfo.text!)).stringByReplacingOccurrencesOfString(" ", withString: "")
        inputFriendInfo.text = (NSString(string: inputFriendInfo.text!)).stringByReplacingOccurrencesOfString("\n", withString: "")
        self.view.endEditing(true)
    }
    
    func dataOfJson(url: String) -> NSMutableArray {
        
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        do {
            return (try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSMutableArray)
        } catch {
            return []
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search {
            return dataSecond.count
        } else {
            return data.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var maindata: NSDictionary!
        if search {
            if dataSecond != [] {
                maindata = (dataSecond[indexPath.row] as! NSDictionary)
            }
        } else {
            maindata = (data[indexPath.row] as! NSDictionary)
        }
        let cell: additionInfoCell = self.tableview.dequeueReusableCellWithIdentifier("customCell") as! additionInfoCell
        if let _ = maindata["Name"] {
            cell.friendName!.text = (maindata["Name"] as! String)
            cell.friendInfo!.text = (maindata["Additional Info"] as! String)
        }
        return cell
    }
    
    @IBAction func uploadToDatabase() {
        var url: NSString = "YOURLINK_UPLOAD"
        url = url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        url = url.stringByReplacingOccurrencesOfString("/n", withString: "%0A")
        let data = NSData(contentsOfURL: NSURL(string: url as String)!)
        _ = NSString(data: data!, encoding: NSUTF8StringEncoding)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
