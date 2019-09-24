//
//  Network.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 10/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

typealias JSONObject = [String: Any]
typealias JSONArray = [JSONObject]

typealias FetchCompletion = ((_ inserted: Int, _ updated: Int, _ error: Error?) -> ())
typealias OperationCompletion = ((_ success: Bool, _ error: Error?) -> ())

/*!
 * @brief Singleton class to help with network operations
 */
class Network : NSObject, URLSessionDelegate {

    /// Shared instance
    static let shared = Network()
    
    /// Network session that can be either mock or NSURLSession
    var session: NetworkSessionProtocol?
    
    /// Delegate to display or hide network activity indicator. Can be either mock or real (UIApplicationDelegate)
    var activityDelegate: NetworkActivityProtocol?
    
    /// Delegate to handle persistence. Cen be either in-memory or Core Data
    var persistence: PersistenceProtocol?
    
    struct Configuration {
        
        static let hostName = "www.rijksmuseum.nl"
        
        static let baseURL = URL(string: "https://\(hostName)/api/nl")!
        
        static let pAPIkey = "key"
        static let apiKey = "yW6uq3BV"
        
        static let pFormat = "format"
        static let json = "json"
        
        static let agenda = "agenda"
        static let collecton = "collection"
        
        static let pQuery = "q"
        static let pPage = "p"
        static let pPageSize = "ps"
        static let pCulture = "culture"
        
        static let shortDateFormat = "yyyy-MM-dd"
        static let longDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    struct JSON {
        
        static let options = "options"
        static let artObjects = "artObjects"
    }
    
    struct QueueKind {
        
        static let fetchAgendas = "FetchAgendas"
        static let fetchCollections = "FetchCollections"
    }
    
    typealias ErrorData = (code: Int, message: String)
    struct Errors {
        
        static let domain = "API"
        
        static let emptyData: ErrorData = (code: -1111, message: NSLocalizedString("Empty data received", comment: "Error message when empty data received from the api"))
        static let sessionNotConfigured: ErrorData = (code: -2222, message: NSLocalizedString("Session not configured", comment: "Error message when session not configured"))
        static let persistenceNotConfigured: ErrorData = (code: -3333, message: NSLocalizedString("Persistence not configured", comment: "Error message when persistencer layer not configured"))
        static let serverNotRerachable: ErrorData = (code: -4444, message: NSLocalizedString("Server not reachable", comment: "Error message when server not reachable"))
    }
    
    // MARK: - Public functions
    
    /*!
     * @brief Fetches Agenda items from API
     *
     * @param date Selected date
     * @param isQueueable True if call can be queued if no network connection, otherwise completes with error
     * @param completion Completion handler block
     */
    func fetchAgendas(date: Date, isQueueable: Bool = false, completion: FetchCompletion?) {
        
        guard let _session = session else {
            completion?(0, 0, NSError(domain: Errors.domain, code: Errors.sessionNotConfigured.code, userInfo: [NSLocalizedDescriptionKey: Errors.sessionNotConfigured.message]))
            return
        }

        guard let _persistence = persistence else {
            completion?(0, 0, NSError(domain: Errors.domain, code: Errors.persistenceNotConfigured.code, userInfo: [NSLocalizedDescriptionKey: Errors.persistenceNotConfigured.message]))
            return
        }
        
        guard _session.isServerReachable else {
            
            if isQueueable && !NetworkOperationQueue.shared.isOperationQueued(kind: QueueKind.fetchAgendas) {
                NetworkOperationQueue.shared.queueOperation(kind: QueueKind.fetchAgendas) {
                    self.fetchAgendas(date: date, isQueueable: false, completion: completion)
                }
            }
            else {
                completion?(0, 0, NSError(domain: Errors.domain, code: Errors.serverNotRerachable.code, userInfo: [NSLocalizedDescriptionKey: Errors.serverNotRerachable.message]))
            }
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Configuration.shortDateFormat
        
        var url = Configuration.baseURL.appendingPathComponent(Configuration.agenda).appendingPathComponent(dateFormatter.string(from: date))
        addKeyAndFormat(to: &url)

        var request = URLRequest(url: url)
        request.configure(method: .get)
        
        self.activityDelegate?.showNetworkActivityIndicator()
        
        _session.startDataTask(with: request) { (data, response, error) in

            var inserted = 0
            var updated = 0
            var _error: Error? = error

            if let _data = data, !_data.isEmpty {
                
                let jsonString = String(data: _data, encoding: .utf8)
                print("*** RECEIVED from \(request.url?.absoluteString ?? "NIL") ***\n\(jsonString ?? "EMPTY")\n***)")

                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: _data, options: []) as? JSONObject, let agendas = jsonObject[JSON.options] as? JSONArray {
                        
                        let (processInsert, processUpdate, processError) = _persistence.process(agendas: agendas)

                        _error = processError
                        inserted = processInsert
                        updated = processUpdate
                    }
                }
                catch let error2 {
                    _error = error2
                }
            }
            else if _error == nil {
                _error = NSError(domain: Errors.domain, code: Errors.emptyData.code, userInfo: [NSLocalizedDescriptionKey: Errors.emptyData.message])
            }

            self.activityDelegate?.hideNetworkActivityIndicator()
            completion?(inserted, updated, _error)
        }
    }
    
