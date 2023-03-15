//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 07.03.2023.
//

import UIKit


protocol RMLocationViewDelegate: AnyObject {
  func rmLocationView(_ locationVuew: RMLocationView, didSelect location: RMLocation)
}

class RMLocationView: UIView {
  
  public weak var delegate: RMLocationViewDelegate?
  
  
  private var viewModel: RMLocationViewViewModel? {
    didSet {
      print("stop animation")
      spinner.stopAnimating()
      tableView.isHidden = false
      tableView.reloadData()
      UIView.animate(withDuration: 0.3) {
        self.tableView.alpha = 1
      }
    }
  }
  
  private let tableView: UITableView = {
    let table = UITableView(frame: .zero, style: .grouped)
    table.translatesAutoresizingMaskIntoConstraints = false
    table.alpha = 0
    table.isHidden = true
    table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
    return table
  }()
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.hidesWhenStopped = true
    return spinner
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemBackground
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews(tableView, spinner)
    spinner.startAnimating()
    addConstraints()
    configureTable()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func configureTable() {
    tableView.delegate = self
    tableView.dataSource  = self
  }
  private func addConstraints() {
    NSLayoutConstraint.activate([
      spinner.heightAnchor.constraint(equalToConstant: 100),
      spinner.widthAnchor.constraint(equalToConstant: 100),
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  func configure(with viewModel: RMLocationViewViewModel) {
    self.viewModel = viewModel
  }
  
  
}


extension RMLocationView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard let locationModel = viewModel?.locations(at: indexPath.row) else {
      return
    }
    delegate?.rmLocationView(self, didSelect: locationModel)
  }
}

extension RMLocationView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.cellViewModels.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cellViewmodels = viewModel?.cellViewModels else {
      fatalError()
    }
    
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: RMLocationTableViewCell.cellIdentifier,
      for: indexPath
    ) as? RMLocationTableViewCell else {
      fatalError()
    }
    
    let cellViewModel = cellViewmodels[indexPath.row]
    cell.configure(with: cellViewModel)
    
    return cell
  }
}

extension RMLocationView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let viewModel = viewModel,
          viewModel.shoudShowLoadMoreIndicator,
          !viewModel.isLoadingMoreLocation,
          !viewModel.cellViewModels.isEmpty else {

      return
    }
    
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
      let offset = scrollView.contentOffset.y
      let totalContentHeight = scrollView.contentSize.height
      let totalScrollViewFixedHeight = scrollView.frame.size.height
      
      if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
        DispatchQueue.main.async {
          self?.showLoadingIndicator()
        }
        viewModel.fetchAdditionalLocations()

      }
      timer.invalidate()
    }
  }
  private func showLoadingIndicator() {
    let footer = RMTableLoadingFooterView(frame:  CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
    tableView.tableFooterView = footer
  }
}
