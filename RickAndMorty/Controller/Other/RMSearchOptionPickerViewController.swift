//
//  RMSearchOptionPickerViewController.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 10.03.2023.
//

import UIKit

class RMSearchOptionPickerViewController: UIViewController {
  private let option: RMSearchInputViewViewModel.DynamicOption
  private let selectionBlock: (String) -> Void
  private let tableView: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
  }()
  
  init(
    option: RMSearchInputViewViewModel.DynamicOption,
    selection: @escaping (String) -> Void
  ) {
    self.option = option
    self.selectionBlock = selection
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setUpTable()
  }
  
  private func setUpTable() {
    view.addSubview(tableView)
    print("table set up")
    tableView.delegate = self
    tableView.dataSource = self
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
}


extension RMSearchOptionPickerViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return option.choices.count
  }
  
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let choice = option.choices[indexPath.row]
    cell.textLabel?.text = choice.uppercased()

    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let choice = option.choices[indexPath.row]
    self.selectionBlock(choice)
    dismiss(animated: true)
  }
}
