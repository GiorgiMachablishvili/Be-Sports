//
//  NonPropagatingButton.swift
//  Betus
//
//  Created by Gio's Mac on 02.12.24.
//

import UIKit

class NonPropagatingButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.contains(point)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.next?.touchesCancelled(touches, with: event)
    }
}
