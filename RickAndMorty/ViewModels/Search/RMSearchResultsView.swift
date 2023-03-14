//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 14.03.2023.
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
  func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
}

/// Shows search results UI (table or collection as needed)
class RMSearchResultsView: UIView {
  weak var delegate: RMSearchResultsViewDelegate?
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
  
  private var locationCellViewModeils: [RMLocationTableViewCellViewModel] = []
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
      setUpTableView(viewModels: viewModels)
    case .episodes(let viewModels):
      setUpCollectionView()
    }
  }
  
  private func setUpCollectionView() {
    
  }
  
  private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]) {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.isHidden = false
    self.locationCellViewModeils = viewModels
    tableView.reloadData()
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  public func configure(with viewModel: RMSearchResultViewModel) {
    self.viewModel = viewModel
  }
}

// MARK: - TableView

extension RMSearchResultsView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locationCellViewModeils.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier, for: indexPath) as? RMLocationTableViewCell else {
      fatalError()
    }
    cell.configure(with: locationCellViewModeils[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let viewModel = locationCellViewModeils[indexPath.row]
    delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
  }
}
