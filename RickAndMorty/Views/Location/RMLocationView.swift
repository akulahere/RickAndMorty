//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 07.03.2023.
//

import UIKit

class RMLocationView: UIView {

  private var viewModel: RMLcationViewViewModel? {
    didSet {
      spinner.stopAnimating()
      tableView.isHidden = false
      tableView.reloadData()
      UIView.animate(withDuration: 0.3) {
        self.tableView.alpha = 1
      }
    }
  }
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.alpha = 0
    table.isHidden = true
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
  }
  
  required init?(coder: NSCoder) {
    fatalError()
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
  
  func configure(with viewModel: RMLcationViewViewModel) {
    self.viewModel = viewModel
  }
  

}
