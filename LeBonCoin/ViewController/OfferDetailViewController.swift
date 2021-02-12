//
//  OfferDetailViewController.swift
//  LeBonCoin
//
//  Created by Julien Lebeau on 11/02/2021.
//

import UIKit

class OfferDetailViewController: UIViewController {
    @UsesAutoLayout
    var imageView: UIImageView = UIImageView()
    @UsesAutoLayout
    var titleLabel: UILabel = UILabel()
    @UsesAutoLayout
    var urgencyImageView: UIImageView = UIImageView()
    @UsesAutoLayout
    var priceLabel: UILabel = UILabel()
    @UsesAutoLayout
    var categoryLabel: UILabel = UILabel()
    @UsesAutoLayout
    var dateLabel: UILabel = UILabel()
    @UsesAutoLayout
    var descriptionLabel: UILabel = UILabel()
    @UsesAutoLayout
    var siretLabel: UILabel = UILabel()
    @UsesAutoLayout
    var scrollview: UIScrollView = UIScrollView()
    
    private let offer: UIOffer
    private let imageRetriever: ImageRetriever
    
    
    init(offer: UIOffer, imageRetriever: ImageRetriever) {
        self.offer = offer
        self.imageRetriever = imageRetriever
        super.init(nibName: nil, bundle: nil)
        
        let scrollViewConstraint = self.configureScrollView()
        let imageViewConstraints = self.configureImageview()
        let urgencyImageConstraints = self.configureUrgencyImageView()
        let titleConstriants = self.configureTitleLabel()
        let priceConstraints = self.configurePriceLabel()
        let categoryConstraints = self.configureCategoryLabel()
        let dateConstraints = self.configureDateLabel()
        let descriptionConstraints = self.configureDescriptionLabel()
        let siretConstraints = self.configureSiretLabel()
        
        NSLayoutConstraint.activate(scrollViewConstraint + imageViewConstraints + urgencyImageConstraints + titleConstriants + priceConstraints + categoryConstraints + dateConstraints + descriptionConstraints + siretConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage.emptyImage
        self.imageRetriever.image(for: offer.thumbImages) { [weak self](image) in
            if let image = image {
                self?.imageView.image = image
            }
        }
        self.urgencyImageView.image = offer.isUrgent ? UIImage.urgencyImage : nil
        
        self.titleLabel.text = offer.title
        
        self.priceLabel.text = offer.priceString
        self.categoryLabel.text = offer.category?.name
        self.dateLabel.text = offer.creationDateString
        self.descriptionLabel.text = offer.description
        if let siret = offer.siret {
            self.siretLabel.text = "N° SIRET : \(siret)"
        } else {
            self.siretLabel.text = ""
        }
    }
}

//MARK: - View Constraints setup and configuration
extension OfferDetailViewController {
    private func configureScrollView() -> [NSLayoutConstraint] {
        self.view.addSubview(self.scrollview)
        let scrollViewConstraint = [
            self.scrollview.frameLayoutGuide.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollview.frameLayoutGuide.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollview.frameLayoutGuide.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollview.frameLayoutGuide.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollview.contentLayoutGuide.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ]
        self.scrollview.backgroundColor = UIColor.background
        return scrollViewConstraint
    }
    
    private func configureImageview() -> [NSLayoutConstraint] {
        self.scrollview.addSubview(self.imageView)
        let imageViewConstraints = [
            self.imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.scrollview.contentLayoutGuide.leadingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.scrollview.contentLayoutGuide.topAnchor)
        ]
        self.imageView.contentMode = .scaleAspectFill
        return imageViewConstraints
    }
    
    private func configureUrgencyImageView() -> [NSLayoutConstraint] {
        self.scrollview.addSubview(self.urgencyImageView)
        let urgencyImageConstraints = [
            self.urgencyImageView.widthAnchor.constraint(equalToConstant: Self.urgencyImageViewSize),
            self.urgencyImageView.heightAnchor.constraint(equalToConstant: Self.urgencyImageViewSize),
            self.urgencyImageView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: Self.urgencyImagePadding),
            self.scrollview.contentLayoutGuide.trailingAnchor.constraint(equalTo: self.urgencyImageView.trailingAnchor, constant: Self.urgencyImagePadding)
        ]
        return urgencyImageConstraints
    }
    
    private func configureTitleLabel() -> [NSLayoutConstraint] {
        self.scrollview.addSubview(self.titleLabel)
        let titleConstriants = [
            self.titleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: Self.urgencyImagePadding),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.scrollview.contentLayoutGuide.leadingAnchor, constant: Self.titleLabelLeadingPadding),
            self.urgencyImageView.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: Self.urgencyImagePadding)
        ]
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        return titleConstriants
    }
    
    private func configurePriceLabel() -> [NSLayoutConstraint] {
        self.scrollview.addSubview(self.priceLabel)
        let priceConstraints = [
            self.priceLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.priceLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
            self.priceLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor)
        ]
        self.priceLabel.textColor = UIColor.accent
        self.priceLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        return priceConstraints
    }
    
    private func configureCategoryLabel()-> [NSLayoutConstraint] {
        self.scrollview.addSubview(self.categoryLabel)
        let categoryConstraints = [
            self.categoryLabel.leadingAnchor.constraint(equalTo: self.priceLabel.leadingAnchor),
            self.categoryLabel.trailingAnchor.constraint(equalTo: self.priceLabel.trailingAnchor),
            self.categoryLabel.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor)
        ]
        self.categoryLabel.textColor = UIColor.secondary
        self.categoryLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        return categoryConstraints
    }
    
    private func configureDateLabel() -> [NSLayoutConstraint] {
        self.scrollview.addSubview(self.dateLabel)
        let dateConstraints = [
            self.dateLabel.leadingAnchor.constraint(equalTo: self.categoryLabel.leadingAnchor),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.categoryLabel.trailingAnchor),
            self.dateLabel.topAnchor.constraint(equalTo: self.categoryLabel.bottomAnchor)
        ]
        self.dateLabel.textColor = UIColor.secondary
        self.dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return dateConstraints
    }
    
    private func configureDescriptionLabel() -> [NSLayoutConstraint] {
        self.scrollview.addSubview(self.descriptionLabel)
        let descriptionConstraints = [
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.scrollview.leadingAnchor, constant: Self.descriptionPadding),
            self.scrollview.trailingAnchor.constraint(equalTo: self.descriptionLabel.trailingAnchor, constant: Self.descriptionPadding),
            self.descriptionLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: Self.descriptionPadding)
        ]
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.textColor = UIColor.primary
        self.descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        return descriptionConstraints
    }
    
    private func configureSiretLabel() -> [NSLayoutConstraint] {
        self.scrollview.addSubview(self.siretLabel)
        let siretConstraints = [
            self.siretLabel.leadingAnchor.constraint(equalTo: self.descriptionLabel.leadingAnchor),
            self.siretLabel.trailingAnchor.constraint(equalTo: self.descriptionLabel.trailingAnchor),
            self.siretLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: Self.siretPadding),
            self.scrollview.contentLayoutGuide.bottomAnchor.constraint(equalTo: self.siretLabel.bottomAnchor, constant: Self.siretPadding)
        ]
        self.siretLabel.textColor = UIColor.secondary
        self.siretLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return siretConstraints
    }
    
    //MARK: - UI Constants
    static private let urgencyImageViewSize: CGFloat = 16
    static private let urgencyImagePadding: CGFloat = 10
    static private let titleLabelLeadingPadding: CGFloat = 16
    static private let descriptionPadding: CGFloat = 16
    static private let siretPadding: CGFloat = 16
}
