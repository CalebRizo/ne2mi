//
//  VWelcomeView.swift
//  Ne2Mi
//
//  Created by Carlos Uribe on 23/06/18.
//  Copyright © 2018 AngelHack. All rights reserved.
//

import UIKit
import CoreMotion


class VWelcomeView:UIView{
    weak var controller:CWelcomeController!
    weak var gyroData:UILabel!
    weak var accelData:UILabel!
    weak var motionData:UILabel!
    weak var timer:Timer!
    weak var startButton:UIButton!
    let motionManager:CMMotionManager = CMMotionManager()
    let motionActivityManager:CMMotionActivityManager = CMMotionActivityManager()
    let pedometer:CMPedometer = CMPedometer()
    var timerCounter:Int = 0
    let notification:UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    private var accelerationX:[Double] = []
    private var accelerationY:[Double] = []
    private var accelerationZ:[Double] = []
    private let urlString:String = "https://08oio458y8.execute-api.us-east-1.amazonaws.com/dev"
    private let kConstantTime:Double = 1
    private var tmpSize:CGFloat = 1.0
    private var shouldStartUpdating:Bool = false
    private var startDate:Date? = nil

    convenience init(controller:CWelcomeController){
        self.init()
        clipsToBounds = false
        backgroundColor = .white

        self.controller = controller
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()

        let gyroData:UILabel = UILabel()
        gyroData.translatesAutoresizingMaskIntoConstraints = false
        gyroData.clipsToBounds = false
        gyroData.textColor = .black
        gyroData.textAlignment = .center
        self.gyroData = gyroData

        let motionData:UILabel = UILabel()
        motionData.translatesAutoresizingMaskIntoConstraints = false
        motionData.clipsToBounds = false
        motionData.textColor = .black
        motionData.textAlignment = .center
        motionData.font = motionData.font.withSize(100)
        self.motionData = motionData

        let accelData:UILabel = UILabel()
        accelData.translatesAutoresizingMaskIntoConstraints = false
        accelData.clipsToBounds = false
        accelData.textColor = .black
        accelData.textAlignment = .center
        self.accelData = accelData

        let timer:Timer = Timer()
        self.timer = timer

        let startButton:UIButton = UIButton()
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.clipsToBounds = false
        startButton.setTitle("Comenzar", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.addTarget(
            self,
            action: #selector(startMotionDetection(sender:)),
            for: .touchUpInside)
        self.startButton = startButton

        addSubview(accelData)
        addSubview(gyroData)
        addSubview(startButton)
        addSubview(motionData)

        let views:[String : Any] = [
            "motion":motionData,
            "start":startButton,
            "gyro":gyroData,
            "accel":accelData]

        let metrics:[String : CGFloat] = [:]

        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:"H:|-0-[gyro]-0-|",
            options:[],
            metrics:metrics,
            views:views))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:"V:|-60-[gyro(50)]",
            options:[],
            metrics:metrics,
            views:views))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:"H:|-0-[accel]-0-|",
            options:[],
            metrics:metrics,
            views:views))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:"V:[gyro]-10-[accel(50)]",
            options:[],
            metrics:metrics,
            views:views))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:"H:|-0-[motion]-0-|",
            options:[],
            metrics:metrics,
            views:views))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:"V:[accel]-10-[motion(100)]",
            options:[],
            metrics:metrics,
            views:views))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:"H:|-0-[start]-0-|",
            options:[],
            metrics:metrics,
            views:views))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:"V:[start(40)]-100-|",
            options:[],
            metrics:metrics,
            views:views))
    }

    @objc func startMotionDetection(sender:UIButton){
        timerCounter = 0
        motionData.text = "0"
        accelData.text = "Espera..."
        shouldStartUpdating = !shouldStartUpdating
        shouldStartUpdating ? (onStart()) : (onStop())
    }

    @objc func update(){
        if timerCounter == 20{
            notification.notificationOccurred(.success)
            timerCounter = 0
            timer.invalidate()
            onStop()
            self.motionData.text = "\(timerCounter)"
            UIView.animate(withDuration: 1.0) {
                self.motionData.transform = CGAffineTransform(scaleX: self.tmpSize * 4, y: self.tmpSize * 4)
            }
            self.motionData.transform = CGAffineTransform(scaleX: self.tmpSize, y: self.tmpSize)
            let _:MRequestManager = MRequestManager(urlString: urlString, data: makePackage())
        }
        else{
            self.motionData.text = "\(timerCounter)"

            UIView.animate(withDuration: 1.0) {
                self.motionData.transform = CGAffineTransform(scaleX: self.tmpSize * 4, y: self.tmpSize * 4)
            }
            self.motionData.transform = CGAffineTransform(scaleX: self.tmpSize, y: self.tmpSize)
            if let accelerometerData = motionManager.accelerometerData {
                accelerationX.append(accelerometerData.acceleration.x)
                accelerationY.append(accelerometerData.acceleration.y)
                accelerationZ.append(accelerometerData.acceleration.z)
            }

            self.timerCounter += 1
        }

//        if let gyro = motionManager.gyroData {
//            gyroData.text = "\(gyro)"
//        }
//
//        if let deviceMotion = motionManager.deviceMotion {
//            motionData.text = "\(deviceMotion)"
//        }
    }

    func makePackage() -> [String : [Any]]{
        let body:[String : [Any]] = [
            "x":accelerationX,
            "y":accelerationY,
            "z":accelerationZ,
            "time":[kConstantTime]]

        return body
    }

    private func startTrackingActivityType() {
        motionActivityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in

            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    self?.accelData.text = "Caminando"
                } else if activity.stationary {
                    self?.accelData.text = "Comienza"
                    self?.notification.notificationOccurred(.success)
                    self?.timer = Timer.scheduledTimer(
                        timeInterval: (self?.kConstantTime)!,
                        target: self!,
                        selector: #selector(self?.update),
                        userInfo: nil, repeats: true)

                } else if activity.running {
                    self?.accelData.text = "Corriendo"
                } else if activity.automotive {
                    self?.accelData.text = "Automovil"
                }
            }
        }
    }

    private func onStart() {
        startButton.setTitle("Detener", for: .normal)
        startDate = Date()
        checkAuthorizationStatus()
        startUpdating()
    }

    private func onStop() {
        startButton.setTitle("Comenzar", for: .normal)
        if timer != nil{
            timer.invalidate()
        }
        shouldStartUpdating = false
        timerCounter = 0
        accelData.text = "Terminado"
        startDate = nil
        stopUpdating()
    }

    private func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        } else {
            gyroData.text = "No disponible"
        }

        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
