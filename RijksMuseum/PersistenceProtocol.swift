//
//  PersistenceProtocol.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 10/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

/*!
 * @brief Protocol to define persistence functions
 */
protocol PersistenceProtocol {

    /*!
     * @brief Process Agenda items in JSON
     *
     * @param agendas JSON object array
     *
     * @return number of inserttions, number of updates, error occured during process
     */
    func process(agendas: [JSONObject]) -> (inserted: Int, updated: Int, error: Error?)
    
    /*!
     * @brief Process ArtObject items in JSON
     *
     * @param artObjects JSON object array
     *
     * @return number of inserttions, number of updates, error occured during process
     */
    func process(artObjects: [JSONObject]) -> (inserted: Int, updated: Int, error: Error?)
}
