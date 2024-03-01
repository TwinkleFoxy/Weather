//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Алексей Однолько on 20.02.2024.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift

final class WeatherTableViewCell: BaseTableCell {
    
    // MARK: - UI
    private lazy var temperatureLabel = UILabel()
    private lazy var cityLabel = UILabel()
    private lazy var countryLabel = UILabel()
    private lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var conditionWatherLabel = UILabel()
    private lazy var likeButton = UIButton()
    
    //MARK: - Properties
    private let viewModel = WeatherTableCellViewModel()
    private let bag = DisposeBag()
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setup() {
        setupUI()
        setupTheme()
        bind()
    }
    
    func configure(weatherCell: WeatherCurrentModel) {
        viewModel.weatherCurrentModel.accept(weatherCell)
//        [CityStorageModel(cityName: "Toronto", lat: 43.67, lon: -79.42)]
        temperatureLabel.text = String(weatherCell.current.temp_c)
        cityLabel.text = weatherCell.location.name
        countryLabel.text = weatherCell.location.country
        conditionWatherLabel.text = weatherCell.current.condition.text
        let iconName = weatherCell.current.condition.icon.reciveLastComponent()
        weatherIconImageView.image = UIImage(named: iconName)?.resize(to: CGSize(width: 32, height: 32))
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func setupLightTheme() {
        super.setupLightTheme()
        
        temperatureLabel.textColor = .black
        cityLabel.textColor = .black
        countryLabel.textColor = .black
        conditionWatherLabel.textColor = .black
    }
    
    override func setupDarkTheme() {
        super.setupDarkTheme()
        
        temperatureLabel.textColor = .white
        cityLabel.textColor = .white
        countryLabel.textColor = .white
        conditionWatherLabel.textColor = .white
    }
}

private extension WeatherTableViewCell {
    func setupUI() {
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(cityLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(conditionWatherLabel)
        contentView.addSubview(likeButton)
        
        let countryCityStackView = UIStackView(arrangedSubviews: [countryLabel, cityLabel])
               countryCityStackView.axis = .vertical
               countryCityStackView.spacing = 8
               
               let weatherInfoStackView = UIStackView(arrangedSubviews: [weatherIconImageView, conditionWatherLabel])
               weatherInfoStackView.axis = .vertical
               weatherInfoStackView.spacing = 8
               
               let mainStackView = UIStackView(arrangedSubviews: [countryCityStackView, weatherInfoStackView, temperatureLabel])
               mainStackView.axis = .horizontal
               mainStackView.spacing = 16

               contentView.addSubview(mainStackView)
               
               mainStackView.snp.makeConstraints { (make) in
                   make.centerY.equalTo(contentView.snp.centerY)
                   make.leading.equalTo(contentView.snp.leading).offset(16)
                   make.trailing.lessThanOrEqualTo(contentView.snp.trailing).offset(-16)
               }
               
               let stackViewRightContainer = UIStackView(arrangedSubviews: [UIView(), likeButton])
               stackViewRightContainer.axis = .horizontal

               contentView.addSubview(stackViewRightContainer)

               stackViewRightContainer.snp.makeConstraints { (make) in
                   make.leading.greaterThanOrEqualTo(mainStackView.snp.trailing).offset(16)
                   make.trailing.equalTo(contentView.snp.trailing).offset(-16)
                   make.centerY.equalTo(contentView.snp.centerY)
               }
    }
    
    func bind() {
        
        Observable.combineLatest(viewModel.cityStorageModel, viewModel.weatherCurrentModel)
            .map { [weak self] in
                if let weatherCurrentModel = self?.viewModel.weatherCurrentModel {
                    return $0.0.contains { $0.id == weatherCurrentModel.value?.location.id }
                } else { return false }
            }
            .bind { [weak self] in
                self?.viewModel.likeStatus.accept($0)
            }
            .disposed(by: bag)
        
        viewModel.likeStatus
            .bind { [weak self] in
                if let heartImage = UIImage(named: "heart")?.resize(to: CGSize(width: 32, height: 32)),
                    let heartFillImage = UIImage(named: "heartFill")?.resize(to: CGSize(width: 32, height: 32)) {
                    self?.likeButton.setImage( $0 ? heartFillImage : heartImage, for: .normal)
                }
            }
            .disposed(by: bag)
        
        StorageService.shared.cityStorageModel
            .bind { [weak self] in
                self?.viewModel.cityStorageModel.accept($0)
            }
            .disposed(by: bag)
    }
}

private extension WeatherTableViewCell {
    @objc func likeButtonTapped(_ sender: UIButton) {
        viewModel.likeButtonTapped()
    }
}
