//
//  Threading.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation

infix operator ~>

/** dispatch_after sec on main thread */

public func ~> ( time: TimeInterval, block: @escaping ()->() ) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: block)
}

/**
    Shortcut for dispatch after seconds
    ```
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), block)
    ```

    - Parameter time: Time in secods
    - Parameter block: Block to be executed

*/
