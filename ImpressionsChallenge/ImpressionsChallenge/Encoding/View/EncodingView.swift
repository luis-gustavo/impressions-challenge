//
//  EncodingView.swift
//  ImpressionsChallenge
//
//  Created by luis.gustavo.jacinto on 02/04/21.
//

import UIKit

final class EncodingView: UIView {
    
    // MARK: - Properties
    private(set) lazy var progressIndicator: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.setProgress(0, animated: true)
        return view
    }()
    
    private(set) lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.text = "Please Wait"
        return label
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

// MARK: Internal methods extension
extension EncodingView {
    func updateProgress(_ progress: Float) {
        progressIndicator.setProgress(progress, animated: true)
    }
}

// MARK: - ViewCodable extension
extension EncodingView: ViewCodable {
    func buildViewHierarchy() {
        addSubview(progressIndicator)
        addSubview(progressLabel)
    }
    
    func setupConstraints() {
        progressIndicator.setupConstraints { view -> [NSLayoutConstraint] in
            [
                .left(firstItem: view, secondItem: self, constant: 20),
                .right(firstItem: self, secondItem: view, constant: 20),
                .verticalCenter(firstView: view, secondView: self),
                .height(view: view, constant: 30)
            ]
        }
        
        progressLabel.setupConstraints { view -> [NSLayoutConstraint] in
            [
                .left(firstItem: view, secondItem: self, constant: 20),
                .right(firstItem: self, secondItem: view, constant: 20),
                .over(topItem: view, bottomItem: progressIndicator, constant: 20),
                .height(view: view, constant: 30)
            ]
        }
    }
    
    func setupAdditionalConfiguration() { }
}
