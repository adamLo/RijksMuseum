//
//  AgendaCell.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 12/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

/*!
 * @brief Displays an event from agenda
 */
class AgendaCell: UITableViewCell {

    static let reuseId = "agendaCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var expositionTypeLabel: UILabel!
    @IBOutlet weak var groupTypeLabel: UILabel!
    
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    lazy var dateFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .none
        
        titleLabel.font = UIFont.defaultFont(style: .bold, size: .large)
        descriptionLabel.font = UIFont.defaultFont(style: .regular, size: .base)
        expositionTypeLabel.font = UIFont.defaultFont(style: .regular, size: .base)
        groupTypeLabel.font = UIFont.defaultFont(style: .regular, size: .base)
        periodLabel.font = UIFont.defaultFont(style: .regular, size: .base)
        priceLabel.font = UIFont.defaultFont(style: .regular, size: .base)
    }

    /*!
     * @brief Sets up cell with given event
     *
     * @param agenda Event to display
     */
    func setup(with agenda: Agenda) {
        
        titleLabel.text = agenda.exposition?.name
        
        if let desc = agenda.exposition?.expositionDescription {
            descriptionLabel.text = desc.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        else {
            descriptionLabel.text = nil
        }
        
        if let exposition = agenda.expositionType?.friendlyName {
            expositionTypeLabel.text = "\(Localizations.expositionTypeTitle) \(exposition)"
        }
        else {
            expositionTypeLabel.text = nil
        }
        
        if let group = agenda.groupType?.friendlyName {
            groupTypeLabel.text = "\(Localizations.groupTypeTitle) \(group)"
        }
        else {
            groupTypeLabel.text = nil
        }
        
        if let start = agenda.period?.startDate, let end = agenda.period?.endDate, let text = agenda.period?.text {
            periodLabel.text = "\(Localizations.periodTitle) \(dateFormatter.string(from: start as Date)) - \(dateFormatter.string(from: end as Date)) \(text)"
        }
        else {
            periodLabel.text = nil
        }
        
        if let price = agenda.exposition?.price?.amount {
            priceLabel.text = "\(Localizations.PriceTitle) €\(price)"
        }
        else {
            priceLabel.text = nil
        }
    }
}
