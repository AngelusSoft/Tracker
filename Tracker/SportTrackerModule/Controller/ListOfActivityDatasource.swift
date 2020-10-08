//
//  ListOfActivityDatasource.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation
import UIKit

class ListOfActivityDatasource {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ActivityViewModel>
    
    private let dataSource: DataSource
    
    init(collectionView: UICollectionView) {
        self.dataSource = ListOfActivityDatasource.makeDataSource(for: collectionView)
        
        collectionView.register(ListActivityCollectionViewCell.self, forCellWithReuseIdentifier: ListActivityCollectionViewCell.cellId)
        collectionView.register(ListActivityHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ListActivityHeader.cellId)
    }
    
    func addHeader(action: @escaping (ListActivityHeader.Category)->()) {
        self.dataSource.supplementaryViewProvider = { collectionView, kind, indexpath in
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ListActivityHeader.cellId, for: indexpath) as? ListActivityHeader
            cell?.action = action
            return cell
        }
    }
    
    private static func makeDataSource(for collectionView: UICollectionView) -> DataSource {
      let dataSource = DataSource(
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, activity) ->
          UICollectionViewCell? in
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListActivityCollectionViewCell.cellId,
            for: indexPath) as? ListActivityCollectionViewCell
            cell?.configure(with: activity)
          return cell
      })
      return dataSource
    }

    func applySnapshot(model: [ActivityViewModel]) {
      var snapshot = NSDiffableDataSourceSnapshot<Section, ActivityViewModel>()
        
        
      
      snapshot.appendSections([.main])
      snapshot.appendItems(model)
      dataSource.apply(snapshot, animatingDifferences: true)
    }

}
