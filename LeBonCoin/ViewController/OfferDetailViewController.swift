//
//  OfferDetailViewController.swift
//  LeBonCoin
//
//  Created by Julien Lebeau on 11/02/2021.
//

import UIKit

class OfferDetailViewController: UIViewController {
    let offer: UIOffer?
    
    @UsesAutoLayout
    var titleLabel: UILabel = UILabel()
    
    init(offer: UIOffer?) {
        self.offer = offer
        super.init(nibName: nil, bundle: nil)
        
        self.view.addSubview(titleLabel)
        
        let titleLabelConstraints = [
            titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLabel.text = offer?.title ?? ""
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
