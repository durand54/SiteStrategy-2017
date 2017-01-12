//
//  States+CoreDataProperties.swift
//  SiteStrategy
//
//  Created by Irl D Jones on 10/2/16.
//  Copyright © 2016 inSkyLE. All rights reserved.
//

import Foundation
import CoreData


extension States {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<States> {
        return NSFetchRequest<States>(entityName: "States");
    }

    @NSManaged public var states: String?
    @NSManaged public var statesAbbreviation: String?

}