    /*!
     * @brief Fetches ArtObjects (collection items) from API
     *
     * @param query Query string
     * @param page Actual page number - used wth pagination
     * @param pageSize Page size - fetches this number of records at a time
     * @param language 2 digit langage code, defaults to "nl"
     * @param isQueueable True if call can be queued if no network connection, otherwise completes with error
     * @param completion Completion handler block
     */
    func fetchArtObjects(query: String? = nil, page: Int = 1, pageSize: Int = 10, language: String? = nil, isQueueable: Bool = false, completion: FetchCompletion?) {
        
        guard let _session = session else {
            completion?(0, 0, NSError(domain: Errors.domain, code: Errors.sessionNotConfigured.code, userInfo: [NSLocalizedDescriptionKey: Errors.sessionNotConfigured.message]))
            return
        }
        
        guard let _persistence = persistence else {
            completion?(0, 0, NSError(domain: Errors.domain, code: Errors.persistenceNotConfigured.code, userInfo: [NSLocalizedDescriptionKey: Errors.persistenceNotConfigured.message]))
            return
        }
        
        guard _session.isServerReachable else {
            
            if isQueueable && !NetworkOperationQueue.shared.isOperationQueued(kind: QueueKind.fetchCollections) {
                NetworkOperationQueue.shared.queueOperation(kind: QueueKind.fetchCollections) {
                    self.fetchArtObjects(query: query, page: page, pageSize: pageSize, language: language, isQueueable: false, completion: completion)
                }
            }
            else {
                completion?(0, 0, NSError(domain: Errors.domain, code: Errors.serverNotRerachable.code, userInfo: [NSLocalizedDescriptionKey: Errors.serverNotRerachable.message]))
            }
            return
        }
        
        let _language = language ?? "nl"
        
        var url = Configuration.baseURL.appendingPathComponent(Configuration.collecton).appendQueryItem(with: Configuration.pPage, value: "\(page)").appendQueryItem(with: Configuration.pPageSize, value: "\(pageSize)").appendQueryItem(with: Configuration.pCulture, value: _language)
        addKeyAndFormat(to: &url)
        
        if let _query = query {
            url = url.appendQueryItem(with: Configuration.pQuery, value: _query)
        }
        
        var request = URLRequest(url: url)
        request.configure(method: .get)
        
        self.activityDelegate?.showNetworkActivityIndicator()
        
        _session.startDataTask(with: request) { (data, response, error) in
            
            var inserted = 0
            var updated = 0
            var _error: Error? = error
            
            if let _data = data, !_data.isEmpty {
                
                let jsonString = String(data: _data, encoding: .utf8)
                print("*** RECEIVED from \(request.url?.absoluteString ?? "NIL") ***\n\(jsonString ?? "EMPTY")\n***)")
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: _data, options: []) as? JSONObject, let artObjects = jsonObject[JSON.artObjects] as? JSONArray {
                        
                        let (processInsert, processUpdate, processError) = _persistence.process(artObjects: artObjects)
                        
                        _error = processError
                        inserted = processInsert
                        updated = processUpdate
                    }
                }
                catch let error2 {
                    _error = error2
                }
            }
            else if _error == nil {
                _error = NSError(domain: Errors.domain, code: Errors.emptyData.code, userInfo: [NSLocalizedDescriptionKey: Errors.emptyData.message])
            }
            
            self.activityDelegate?.hideNetworkActivityIndicator()
            completion?(inserted, updated, _error)
        }
    }
    
    
    private func addKeyAndFormat(to url: inout URL) {
        
        url = url.appendQueryItem(with: Configuration.pAPIkey, value: Configuration.apiKey)
        url = url.appendQueryItem(with: Configuration.pFormat, value: Configuration.json)
    }
}