//            updateStepsCountLabelUsing(startDate: startDate!)
        } else {
            gyroData.text = "No disponible"
        }
    }

    private func checkAuthorizationStatus() {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied:
            onStop()
            accelData.text = "No diponible"
            gyroData.text = "No disponible"
        default:break
        }
    }

    private func stopUpdating() {
        motionActivityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
    }

    private func on(error: Error) { }

//    private func updateStepsCountLabelUsing(startDate: Date) {
//        pedometer.queryPedometerData(from: startDate, to: Date()) {
//            [weak self] pedometerData, error in
//            if let error = error {
//                self?.on(error: error)
//            } else if let pedometerData = pedometerData {
//                DispatchQueue.main.async {
//                    UIView.animate(withDuration: 1.0) {
//                        self?.timerCounter = Int(truncating: pedometerData.numberOfSteps)
//                        print(self?.timerCounter)
//                        self?.motionData.text = String(describing: pedometerData.numberOfSteps.stringValue)
//                        self?.motionData.transform = CGAffineTransform(scaleX: (self?.tmpSize)! * 4, y: (self?.tmpSize)! * 4)
//                    }
//                    self?.motionData.transform = CGAffineTransform(scaleX: (self?.tmpSize)!, y: (self?.tmpSize)!)
//                }
//            }
//        }
//    }

    private func startCountingSteps() {
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            DispatchQueue.main.async {
                self?.gyroData.text = pedometerData.numberOfSteps.stringValue

                UIView.animate(withDuration: 1.0) {
                    self?.timerCounter = Int(truncating: pedometerData.numberOfSteps)
                    self?.gyroData.transform = CGAffineTransform(scaleX: (self?.tmpSize)! * 4, y: (self?.tmpSize)! * 4)
                }
                self?.gyroData.transform = CGAffineTransform(scaleX: (self?.tmpSize)!, y: (self?.tmpSize)!)
            }
        }
    }

}
