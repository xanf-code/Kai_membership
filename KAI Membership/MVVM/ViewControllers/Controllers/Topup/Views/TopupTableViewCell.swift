//
//  TopupTableViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 11/03/2021.
//

import UIKit

protocol TopupTableViewCellDelegate: class {
    func topupTableViewCellPhoneValueChange(_ topupTableViewCell: TopupTableViewCell, textField: UITextField)
    func topupTableViewCellProvider(_ topupTableViewCell: TopupTableViewCell, didSelectIndex index: Int)
    func topupTableViewCellDidValueMoney(_ topupTableViewCell: TopupTableViewCell, amount: Amount)
}

class TopupTableViewCell: UITableViewCell {
    
    // MARK: Properties
    private let sectionInsets: UIEdgeInsets = .init(top: 2, left: 16, bottom: 2, right: 16)
    private let minimumLineSpacing: CGFloat = 12
    private let itemHeight: CGFloat = 60
    private let serviceProviders = AppSetting.serviceProviders
    
    private let amounts: [Amount] = [
        Amount(money: 20000, kai: 66.6666),
        Amount(money: 50000, kai: 166.6666),
        Amount(money: 100000, kai: 266.66666),
        Amount(money: 200000, kai: 366.66666)
    ]
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.init(hex: "F1F2F4").cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private(set) lazy var inputPhoneNumberView: KAIInputTextFieldView = {
        let view = KAIInputTextFieldView(with: .default, title: "PHONE NO.", placeholder: "e.g 0903509786", keyboardType: .phonePad)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private let providerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = .init(hex: "364766")
        label.text = "SERVICE PROVIDER"
        
        return label
    }()
    
    private(set) lazy var providerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.sectionInset = sectionInsets
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.register(ProviderCollectionViewCell.self, forCellWithReuseIdentifier: ProviderCollectionViewCell.identifier)
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    private let comboboxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = .init(hex: "364766")
        label.text = "TOP UP AMOUNT"
        
        return label
    }()
    
    private lazy var combobox: KAICombobox = {
        let comboboxData: [ComboboxData] = amounts.map { item -> ComboboxData in
            let title = item.money.formatCurrencyToString(unit: .vnd, groupingSeparator: .comma, decimalSeparator: .dots)
            let sub = item.kai.formatCurrencyToString(unit: .kai, groupingSeparator: .comma, decimalSeparator: .dots)
            
            return ComboboxData(title: title, subTitle: sub)
        }
        let view = KAICombobox(with: comboboxData)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private(set) var providerSelectedIndex: Int = 0 {
        didSet {
            guard providerSelectedIndex != oldValue else { return }
            
            if let oldCell = providerCollectionView.cellForItem(at: IndexPath(row: oldValue, section: 0)) as? ProviderCollectionViewCell {
                oldCell.isProviderSelected = false
            }
            
            if let newCell = providerCollectionView.cellForItem(at: IndexPath(row: providerSelectedIndex, section: 0)) as? ProviderCollectionViewCell {
                newCell.isProviderSelected = true
            }
            
            delegate?.topupTableViewCellProvider(self, didSelectIndex: providerSelectedIndex)
        }
    }
    
    weak var delegate: TopupTableViewCellDelegate?
    
    // MARK: Life cycle's
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
            
        containerView.addSubview(inputPhoneNumberView)
        containerView.addSubview(providerLabel)
        containerView.addSubview(providerCollectionView)
        containerView.addSubview(comboboxLabel)
        containerView.addSubview(combobox)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            inputPhoneNumberView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            inputPhoneNumberView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            inputPhoneNumberView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            providerLabel.topAnchor.constraint(equalTo: inputPhoneNumberView.bottomAnchor, constant: 12),
            providerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            providerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            providerCollectionView.topAnchor.constraint(equalTo: providerLabel.bottomAnchor, constant: 4),
            providerCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            providerCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            providerCollectionView.heightAnchor.constraint(equalToConstant: itemHeight + sectionInsets.top + sectionInsets.bottom),
            
            comboboxLabel.topAnchor.constraint(equalTo: providerCollectionView.bottomAnchor, constant: 10),
            comboboxLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            comboboxLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            combobox.topAnchor.constraint(equalTo: comboboxLabel.bottomAnchor, constant: 4),
            combobox.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            combobox.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            combobox.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
    }
}

// MARK: KAITextFieldDelegate
extension TopupTableViewCell: KAITextFieldDelegate {

    func kAITextFieldDidChange(_ textField: UITextField, for view: UIView) {
        delegate?.topupTableViewCellPhoneValueChange(self, textField: textField)
    }
    
    func kAITextFieldShouldReturn(_ textField: UITextField, for view: UIView) -> Bool {
        return false
    }
    
    func kAITextFieldShouldClear(_ textField: UITextField, for view: UIView) -> Bool {
        return true
    }
}

// MARK: UICollectionViewDataSource
extension TopupTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceProviders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProviderCollectionViewCell.identifier, for: indexPath) as! ProviderCollectionViewCell
        
        switch indexPath.row {
        case 1:
            cell.configure(UIImage(named: "logo_mobifone"))
        case 2:
            cell.configure(UIImage(named: "logo_vinaphone"))
        default:
            cell.configure(UIImage(named: "logo_viettel"))
        }
        
        cell.isProviderSelected = providerSelectedIndex == indexPath.row
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension TopupTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (Constants.Device.screenBounds.width - (sectionInsets.left + sectionInsets.right + minimumLineSpacing * 2 + 40)) / 3
        
        return CGSize(width: width, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        providerSelectedIndex = indexPath.row
    }
}

// MARK: KAIComboboxDelegate
extension TopupTableViewCell: KAIComboboxDelegate {
    
    func kaiCombobox(_ kaiCombobox: KAICombobox, didSelectIndex index: Int) {
        let amount = amounts[index]
        delegate?.topupTableViewCellDidValueMoney(self, amount: amount)
    }
}
