//
//  CategoriesFilterTableViewController.swift
//  LeBonCoin
//
//  Created by Julien Lebeau on 11/02/2021.
//

import UIKit

protocol CategoriesFilterDelegate: AnyObject {
    func filterUpdated()
}

class CategoriesFilterTableViewController: UITableViewController {
    static private let cellIdentifier = "UICategoryCellID"
    
    private let viewModel: OffersViewModel
    private weak var delegate: CategoriesFilterDelegate?
    
    init(viewModel: OffersViewModel = OffersViewModel(), delegate: CategoriesFilterDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: CategoriesFilterTableViewController.cellIdentifier)
        self.viewModel.loadCategories { (_) in
            self.tableView.reloadData()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }

    @objc
    func done() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CategoriesFilterTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesFilterTableViewController.cellIdentifier, for: indexPath)
        let category = self.viewModel.categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        if case .category(let id) = self.viewModel.selectedFilter, id == category.id {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = self.viewModel.categories[indexPath.row]
        if case .category(let id) = self.viewModel.selectedFilter, id == selectedCategory.id {
            self.viewModel.loadOffers(filter: .noFilter) { _ in
                self.tableView.reloadData()
                self.delegate?.filterUpdated()
            }
        } else {
            self.viewModel.loadOffers(filter: .category(selectedCategory.id)) { _ in
                self.tableView.reloadData()
                self.delegate?.filterUpdated()
            }
        }
    }
}
