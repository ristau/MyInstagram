//
//  Functions.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/18/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import Foundation
import Dispatch

// function to use in HUD

func afterDelay(_ seconds: Double, closure: @escaping () -> ()) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
}

