//
//  NetworkTests.swift
//  RijksMuseumTests
//
//  Created by Adam Lovastyik on 13/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import XCTest

class NetworkTests: XCTestCase {

    private var session: MockNetworkURLSession!
    
    override func setUp() {
        
        session = MockNetworkURLSession()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Agendas
    
    func testFetchAgendasInsertSuccess() {

        let mockPersistence = MockPersistence(expectedInserts: ["nl-f128f25b-a50f-e711-80cd-5820b1e20440-bd5eb8aa-ee4e-e911-80c7-5820b1e20440"])
        let mockActivty = MockNetworkActivity()

        let network = Network()
        network.session = session
        network.persistence = mockPersistence
        network.activityDelegate = mockActivty
        
        network.fetchAgendas(date: Date(), isQueueable: false) {(inserted, updated, error) in

            XCTAssertEqual(inserted, 1)
            XCTAssertEqual(updated, 0)
            XCTAssertTrue(error == nil)
        }
    }
    
    func testFetchAgendasUpdateSuccess() {
        
        let mockPersistence = MockPersistence(expectedUpdates: ["nl-f128f25b-a50f-e711-80cd-5820b1e20440-bd5eb8aa-ee4e-e911-80c7-5820b1e20440"])
        let mockActivty = MockNetworkActivity()
        
        let network = Network()
        network.session = session
        network.persistence = mockPersistence
        network.activityDelegate = mockActivty
        
        network.fetchAgendas(date: Date(), isQueueable: false) {(inserted, updated, error) in
            
            XCTAssertEqual(inserted, 0)
            XCTAssertEqual(updated, 1)
            XCTAssertTrue(error == nil)
        }
    }
    
    func testFetchAgendasInsertFail() {
        
        let mockPersistence = MockPersistence(expectedInserts: ["wrong_id"])
        let mockActivty = MockNetworkActivity()
        
        let network = Network()
        network.session = session
        network.persistence = mockPersistence
        network.activityDelegate = mockActivty
        
        network.fetchAgendas(date: Date(), isQueueable: false) {(inserted, updated, error) in
            
            XCTAssertEqual(inserted, 0)
            XCTAssertEqual(updated, 0)
            XCTAssertTrue(error == nil)
        }
    }
    
    func testFetchAgendasUpdateFail() {
        
        let mockPersistence = MockPersistence(expectedUpdates: ["wrong_id"])
        let mockActivty = MockNetworkActivity()
        
        let network = Network()
        network.session = session
        network.persistence = mockPersistence
        network.activityDelegate = mockActivty
        
        network.fetchAgendas(date: Date(), isQueueable: false) {(inserted, updated, error) in
            
            XCTAssertEqual(inserted, 0)
            XCTAssertEqual(updated, 0)
            XCTAssertTrue(error == nil)
        }
    }

    // MARK: - Collections
    
    func testFetchCollectionInsertSuccess() {
        
        let mockPersistence = MockPersistence(expectedInserts: ["nl-SK-A-4691"])
        let mockActivty = MockNetworkActivity()
        
        let network = Network()
        network.session = session
        network.persistence = mockPersistence
        network.activityDelegate = mockActivty
        
        network.fetchArtObjects(isQueueable: false) {(inserted, updated, error) in
            
            XCTAssertEqual(inserted, 1)
            XCTAssertEqual(updated, 0)
            XCTAssertTrue(error == nil)
        }
    }
    
    func testFetchCollectionUpdateSuccess() {
        
        let mockPersistence = MockPersistence(expectedUpdates: ["nl-SK-A-4691"])
        let mockActivty = MockNetworkActivity()
        
        let network = Network()
        network.session = session
        network.persistence = mockPersistence
        network.activityDelegate = mockActivty
        
        network.fetchArtObjects(isQueueable: false) {(inserted, updated, error) in
            
            XCTAssertEqual(inserted, 0)
            XCTAssertEqual(updated, 1)
            XCTAssertTrue(error == nil)
        }
    }
    
    func testFetchCollectionInsertFail() {
        
        let mockPersistence = MockPersistence(expectedInserts: ["wrong_id"])
        let mockActivty = MockNetworkActivity()
        
        let network = Network()
        network.session = session
        network.persistence = mockPersistence
        network.activityDelegate = mockActivty
        
        network.fetchArtObjects(isQueueable: false) {(inserted, updated, error) in
            
            XCTAssertEqual(inserted, 0)
            XCTAssertEqual(updated, 0)
            XCTAssertTrue(error == nil)
        }
    }
    
    func testFetchCollectionUpdateFail() {
        
        let mockPersistence = MockPersistence(expectedUpdates: ["wrong_id"])
        let mockActivty = MockNetworkActivity()
        
        let network = Network()
        network.session = session
        network.persistence = mockPersistence
        network.activityDelegate = mockActivty
        
        network.fetchArtObjects(isQueueable: false) {(inserted, updated, error) in
            
            XCTAssertEqual(inserted, 0)
            XCTAssertEqual(updated, 0)
            XCTAssertTrue(error == nil)
        }
    }
    
    // MARK: - Queuing
    
    func testFetchAgendasNotQueuableNoNetworkFailure() {
        
        let mockPersistence = MockPersistence()
        let mockActivty = MockNetworkActivity()
        
        let network = Network()
        network.session = session
        network.persistence = mockPersistence
        network.activityDelegate = mockActivty
        
        session.isServerReachable = false
        
        network.fetchArtObjects(isQueueable: false) {(inserted, updated, error) in
            
            XCTAssertEqual(inserted, 0)
            XCTAssertEqual(updated, 0)
            XCTAssertNotNil(error)
        }
    }
    
    func testFetchCollectionsNotQueuableNoNetworkFailure() {
        
        let mockPersistence = MockPersistence()
        let mockActivty = MockNetworkActivity()
        
        let network = Network()
        network.session = session
        network.persistence = mockPersistence
        network.activityDelegate = mockActivty
        
        session.isServerReachable = false
        
        network.fetchArtObjects(isQueueable: false) {(inserted, updated, error) in
            
            XCTAssertEqual(inserted, 0)
            XCTAssertEqual(updated, 0)
            XCTAssertNotNil(error)
        }
    }
    
    func testFetchAgendasQueued() {
        
        let mockPersistence = MockPersistence(expectedInserts: ["nl-f128f25b-a50f-e711-80cd-5820b1e20440-bd5eb8aa-ee4e-e911-80c7-5820b1e20440"])
        let mockActivty = MockNetworkActivity()
        
        let network = Network()
        network.session = session
        network.persistence = mockPersistence
        network.activityDelegate = mockActivty
        
        session.isServerReachable = false
        
        var _inserted = -999
        var _updated = -888
        var _error: Error?
        
        let expectation = self.expectation(description: "Agendas")
        
        network.fetchAgendas(date: Date(), isQueueable: true) {(inserted, updated, error) in
            
            _inserted = inserted
            _updated = updated
            _error = error
            
            expectation.fulfill()
        }
        
        XCTAssertEqual(_inserted, -999)
        XCTAssertEqual(_updated, -888)
        XCTAssertNil(_error)
        
        let queuedBefore = NetworkOperationQueue.shared.isOperationQueued(kind: Network.QueueKind.fetchAgendas)
        XCTAssertTrue(queuedBefore)
        
        session.isServerReachable = true
        
        self.waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(_inserted, 1)
        XCTAssertEqual(_updated, 0)
        XCTAssertNil(_error)
        
        let queuedAfter = NetworkOperationQueue.shared.isOperationQueued(kind: Network.QueueKind.fetchAgendas)
        XCTAssertFalse(queuedAfter)
    }
    
    func testFetchCollectionsQueued() {
        
        let mockPersistence = MockPersistence(expectedInserts: ["nl-SK-A-4691"])
        let mockActivty = MockNetworkActivity()
        
        let network = Network()
        network.session = session
        network.persistence = mockPersistence
        network.activityDelegate = mockActivty
        
        session.isServerReachable = false
        
        var _inserted = -999
        var _updated = -888
        var _error: Error?
        
        let expectation = self.expectation(description: "Collections")
        
        network.fetchArtObjects(isQueueable: true) {(inserted, updated, error) in
            
            _inserted = inserted
            _updated = updated
            _error = error
            
            expectation.fulfill()
        }
        
        XCTAssertEqual(_inserted, -999)
        XCTAssertEqual(_updated, -888)
        XCTAssertNil(_error)
        
        let queuedBefore = NetworkOperationQueue.shared.isOperationQueued(kind: Network.QueueKind.fetchCollections)
        XCTAssertTrue(queuedBefore)
        
        session.isServerReachable = true
        
        self.waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(_inserted, 1)
        XCTAssertEqual(_updated, 0)
        XCTAssertNil(_error)
        
        let queuedAfter = NetworkOperationQueue.shared.isOperationQueued(kind: Network.QueueKind.fetchCollections)
        XCTAssertFalse(queuedAfter)
    }
}
