//
//  OffersListViewController.swift
//  LeBonCoin
//
//  Created by Julien Lebeau on 09/02/2021.
//

import UIKit

class OffersListViewController: UITableViewController {
    let viewModel: OffersViewModel
    let imageRetriever: ImageRetriever
    
    init(viewModel: OffersViewModel = OffersViewModel(), imageRetriever: ImageRetriever = ImageCacheDownloader()) {
        self.viewModel = viewModel
        self.imageRetriever = imageRetriever
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(OfferTableViewCell.self, forCellReuseIdentifier: OfferTableViewCell.offerCellReuseIdentifier)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openFilter))

        // Do any additional setup after loading the view.
        viewModel.loadOffers(completion: { _ in
            self.tableView.reloadData()
        })
    }
    
    @objc
    func openFilter() {
        let filterVc = CategoriesFilterTableViewController(viewModel: viewModel, delegate: self)
        self.present(UINavigationController(rootViewController: filterVc), animated: true, completion: nil)
    }
}

extension OffersListViewController: CategoriesFilterDelegate {
    func filterUpdated() {
        self.tableView.reloadData()
    }
}

extension OffersListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.offers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: OfferTableViewCell.offerCellReuseIdentifier, for: indexPath) as? OfferTableViewCell {
            let model = self.viewModel.offers[indexPath.row]
            cell.setup(title: model.title, category: model.category?.name ?? "", price: model.priceString, imageURL: model.thumbImages, isUrgent: model.isUrgent, imageRetriever: self.imageRetriever)
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let offer = self.viewModel.offers[indexPath.row]
        let detailViewController = OfferDetailViewController(offer: offer)
        self.splitViewController?.showDetailViewController(detailViewController, sender: self)
        
    }
}
