//
//  WeatherSDKDelegate.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//

public protocol WeatherSDKDelegate: AnyObject {
    func weatherSDKDidFinish()
    func weatherSDKDidFinishWithError(_ error: Error)
}
