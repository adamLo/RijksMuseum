//
//  CollectionViewController.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 12/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit
import CoreData

/*!
 * @brief Displays collections and lets user search
 */
class CollectionViewController: CachedViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var artobjectCollectionView: UICollectionView!
    
    /// Search query
    private var query: String?
    
    /// Search page size. Fetches this many objects at a time
    private let pageSize = 100
    
    struct Segue {
        static let artDetail = "artDetail"
    }
    
    // MARK: - Controller LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
        
        loadArtobjects(resetFetchedResultsController: true)
    }
    
    // MARK: - UI Customization
    
    private func setupUI() {
        
        title = Localizations.collectionsTitle
    }
    
    // MARK: - Actions
    
    @objc func refresh(_ sender: UIRefreshControl) {
        
        guard !isFetchingData else {
            sender.endRefreshing()
            return
        }
        
        loadArtobjects(resetFetchedResultsController: true)
        fetchArtObjects(queueable: false)
    }
    
    // MARK: - CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return artsFetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let _arts = artsFetchedResultsController?.fetchedObjects as? [ArtObject], indexPath.item < _arts.count, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtCell.reuseId, for: indexPath) as? ArtCell {
            
            let artObject = _arts[indexPath.item]
            cell.setup(with: artObject)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let searchView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ArtSearchView.reuseId, for: indexPath) as? ArtSearchView {
            
            searchView.queryBlock = {[weak self] (query) in
                
                if let _self = self {
                    
                    _self.query = query
                    _self.loadArtobjects(resetFetchedResultsController: true)
                    _self.fetchArtObjects(queueable: false)
                }
            }
            
            return searchView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if let _arts = artsFetchedResultsController?.fetchedObjects as? [ArtObject], indexPath.item < _arts.count {
            
            let artObject = _arts[indexPath.item]
            performSegue(withIdentifier: Segue.artDetail, sender: artObject)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width / 3 - 2
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2.0
    }
    
    // MARK: - FetchedResultsController
    
    private var artsFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    private func setupFetchedResultsController() {
        
        if artsFetchedResultsController != nil {
            
            artsFetchedResultsController!.fetchRequest.predicate = NSPredicate.init(value: false)
            do  {
                try artsFetchedResultsController?.performFetch()
            }
            catch let error {
                print("Error clearing ArtObjects fetched results controller: \(error)")
            }
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ArtObject.entityName)
        if let _query = query {
            request.predicate = NSPredicate(format: "(%K CONTAINS[cd] %@) OR (%K CONTAINS[cd] %@) OR (%K CONTAINS[cd] %@)", ArtObject.maker, _query, ArtObject.title, _query, ArtObject.longTitle, _query)
        }
        request.sortDescriptors = [
            NSSortDescriptor(key: ArtObject.maker, ascending: false),
            NSSortDescriptor(key: ArtObject.title, ascending: false)
        ]
        request.includesSubentities = true
        
        if artsFetchedResultsController == nil {
            
            artsFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Persistence.shared.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        }
        else {
            
            artsFetchedResultsController!.fetchRequest.predicate = request.predicate
            artsFetchedResultsController!.fetchRequest.sortDescriptors = request.sortDescriptors
        }
        
        artsFetchedResultsController!.delegate = self
    }
    
    private func loadArtobjects(resetFetchedResultsController: Bool) {
        
        if artsFetchedResultsController == nil || resetFetchedResultsController {
            setupFetchedResultsController()
        }
        
        artobjectCollectionView.reloadData()
        
        do {
            
            try artsFetchedResultsController!.performFetch()
            artobjectCollectionView.reloadData()
        }
        catch let error {
            
            showOKDialog(message: error.localizedDescription)
            print("Error loading ArtObjects: \(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        artobjectCollectionView.reloadData()
    }
    
    // MARK: - API integration
    
    private var isFetchingData = false
    
    /*!
     * @brief Fetches ArtObjects from API
     *
     * @param queueable True if call can be queued when not connected, false if user should be presented an error.
     *
     * @return True if session removed
     */
    private func fetchArtObjects(queueable: Bool) {
        
        guard !isFetchingData else {return}
        
        Network.shared.fetchArtObjects(query: query, page: 0, pageSize: pageSize, isQueueable: queueable) {[weak self] (_, _, error) in
            
            guard let _self = self else {return}
            
            DispatchQueue.main.async {
                
                _self.isFetchingData = false
                
                if let _refreshControl = _self.artobjectCollectionView.refreshControl, _refreshControl.isRefreshing {
                    _refreshControl.endRefreshing()
                }
                
                if let _error = error {
                    _self.showOKDialog(message: _error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.artDetail, let destination = segue.destination as? ArtDetailViewController, let artObject = sender as? ArtObject {
            
            destination.artObject = artObject
        }
    }
    
    // MARK: - Overrides
    
    override internal func refreshCache() {
        
        fetchArtObjects(queueable: true)
    }
    
    override internal func isCacheEmpty() -> Bool {
        
        return artsFetchedResultsController?.fetchedObjects?.count ?? 0 == 0
    }
}
