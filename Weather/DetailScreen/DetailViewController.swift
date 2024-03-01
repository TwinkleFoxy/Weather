//
//  DetailViewController.swift
//  Weather
//
//  Created by Алексей Однолько on 20.02.2024.
//

import UIKit
import RxSwift
import RxRelay

final class DetailViewController: UIViewController {
    
    //MARK: - UI
    private lazy var tempLabel = UILabel()
    private lazy var windKphLabel = UILabel()
    private lazy var windDegreeLabel = UILabel()
    private lazy var windDirLabel = UILabel()
    private lazy var precipMmLabel = UILabel()
    private lazy var humidityLabel = UILabel()
    private lazy var feelslikeCLabel = UILabel()
    private lazy var uvLabel = UILabel()
    private lazy var sunriseLabel = UILabel()
    private lazy var sunsetLabel = UILabel()
    private lazy var moonriseLabel = UILabel()
    private lazy var moonsetLabel = UILabel()
    private lazy var precipmoonPhaseMmLabel = UILabel()
    
    
    //MARK: - Properties
    private var viewModel: DetailViewModel
    private let bag = DisposeBag()
    
    
    
    init(forecast: String) {
        viewModel = DetailViewModel(city: forecast)
        super.init(nibName: nil, bundle: nil)
        setupUI()
        setupTheme()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
}

private extension DetailViewController {
    
    func setupUI() {
        
        view.addSubview(tempLabel)
        view.addSubview(windKphLabel)
        view.addSubview(windDegreeLabel)
        view.addSubview(windDirLabel)
        view.addSubview(precipMmLabel)
        view.addSubview(humidityLabel)
        view.addSubview(feelslikeCLabel)
        view.addSubview(uvLabel)
        view.addSubview(sunriseLabel)
        view.addSubview(sunsetLabel)
        view.addSubview(moonriseLabel)
        view.addSubview(moonsetLabel)
        view.addSubview(precipmoonPhaseMmLabel)
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        windKphLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        windDegreeLabel.snp.makeConstraints { make in
            make.top.equalTo(windKphLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        windDirLabel.snp.makeConstraints { make in
            make.top.equalTo(windDegreeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        precipMmLabel.snp.makeConstraints { make in
            make.top.equalTo(windDirLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(precipMmLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        feelslikeCLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        uvLabel.snp.makeConstraints { make in
            make.top.equalTo(feelslikeCLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        sunriseLabel.snp.makeConstraints { make in
            make.top.equalTo(uvLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        sunsetLabel.snp.makeConstraints { make in
            make.top.equalTo(sunriseLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        moonriseLabel.snp.makeConstraints { make in
            make.top.equalTo(sunsetLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        moonsetLabel.snp.makeConstraints { make in
            make.top.equalTo(moonriseLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        precipmoonPhaseMmLabel.snp.makeConstraints { make in
            make.top.equalTo(moonsetLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
    }
    
    func setupTheme() {
        let isNightMode = Calendar.current.isNightTime()
        if isNightMode {
            setupDarkTheme()
        } else {
            setupLightTheme()
        }
    }
    
    
    func bind() {
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.tempLabel.text = weatherExtendedModel.temp
                }
            }
            .disposed(by: bag)
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.windKphLabel.text = weatherExtendedModel.windKph
                }
            }
            .disposed(by: bag)
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.windDegreeLabel.text = weatherExtendedModel.windDegree
                }
            }
            .disposed(by: bag)
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.windDirLabel.text = weatherExtendedModel.windDir
                }
            }
            .disposed(by: bag)
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.precipMmLabel.text = weatherExtendedModel.precipMm
                }
            }
            .disposed(by: bag)
        
        
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.humidityLabel.text = weatherExtendedModel.humidity
                }
            }
            .disposed(by: bag)
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.feelslikeCLabel.text = weatherExtendedModel.feelslikeC
                }
            }
            .disposed(by: bag)
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.uvLabel.text = weatherExtendedModel.uv
                }
            }
            .disposed(by: bag)
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.sunriseLabel.text = weatherExtendedModel.sunrise
                }
            }
            .disposed(by: bag)
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.sunsetLabel.text = weatherExtendedModel.sunset
                }
            }
            .disposed(by: bag)
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.moonriseLabel.text = weatherExtendedModel.moonrise
                }
            }
            .disposed(by: bag)
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.moonsetLabel.text = weatherExtendedModel.moonset
                }
            }
            .disposed(by: bag)
        
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .bind { [weak self] weatherExtendedModel in
                if let weatherExtendedModel = weatherExtendedModel {
                    self?.precipmoonPhaseMmLabel.text = weatherExtendedModel.precipmoonPhaseMm
                }
            }
            .disposed(by: bag)
    }
    
}

private extension DetailViewController {
    
    // Светлая тема
    func setupLightTheme() {
        view.backgroundColor = .white
        tempLabel.textColor = .black
        windKphLabel.textColor = .black
        windDegreeLabel.textColor = .black
        windDirLabel.textColor = .black
        precipMmLabel.textColor = .black
        humidityLabel.textColor = .black
        feelslikeCLabel.textColor = .black
        uvLabel.textColor = .black
        sunriseLabel.textColor = .black
        sunsetLabel.textColor = .black
        moonriseLabel.textColor = .black
        moonsetLabel.textColor = .black
        precipmoonPhaseMmLabel.textColor = .black
    }
    
    // Темная тема
    func setupDarkTheme() {
        view.backgroundColor = .black
        tempLabel.textColor = .white
        windKphLabel.textColor = .white
        windDegreeLabel.textColor = .white
        windDirLabel.textColor = .white
        precipMmLabel.textColor = .white
        humidityLabel.textColor = .white
        feelslikeCLabel.textColor = .white
        uvLabel.textColor = .white
        sunriseLabel.textColor = .white
        sunsetLabel.textColor = .white
        moonriseLabel.textColor = .white
        moonsetLabel.textColor = .white
        precipmoonPhaseMmLabel.textColor = .white
    }
}
