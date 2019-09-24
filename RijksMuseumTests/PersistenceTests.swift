//
//  PersistenceTests.swift
//  RijksMuseumTests
//
//  Created by Adam Lovastyik on 13/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import XCTest
import CoreData

class PersistenceTests: XCTestCase {
    
    private var persistence: Persistence!
    
    private lazy var dateFormatter: DateFormatter = {
        
       let formatter = DateFormatter()
        formatter.dateFormat = Network.Configuration.longDateFormat
        return formatter
    }()
    
    override func setUp() {
        
        persistence = Persistence()
        XCTAssertNotNil(persistence)
        persistence.setupInMemoryPersistentStore()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMainContextNotNil() {
        
        XCTAssertNotNil(persistence)
        
        let context = persistence.managedObjectContext
        XCTAssertNotNil(context)
    }
    
    // MARK: - Database tests
    
    func testInsertAgenda() {
        
        let context = persistence.createNewManagedObjectContext()
        XCTAssertNotNil(context)
        
        var error: Error?
        context.performAndWait {
            do {
                
                let agenda = Agenda.new(in: context)
                agenda.identifier = UUID().uuidString
                try context.save()
            }
            catch let _error {
                error = _error
            }
        }
        
        XCTAssertNil(error, "Error saving Agenda")
    }
    
    func testFindAgenda() {
        
        let context = persistence.createNewManagedObjectContext()
        XCTAssertNotNil(context)
        
        let id = UUID().uuidString
        var error: Error?
        context.performAndWait {
            do {
                let agenda = Agenda.new(in: context)
                agenda.identifier = id
                try context.save()
                
                let _agenda = NSManagedObject.find(entity: Agenda.entityName, by: id, with: Agenda.identifier, in: context)
                XCTAssertNotNil(_agenda)
            }
            catch let _error {
                error = _error
            }
        }
        
        XCTAssertNil(error, "Error saving Agenda")
    }
    
    func testDeleteAgenda() {
        
        let context = persistence.createNewManagedObjectContext()
        XCTAssertNotNil(context)
        
        var error: Error?
        var deletedCount = 0
        context.performAndWait {
            do {
                
                let identifier = UUID().uuidString
                
                let agenda = Agenda.new(in: context)
                agenda.identifier = identifier
                try context.save()
                
                deletedCount = NSManagedObject.delete(entity: Agenda.entityName, identifier: identifier, with: Agenda.identifier, in: context)
                try context.save()
            }
            catch let _error {
                error = _error
            }
        }
        
        XCTAssertTrue(error == nil, "Error deleting Agenda")
        XCTAssertEqual(deletedCount, 1)
    }
    
    func testInsertArtobject() {
        
        let context = persistence.createNewManagedObjectContext()
        XCTAssertNotNil(context)
        
        var error: Error?
        context.performAndWait {
            do {
                
                let artObject = ArtObject.new(in: context)
                artObject.identifier = UUID().uuidString
                try context.save()
            }
            catch let _error {
                error = _error
            }
        }
        
        XCTAssertNil(error, "Error saving ArtObject")
    }
    
    func testFindArtobject() {
        
        let context = persistence.createNewManagedObjectContext()
        XCTAssertNotNil(context)
        
        let id = UUID().uuidString
        var error: Error?
        context.performAndWait {
            do {
                let artObject = ArtObject.new(in: context)
                artObject.identifier = id
                try context.save()
                
                let _artObject = NSManagedObject.find(entity: ArtObject.entityName, by: id, with: ArtObject.identifier, in: context)
                XCTAssertNotNil(_artObject)
            }
            catch let _error {
                error = _error
            }
        }
        
        XCTAssertNil(error, "Error saving ArtObject")
    }
    
    func testDeleteArtobject() {
        
        let context = persistence.createNewManagedObjectContext()
        XCTAssertNotNil(context)
        
        var error: Error?
        var deletedCount = 0
        context.performAndWait {
            do {
                
                let identifier = UUID().uuidString
                
                let artObject = ArtObject.new(in: context)
                artObject.identifier = identifier
                try context.save()
                
                deletedCount = NSManagedObject.delete(entity: ArtObject.entityName, identifier: identifier, with: ArtObject.identifier, in: context)
                try context.save()
            }
            catch let _error {
                error = _error
            }
        }
        
        XCTAssertTrue(error == nil, "Error deleting ArtObject")
        XCTAssertEqual(deletedCount, 1)
    }
    
    // MARK: - Data parsing
    
    func testParseAgenda() {

        let context = persistence.createNewManagedObjectContext()
        XCTAssertNotNil(context)

        let agenda = Agenda.new(in: context)
        XCTAssertNotNil(agenda)

        let json = JSONLoader().parse(jsonFile: "agendas")!
        XCTAssertNotNil(json)
        
        let agendas = json[Network.JSON.options] as! JSONArray
        XCTAssertNotNil(agendas)
        XCTAssertEqual(agendas.count, 1)
        
        let agendaJson = agendas.first!
        XCTAssertNotNil(agendaJson)

        agenda.update(with: agendaJson)
        
        XCTAssertEqual(agenda.identifier, "nl-f128f25b-a50f-e711-80cd-5820b1e20440-bd5eb8aa-ee4e-e911-80c7-5820b1e20440")
        XCTAssertEqual(agenda.lang, "nl")
        XCTAssertEqual(agenda.date, dateFormatter.date(from: "2019-07-12T22:00:00Z")! as NSDate)
        
        XCTAssertNotNil(agenda.links)
        XCTAssertEqual(agenda.links?.count, 2)
        
        XCTAssertNotNil(agenda.period)
        XCTAssertEqual(agenda.period?.identifier, "bd5eb8aa-ee4e-e911-80c7-5820b1e20440")
        XCTAssertEqual(agenda.period?.startDate, dateFormatter.date(from: "2019-07-13T10:00:00Z")! as NSDate)
        XCTAssertEqual(agenda.period?.endDate, dateFormatter.date(from: "2019-07-13T11:00:00Z")! as NSDate)
        XCTAssertEqual(agenda.period?.current, 12)
        XCTAssertEqual(agenda.period?.maximum, 15)
        XCTAssertEqual(agenda.period?.remaining, 3)
        XCTAssertNil(agenda.period?.code)
        XCTAssertEqual(agenda.period?.text, "12:00 - 13:00")
        
        XCTAssertNotNil(agenda.exposition)
        XCTAssertEqual(agenda.exposition?.identifier, "f128f25b-a50f-e711-80cd-5820b1e20440")
        XCTAssertEqual(agenda.exposition?.name, "Familierondleiding Hoogtepunten ")
        XCTAssertEqual(agenda.exposition?.expositionDescription, "Familierondleiding Hoogtepunten\r\n\r\nDe rondleiding start bij de Informatiebalie in het Atrium van het museum. U kunt zich voor aanvang van de rondleiding daar melden.\r\n\r\nMet deze reserveringsbevestiging hoeft u niet in de wachtrij buiten. \r\nHeeft u nog een ticket voor het museum nodig? Koop deze dan online of bij de kassa in het museum. Houd er wel rekening mee dat het bij de kassa en garderobe druk kan zijn.\r\n\r\nDeze rondleiding is specifiek bedoeld voor families mét kinderen van 6 tot 12 jaar.\r\n")
        XCTAssertEqual(agenda.exposition?.code, "E100026_2017")
        XCTAssertEqual(agenda.exposition?.controlType, 0)
        XCTAssertEqual(agenda.exposition?.maxVisitorsPerGroup, 0)
        XCTAssertEqual(agenda.exposition?.maxVisitorsPerPeriodWeb, 15)
        
        XCTAssertNotNil(agenda.exposition?.price)
        XCTAssertEqual(agenda.exposition?.price?.identifier, "f2bcee29-0bba-4aea-842b-bcff60b38eb5")
        XCTAssertEqual(agenda.exposition?.price?.calculationType, 2)
        XCTAssertEqual(agenda.exposition?.price?.amount, 5.0)
        
        XCTAssertNotNil(agenda.groupType)
        XCTAssertEqual(agenda.groupType?.type, "GroupTypeRef")
        XCTAssertEqual(agenda.groupType?.guid, "a66a5578-6d5b-41cb-a714-f1b90b5a172c")
        XCTAssertEqual(agenda.groupType?.friendlyName, "Families en Kinderen")
        
        XCTAssertEqual(agenda.pageRefTitle, "Familierondleiding Hoogtepunten")
        XCTAssertEqual(agenda.pageRefURL, "https://www.rijksmuseum.nl/nl/families-onderwijs-of-groepen/families-en-kinderen/familierondleidingen/familierondleiding-hoogtepunten")
     
        XCTAssertNotNil(agenda.expositionType)
        XCTAssertEqual(agenda.expositionType?.type, "ExpositionTypeRef")
        XCTAssertEqual(agenda.expositionType?.guid, "a268f42f-7ac7-49fb-a262-2b0a2ddf465c")
        XCTAssertEqual(agenda.expositionType?.friendlyName, "Rondleiding families & kinderen")
    }
    
    func testParseCollection() {
        
        let context = persistence.createNewManagedObjectContext()
        XCTAssertNotNil(context)
        
        let artObject = ArtObject.new(in: context)
        XCTAssertNotNil(artObject)
        
        let json = JSONLoader().parse(jsonFile: "artobjects")!
        XCTAssertNotNil(json)
        
        let artobjects = json[Network.JSON.artObjects] as! JSONArray
        XCTAssertNotNil(artobjects)
        XCTAssertEqual(artobjects.count, 1)
        
        let artobjectJson = artobjects.first!
        XCTAssertNotNil(artobjectJson)
        
        artObject.update(with: artobjectJson)
        
        XCTAssertEqual(artObject.identifier, "nl-SK-A-4691")
        XCTAssertEqual(artObject.objectNumber, "SK-A-4691")
        XCTAssertEqual(artObject.title, "Zelfportret")
        XCTAssertEqual(artObject.hasImage, true)
        XCTAssertEqual(artObject.principalOrFirstMaker, "Rembrandt van Rijn")
        XCTAssertEqual(artObject.longTitle, "Zelfportret, Rembrandt van Rijn, ca. 1628")
        XCTAssertEqual(artObject.showImage, true)
        XCTAssertEqual(artObject.permitDownload, true)
        XCTAssertEqual(artObject.webImageUrl, "https://lh3.googleusercontent.com/7qzT0pbclLB7y3fdS1GxzMnV7m3gD3gWnhlquhFaJSn6gNOvMmTUAX3wVlTzhMXIs8kM9IH8AsjHNVTs8em3XQI6uMY=s0")
        XCTAssertEqual(artObject.headerImagerUrl, "https://lh3.googleusercontent.com/WKIxue0nAIOYj00nGVoO4DTP9rU2na0qat5eoIuQTf6Fbp4mHHm-wbCes1Oo6K_6IdMl6Z_OCjGW_juCCf_jvQqaKw=s0")
        XCTAssertEqual(artObject.productionPlaces, "place1,place2")
        
        XCTAssertNotNil(artObject.links)
        XCTAssertEqual(artObject.links?.count, 2)
    }
}
