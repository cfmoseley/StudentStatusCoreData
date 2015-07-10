//
//  VCStudentAdd.swift
//  StudentStatus
//
//  Created by Colin Moseley on 7/5/15.
//  Copyright © 2015 Colin Moseley. All rights reserved.
//

import UIKit
import CoreData

class VCStudentAdd: UIViewController {

    @IBOutlet weak var segStatus: UISegmentedControl!
    @IBOutlet weak var txtName: UITextField!
    
    @IBAction func doCancel(sender: UIBarButtonItem) {
        print("doCancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doSave(sender: UIBarButtonItem) {
        print("doSave")
        let apd = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = apd.managedObjectContext
        var tName = txtName.text
        if tName == "" {
            tName = "Unspecified name"
        }
        let entity = NSEntityDescription.entityForName("Student", inManagedObjectContext:moc)
        let student = Student(entity:entity!, insertIntoManagedObjectContext:moc)
        student.name = tName!
        student.status = segStatus.selectedSegmentIndex
        apd.saveContext()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        print ("VCStudentAdd.viewDidLoad")
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
