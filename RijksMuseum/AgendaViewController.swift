//
//  AgendaViewController.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 12/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit
import CoreData
import ActionSheetPicker_3_0

/*!
 * @brief Displays Agenda with upcoming events
 */
class AgendaViewController: CachedViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!

    @IBOutlet weak var agendaTableView: UITableView!
    
    /// User selected date
    private var date = Date()
    
    private lazy var dateFormater: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        updateDateDisplay()
        
        loadAgendas(resetFetchedResultsController: true)
    }
        
    // MARK: - UI customizaton
    
    private func setupUI() {

        title = Localizations.agendaTitle
        
        setupTableView()
        setupDateDisplay()
        addRefreshControl()
    }
    
    private func setupTableView() {
        
        agendaTableView.tableFooterView = UIView()
        agendaTableView.separatorStyle = .none
    }
    
    private func setupDateDisplay() {
        
        dateLabel.text = Localizations.dateStaticTitle
        dateLabel.font = UIFont.defaultFont(style: .regular, size: .base)
        
        dateButton.titleLabel?.font = UIFont.defaultFont(style: .regular, size: .base)
    }
    
    private func addRefreshControl() {
        
        let refreshControl = UIRefreshControl(frame: CGRect.zero)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        agendaTableView.refreshControl = refreshControl
    }
    
    // MARK: - UI manipulations
    
    private func updateDateDisplay() {
        
        dateButton.setTitle(dateFormater.string(from: date), for: .normal)
    }

    // MARK: - FetchedResultsController
    
    private var agendasFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    private func setupFetchedResultsController() {
        
        if agendasFetchedResultsController != nil {
            
            agendasFetchedResultsController!.fetchRequest.predicate = NSPredicate.init(value: false)
            do  {
                try agendasFetchedResultsController?.performFetch()
            }
            catch let error {
                print("Error clearing agandas fetched results controller: \(error)")
            }
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Agenda.entityName)
        request.predicate = NSPredicate(format: "%K >= %@ AND %K <= %@", Agenda.date, date.startOfDay as NSDate, Agenda.date, date.endOfDay as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: Agenda.date, ascending: false)]
        request.includesSubentities = true
        
        if agendasFetchedResultsController == nil {
            
            agendasFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Persistence.shared.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        }
        else {
            
            agendasFetchedResultsController!.fetchRequest.predicate = request.predicate
            agendasFetchedResultsController!.fetchRequest.sortDescriptors = request.sortDescriptors
        }
        
        agendasFetchedResultsController!.delegate = self
    }
    
    private func loadAgendas(resetFetchedResultsController: Bool) {
        
        if agendasFetchedResultsController == nil || resetFetchedResultsController {
            setupFetchedResultsController()
        }
        
        agendaTableView.reloadData()
        
        do {
            
            try agendasFetchedResultsController!.performFetch()
            agendaTableView.reloadData()
        }
        catch let error {
            
            showOKDialog(message: error.localizedDescription)
            print("Error loading agendas: \(error)")
        }
    }
    
    private var changesStarted = 0
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        changesStarted += 1
        
        if changesStarted == 1 {
            agendaTableView.beginUpdates()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            if let _indexPath = newIndexPath {
                self.agendaTableView.insertRows(at: [_indexPath], with: .top)
            }
            
        case .delete:
            if let _indexPath = indexPath {
                self.agendaTableView.deleteRows(at: [_indexPath], with: .none)
            }
            
        case .update:
            if let _indexPath = indexPath {
                self.agendaTableView.reloadRows(at: [_indexPath], with: .none)
            }
            
        case .move:
            if let _indexPath = indexPath {
                self.agendaTableView.deleteRows(at: [_indexPath], with: .none)
            }
            if let _indexPath = newIndexPath {
                self.agendaTableView.insertRows(at: [_indexPath], with: .none)
            }
            
        @unknown default:
            self.agendaTableView.reloadData()
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        changesStarted = max(changesStarted - 1, 0)
        
        if changesStarted == 0 {
            agendaTableView.endUpdates()
        }
    }
        
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return agendasFetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let agendas = agendasFetchedResultsController?.fetchedObjects as? [Agenda], indexPath.row < agendas.count, let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.reuseId, for: indexPath) as? AgendaCell {
            
            let agenda = agendas[indexPath.row]
            cell.setup(with: agenda)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let agendas = agendasFetchedResultsController?.fetchedObjects as? [Agenda], indexPath.row < agendas.count, let url = agendas[indexPath.row].webURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func dateButtonTouched(_ sender: Any) {
        
        ActionSheetDatePicker.show(withTitle: Localizations.datePickerTitle, datePickerMode: .date, selectedDate: date, doneBlock: {[weak self] (picker, value, index) in
            
            if let _date = value as? Date, let _self = self {
                
                _self.date = _date
                _self.updateDateDisplay()
                _self.loadAgendas(resetFetchedResultsController: true)
                _self.fetchAgendas(queueable: false)
            }
            
        }, cancel: nil, origin: view)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        
        guard !isFetchingData else {
            sender.endRefreshing()
            return
        }
        
        loadAgendas(resetFetchedResultsController: true)
        fetchAgendas(queueable: false)
    }
    
    // MARK: - API Integration
    
    private var isFetchingData = false
    
    private func fetchAgendas(queueable: Bool) {
        
        guard !isFetchingData else {return}
        
        isFetchingData = true
        
        Network.shared.fetchAgendas(date: date, isQueueable: queueable) {[weak self] (_, _, error) in
            
            guard let _self = self else {return}
            
            DispatchQueue.main.async {
                
                _self.isFetchingData = false
                
                if let _refreshControl = _self.agendaTableView.refreshControl, _refreshControl.isRefreshing {
                    _refreshControl.endRefreshing()
                }
                
                if let _error = error {
                    _self.showOKDialog(message: _error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Overrides
    
    override internal func refreshCache() {
        
        fetchAgendas(queueable: true)
    }
    
    override internal func isCacheEmpty() -> Bool {
     
        return agendasFetchedResultsController?.fetchedObjects?.count ?? 0 == 0
    }
}
