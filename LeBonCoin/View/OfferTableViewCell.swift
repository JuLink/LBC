//
//  OfferTableViewCell.swift
//  LeBonCoin
//
//  Created by Julien Lebeau on 11/02/2021.
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    static let offerCellReuseIdentifier = "OfferTableViewCellID"
    
    @UsesAutoLayout
    var offerImage: UIImageView = UIImageView()
    @UsesAutoLayout
    var title: UILabel = UILabel()
    @UsesAutoLayout
    var category: UILabel = UILabel()
    @UsesAutoLayout
    var price: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(price)
        contentView.addSubview(offerImage)
        contentView.addSubview(category)
        contentView.addSubview(title)
        
        let priceConstraints = [
            price.centerXAnchor.constraint(equalTo: offerImage.centerXAnchor),
            price.topAnchor.constraint(equalTo: offerImage.bottomAnchor, constant: Self.elementVerticalSpacing),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: price.bottomAnchor, constant: Self.contentPadding)
        ]
        price.textAlignment = .center
        
        let imageConstraints = [
            offerImage.widthAnchor.constraint(equalToConstant: 100),
            offerImage.heightAnchor.constraint(equalToConstant: 100),
            offerImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.contentPadding),
            offerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.contentPadding)
        ]
        
        let titleConstraints = [
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.contentPadding),
            title.leadingAnchor.constraint(equalTo: offerImage.trailingAnchor, constant: Self.contentPadding),
            contentView.trailingAnchor.constraint(equalTo: title.trailingAnchor, constant: Self.contentPadding)
        ]
        title.numberOfLines = 0
        
        let categoryConstraints = [
            category.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Self.elementVerticalSpacing),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: category.bottomAnchor, constant: Self.contentPadding),
            category.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            category.trailingAnchor.constraint(equalTo: title.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(imageConstraints + priceConstraints + titleConstraints + categoryConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String, category: String, price: String, image: UIImage?) {
        self.title.text = title
        self.category.text = category
        self.price.text = price
        self.offerImage.image = image
    }
    override class var requiresConstraintBasedLayout: Bool { return true }
    
    
    //MARK: UI Constants
    static let contentPadding: CGFloat = 16
    static let elementVerticalSpacing: CGFloat = 8
}
