//
//  HealthKitSetupAssistant.swift
//  MedTracker
//
//  Created by MacBook Air on 21.07.2020.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import Foundation
import HealthKit

public class HealthKitSetupAssistant {
  
  private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
  }
  
  class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
          completion(false, HealthkitSetupError.notAvailableOnDevice)
          return
        }
    
    guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
    }
    
    let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex, activeEnergy, HKObjectType.workoutType()]
        
    let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                                             bloodType,
                                                                             biologicalSex,
                                                                             bodyMassIndex,
                                                                             height,
                                                                             bodyMass,
                                                                             HKObjectType.workoutType()]
    
    HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                         read: healthKitTypesToRead) { (success, error) in
      completion(success, error)
    }

    
  }
}
