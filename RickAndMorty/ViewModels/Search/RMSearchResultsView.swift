//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 14.03.2023.
//

import UIKit

/// Shows search results UI (table or collection as needed)
class RMSearchResultsView: UIView {
  private var viewModel: RMSearchResultViewModel? {
    didSet {
      print("View Model Process")
      self.processViewModel()
    }
  }
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
    table.isHidden = true
    table.translatesAutoresizingMaskIntoConstraints = false

    return table
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    isHidden = true
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews(tableView)
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func processViewModel() {
    guard let viewModel = viewModel else {
      return
    }
    
    switch viewModel {
    case .characters(let viewModels):
      
      setUpCollectionView()
    case .locations(let viewModels):
      setUpTableView()
      print("Location call")
    case .episodes(let viewModels):
      setUpCollectionView()
    }
  }
  
  private func setUpCollectionView() {
    
  }
  
  private func setUpTableView() {
    tableView.isHidden = false
    print(tableView.isHidden)
    print("Table call")
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
    tableView.backgroundColor = .yellow

    print("Constrains setted up")

  }
  
  public func configure(with viewModel: RMSearchResultViewModel) {
    self.viewModel = viewModel
    print("configure")
  }
}
