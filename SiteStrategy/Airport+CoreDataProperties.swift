//
//  Airport+CoreDataProperties.swift
//  SiteStrategy
//
//  Created by Irl D Jones on 10/1/16.
//  Copyright © 2016 inSkyLE. All rights reserved.
//

import Foundation
import CoreData


extension Airport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Airport> {
        return NSFetchRequest<Airport>(entityName: "Airport");
    }

    @NSManaged public var airportCity: String?
    @NSManaged public var airportCityAbbreviation: String?
    @NSManaged public var airportState: String?

}
