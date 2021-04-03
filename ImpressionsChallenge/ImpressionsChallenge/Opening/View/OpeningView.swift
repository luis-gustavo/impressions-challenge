//
//  OpeningView.swift
//  ImpressionsChallenge
//
//  Created by luis.gustavo.jacinto on 02/04/21.
//

import UIKit

protocol OpeningViewDelegate: AnyObject {
    func browseVideosTouched()
}

final class OpeningView: UIView {
    
    // MARK: - Properties
    weak var delegate: OpeningViewDelegate?
    
    private(set) lazy var browseVideosButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        button.addTarget(self, action: #selector(browseVideosTouched), for: .touchUpInside)
        button.setTitle("Select Video", for: .normal)
        return button
    }()
    
    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods extension
private extension OpeningView {
    @objc func browseVideosTouched() {
        delegate?.browseVideosTouched()
    }
}

// MARK: - ViewCodable extension
extension OpeningView: ViewCodable {
    func buildViewHierarchy() {
        addSubview(browseVideosButton)
    }
    
    func setupConstraints() {
        browseVideosButton.setupConstraints { view -> [NSLayoutConstraint] in
            [
                .left(firstItem: view, secondItem: self, constant: 20),
                .right(firstItem: self, secondItem: view, constant: 20),
                .verticalCenter(firstView: view, secondView: self),
                .height(view: view, constant: 30)
            ]
        }
    }
    
    func setupAdditionalConfiguration() { }
}
