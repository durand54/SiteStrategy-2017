//
//  MasterViewController.swift
//  SiteStrategy
//
//  Created by Irl D Jones on 9/30/16.
//  Copyright © 2016 inSkyLE. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var cityTVC: CityTVC? = nil
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var cityNames = [String]()
    var cityCode = [String]()
    var cityState = [String]()
    var states = [String]()
    var statesAbbreviation = [String]()
    var fetchedStates: States? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem

        //let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        let path = Bundle.main.path(forResource: "AirportCities", ofType:"plist")
        let dict = NSDictionary(contentsOfFile:path!)
        
        cityNames = dict?["airportCity"] as! Array<String>
        cityCode = dict?["airportCityAbbreviation"] as! Array<String>
        cityState = dict?["airportState"] as! Array<String>
        
        /*let dic = [
            "airportCity" : cityNames,
            "airportCityAbbreviation" : cityCode,
            "airportState" : cityState
        ]
        for (type,types) in dic {
            print("type: \(type)")
            for t in types {
                print("item for type: \(t)\n")
            }
        }*/

        let context = self.fetchedResultsController.managedObjectContext
        let request: NSFetchRequest<Airport> = Airport.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", "airportCity", "Boise")
        request.predicate = predicate
        
        let sortDescriptor1 = NSSortDescriptor(key: "airportCity", ascending: true)
        request.sortDescriptors = [sortDescriptor1]
        
        
        let count = try! context.count(for: request)
        
        if(count == 0){
            print(count)
            let count = cityNames.count
            for i in 0..<count{
                print("city name: \(cityNames[i])\n")
                let airport = NSEntityDescription.entity(forEntityName: "Airport", in: context)
                let airportObject = Airport(entity:airport!, insertInto: context)
                airportObject.airportCity = cityNames[i]
                airportObject.airportCityAbbreviation = cityCode[i]
                airportObject.airportState = cityState[i]
                
                do {
                    try context.save()
                    print("saved!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                } catch {
                    
                }
                
            }
            
            
        } else {
            print("here is the count \(count)")
        }
        
        let path2 = Bundle.main.path(forResource: "States", ofType:"plist")
        let dict2 = NSDictionary(contentsOfFile:path2!)
        
        states = dict2?["states"] as! Array<String>
        statesAbbreviation = dict2?["statesAbbreviation"] as! Array<String>
        
        let request2: NSFetchRequest<States> = States.fetchRequest()
        let predicate2 = NSPredicate(format: "%K == %@", "states", "Idaho")
        request2.predicate = predicate2
        
        let sortDescriptor2 = NSSortDescriptor(key: "states", ascending: true)
        request2.sortDescriptors = [sortDescriptor2]
        
        
        let count2 = try! context.count(for: request2)
        print("here is the count \(count2)")
        if(count2 == 0){
            let counter = states.count
            for i in 0..<counter{
                let state = NSEntityDescription.entity(forEntityName: "States", in: context)
                let stateObject = States(entity:state!, insertInto: context)
                stateObject.states = states[i]
                stateObject.statesAbbreviation = statesAbbreviation[i]
                do {
                    try context.save()
                    print("saved!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                } catch {
                    
                }
                
            }
            
            
        } else {
            print("here is the count \(count2)")
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        let context = self.fetchedResultsController.managedObjectContext
        let newEvent = Event(context: context)
             
        // If appropriate, configure the new managed object.
        newEvent.timestamp = NSDate()

        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCities" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let state = self.fetchedResultsController.object(at: indexPath)
                if let destinationVC = segue.destination as? CityTVC {
                    destinationVC.state = state
                    destinationVC.managedObjectContext = self.managedObjectContext
                }
               /* let controller = (segue.destination as! UINavigationController).topViewController as! CityTVC
                controller.state = state.states!
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
           let object = self.fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            */
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let state = self.fetchedResultsController.object(at: indexPath)
        self.configureCell(cell, withState: state)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    

    func configureCell(_ cell: UITableViewCell, withState state: States) {
        cell.textLabel!.text = state.states
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<States> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController! 
        }
        
        let fetchRequest: NSFetchRequest<States> = States.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "states", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<States>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                self.configureCell(tableView.cellForRow(at: indexPath!)!, withState: anObject as! States)
            case .move:
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

}

