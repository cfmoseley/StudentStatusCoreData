//
//  VCStudentEdit.swift
//  StudentStatus
//
//  Created by Colin Moseley on 7/4/15.
//  Copyright © 2015 Colin Moseley. All rights reserved.
//

import UIKit

class VCStudentEdit: UIViewController {
    
    var student:Student!
    var vcSource:VCStudentList!

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var segStatus: UISegmentedControl!
    
    @IBAction func doSave(sender: UIButton) {
        print("VCStudentEdit.doSave")
        student.name = txtName.text!
        student.status = segStatus.selectedSegmentIndex
        let apd = UIApplication.sharedApplication().delegate as! AppDelegate
        apd.saveContext()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VCStudentEdit.viewDidLoad")

        // Do any additional setup after loading the view.
        txtName.text = student.name
        segStatus.selectedSegmentIndex = (student.status?.integerValue)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
