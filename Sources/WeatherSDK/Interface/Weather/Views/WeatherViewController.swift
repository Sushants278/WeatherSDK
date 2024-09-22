//
//  WeatherViewController.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//
import UIKit
import SwiftUI
import Foundation

public class WeatherViewController: UIViewController {
    // MARK: - Properties
    private var cityName: String
    private var showWeatherView: Binding<Bool>
    private weak var delegate: WeatherSDKDelegate?

    // MARK: - Initializers
   public init(cityName: String, showWeatherView: Binding<Bool>, delegate: WeatherSDKDelegate?) {
        self.cityName = cityName
        self.showWeatherView = showWeatherView
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let weatherView = WeatherView(cityName: cityName, showWeatherView: showWeatherView, delegate: delegate)
        let hostingController = UIHostingController(rootView: weatherView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}
