//
//  VCStudentList.swift
//  StudentStatus
//
//  Created by Colin Moseley on 7/3/15.
//  Copyright © 2015 Colin Moseley. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class VCStudentList: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var currentHeadings:[String] = []

    @IBAction func doDelete(sender: UIBarButtonItem) {
        print("Will enter editing mode.")
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    
    //var students:[Student] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
 
    override func viewWillAppear(animated: Bool) {
        //print("VCStudentList.viewWillAppear")
        setHeadings()
        tableView.reloadData()
        //print("VCStudentList.Did reloadData")
    }
    
    func setHeadings() {
        //print("VCStudentList.setupHeadings")
        let students: [Student] = fetchedResultsController.fetchedObjects! as! [Student]
        //Assumes students are ordered by status desc
        var lastStatus: NSNumber = 99
        currentHeadings = []
        for s: Student in students {
            if s.status != lastStatus {
                lastStatus = s.status!
                let h:String = Student.statusName(lastStatus.integerValue)
                //print("   Will need section heading '\(h)'")
                currentHeadings.append(h)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("VCStudentList:prepareForSegue \(segue.identifier)")
        if segue.identifier == "StudentEdit" {
            let dest = segue.destinationViewController as! VCStudentEdit
            let ip: NSIndexPath = self.tableView.indexPathForSelectedRow!
//            let stud: Student =
            dest.student = self.fetchedResultsController.objectAtIndexPath(ip) as! Student
        } else {        // segue is studentAdd
            //let dest = segue.destinationViewController as! VCStudentAdd
        }
    }
    
//MARK: TableVIewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("VCStudentList.cellForRowAtIndexPath - \(indexPath.section), \(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as UITableViewCell
        let student = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Student
        //The two llabel variables are supplied automatically in the definition of UITableViewCell
        cell.textLabel?.text = student.name
        //cell.detailTextLabel?.text = "status"
        cell.detailTextLabel?.text = Student.statusName(student.status!.integerValue)
        // If the table view is too wide the accessory will appear off screen
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //print("VCStudentList.numberOfSectionsInTableView")
        let sections = self.fetchedResultsController.sections?.count ?? 0
        return sections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("VCStudentList.numberOfRowsInSection")
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
/*  // This function is not called if viewForHeaderInSection is implemented
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //print("VCStudentList.titleForHeaderInSection \(section)")
        var s: String = ""
        if section > currentHeadings.count {
            s = "Extra Heading #\(section)"
        } else {
            s = currentHeadings[section]
        }
        return s
    }
*/
   func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title: UILabel = UILabel()
        
        //let sectionInfo = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        title.text = "  " + currentHeadings[section].uppercaseString //must import Foundation
        title.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.9)
        title.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.05)
        title.font = UIFont.boldSystemFontOfSize(20)
    
        return title
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    //Enable editing and delete capability
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
//MARK: TableViewDelegate
/*    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Clicked cell \(indexPath.row) in section \(indexPath.section)")
        
       performSegueWithIdentifier("StudentEdit", sender: self)
    }
*/
//MARK: Core Data Fetch
    //Note that this is a computed read-only property - can't be changed
    var fetchedResultsController: NSFetchedResultsController {
        //print("ListViewController:fetchedResultsController")
        return fetchAllStudents()
    }
    
    func fetchAllStudents() -> NSFetchedResultsController {
        //print("VCStudentList.fetchAllStudents")
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
/*        if frc! != nil {
            return frc!
        }
*/
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Student", inManagedObjectContext: moc)
        fetchRequest.entity = entity
        
        fetchRequest.fetchBatchSize = 50
        
        let sortDescriptor2 = NSSortDescriptor(key: "status", ascending: false)
        let sortDescriptor1 = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor2, sortDescriptor1]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "status", cacheName: nil)
        frc.delegate = self
        let _frc = frc
        //print("VCStudentList.fetchAllStudents.NSFetchedResultsController has been defined.")
        
        //Perform fetch
        do {
            try _frc.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        //print("VCStudentList.fetchAllStudents ----- finished.")
        return _frc
    }

    //MARK: Editing and deletion
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(true, animated: true)
        tableView.setEditing(editing, animated:true)
        if (editing) {
            btnAdd.enabled = true
        } else {
            btnAdd.enabled = false
        }
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

