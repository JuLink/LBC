//
//  OfferTableViewCell.swift
//  LeBonCoin
//
//  Created by Julien Lebeau on 11/02/2021.
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    static let offerCellReuseIdentifier = "OfferTableViewCellID"
    var imageRetriever: ImageRetriever?
    
    @UsesAutoLayout
    var offerImage: UIImageView = UIImageView()
    @UsesAutoLayout
    var title: UILabel = UILabel()
    @UsesAutoLayout
    var category: UILabel = UILabel()
    @UsesAutoLayout
    var price: UILabel = UILabel()
    @UsesAutoLayout
    var urgentImage: UIImageView = UIImageView()
    @UsesAutoLayout
    var creationDate: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let priceConstraints = self.configurePriceLabel()
        let offerImageConstraints = self.configureOfferImage()
        let urgencyImageConstraints = self.configureUrgencyImage()
        let titleConstraints = self.configureTitleLabel()
        let categoryConstraints = self.configureCategoryLabel()
        let creationDateconstraints = self.configureCreationDate()
        
        self.accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate(
            priceConstraints +
            offerImageConstraints +
            urgencyImageConstraints +
            titleConstraints +
            categoryConstraints +
            creationDateconstraints +
            priceConstraints
        )
    }
    
    private func configurePriceLabel() -> [NSLayoutConstraint] {
        contentView.addSubview(self.price)
        let priceConstraints = [
            self.price.centerXAnchor.constraint(equalTo: self.offerImage.centerXAnchor),
            self.price.topAnchor.constraint(equalTo: self.offerImage.bottomAnchor, constant: Self.priceVerticalSpacing),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: price.bottomAnchor, constant: Self.priceVerticalSpacing)
        ]
        self.price.textAlignment = .center
        self.price.textColor = UIColor.accent
        self.price.font = UIFont.preferredFont(forTextStyle: .callout)
        
        return priceConstraints
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureOfferImage() -> [NSLayoutConstraint] {
        contentView.addSubview(self.offerImage)
        let imageConstraints = [
            self.offerImage.widthAnchor.constraint(equalToConstant: Self.imageWidthAndHeight),
            self.offerImage.heightAnchor.constraint(equalToConstant: Self.imageWidthAndHeight),
            self.offerImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.topPadding),
            self.offerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.horizontalPadding)
        ]
        self.offerImage.contentMode = .scaleAspectFill
        self.offerImage.clipsToBounds = true
        return imageConstraints
    }
    
    private func configureUrgencyImage() -> [NSLayoutConstraint] {
        self.contentView.addSubview(self.urgentImage)
        let urgentImageconstraints = [
            contentView.trailingAnchor.constraint(equalTo: self.urgentImage.trailingAnchor),
            self.urgentImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.topPadding),
            self.urgentImage.widthAnchor.constraint(equalToConstant: Self.urgencyImageWidthAndHeight),
            self.urgentImage.heightAnchor.constraint(equalToConstant: Self.urgencyImageWidthAndHeight)
        ]
        return urgentImageconstraints
    }
    
    private func configureTitleLabel() -> [NSLayoutConstraint] {
        self.contentView.addSubview(self.title)
        let titleConstraints = [
            self.title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.topPadding),
            self.title.leadingAnchor.constraint(equalTo: self.offerImage.trailingAnchor, constant: Self.imageHorizontalSpacing),
            self.urgentImage.leadingAnchor.constraint(equalTo: self.title.trailingAnchor, constant: Self.imageHorizontalSpacing)
        ]
        self.title.numberOfLines = 2
        self.title.textColor = UIColor.primary
        self.title.font = UIFont.preferredFont(forTextStyle: .title3)
        return titleConstraints
    }
    
    private func configureCategoryLabel() -> [NSLayoutConstraint] {
        self.contentView.addSubview(self.category)
        let categoryConstraints = [
            self.category.topAnchor.constraint(equalTo: self.title.bottomAnchor),
            self.category.leadingAnchor.constraint(equalTo: self.title.leadingAnchor),
            self.category.trailingAnchor.constraint(equalTo: self.title.trailingAnchor)
        ]
        self.category.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.category.textColor = UIColor.secondary
        return categoryConstraints
    }
    
    private func configureCreationDate() -> [NSLayoutConstraint] {
        self.contentView.addSubview(self.creationDate)
        let creationDateconstraints = [
            self.creationDate.topAnchor.constraint(equalTo: self.category.bottomAnchor),
            self.creationDate.leadingAnchor.constraint(equalTo: self.title.leadingAnchor),
            self.creationDate.trailingAnchor.constraint(equalTo: self.title.trailingAnchor),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: self.creationDate.bottomAnchor, constant: Self.priceVerticalSpacing)
        ]
        self.creationDate.font = UIFont.preferredFont(forTextStyle: .caption1)
        self.creationDate.textColor = UIColor.secondary
        return creationDateconstraints
    }
    
    func setup(title: String, category: String, price: String, imageURL: URL?, isUrgent: Bool, creationDate: String, imageRetriever: ImageRetriever) {
        self.title.text = title
        self.category.text = category
        self.price.text = price
        self.offerImage.image = nil
        self.imageRetriever = imageRetriever
        self.imageRetriever?.image(for: imageURL) { [weak self] (downloadedImage) in
            if let image = downloadedImage {
                self?.offerImage.image = image
            }
        }
        self.urgentImage.image = isUrgent ? UIImage(named: "urgent") : nil
        self.creationDate.text = creationDate
    }
    
    override class var requiresConstraintBasedLayout: Bool { return true }
    
    //MARK: - UI Constants
    static private let topPadding: CGFloat = 10
    static private let priceVerticalSpacing: CGFloat = 6
    static private let imageWidthAndHeight: CGFloat = 100
    static private let horizontalPadding: CGFloat = 16
    static private let imageHorizontalSpacing: CGFloat = 10
    static private let urgencyImageWidthAndHeight: CGFloat = 16
}
