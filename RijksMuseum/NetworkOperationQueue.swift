//
//  NetworkOperationQueue.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 14/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

/*!
 * @brief Operation queue for network calls deferred when no network connection present
 */
class NetworkOperationQueue {
    
    static let shared = NetworkOperationQueue()
    
    /*!
     * @brief Wrapper for network operations
     */
    class PendingOperation {
        
        /// Actual operation block to execute
        let block: (() -> ())
        
        /// Indicates whether thos operation is already called and can be deleted
        var isCompleted = false
        
        /// Custom identifier to help determine whether this kind of call is already queued
        let kind: String
        
        init(kind: String, block :@escaping (() -> ())) {
            
            self.kind = kind
            self.block = block
        }
    }
    
    private var networkQueue = [PendingOperation]()
    
    /*!
     * @brief Startes queued operations. Call this when re-connected to network
     */
    func startPendingCalls() {
        
        for operation in networkQueue {
            if !operation.isCompleted {
                operation.block()
                operation.isCompleted = true
            }
        }
        
        networkQueue.removeAll { (operation) -> Bool in
            return operation.isCompleted
        }
    }
    
    /*!
     * @brief Tells whether a kind of operation is already queued
     *
     * @param kind Custom identfier of operation kind/type
     *
     * @return True if already queued
     */
    func isOperationQueued(kind: String) -> Bool {
        
        let pendingOperations = networkQueue.filter { (operation) -> Bool in
            return operation.kind == kind && !operation.isCompleted
        }
        
        return !pendingOperations.isEmpty
    }
    
    /*!
     * @brief Queue an operation for deferred call
     *
     * @param kind Custom identifier to help search
     * @param block A block that encapsulates a network operation
     */
    func queueOperation(kind: String, block: @escaping (() -> ())) {
        
        let operation = PendingOperation(kind: kind, block: block)
        networkQueue.append(operation)
    }
}
