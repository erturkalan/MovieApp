//
//  UIView.swift
//  movieApp
//
//  Created by Ertürk Alan on 14.02.2023.
//

import Foundation
import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?,bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
            translatesAutoresizingMaskIntoConstraints = false
            if let top = top {
                topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
            }
            if let left = left {
                leftAnchor.constraint(equalTo: left, constant: padding.left).isActive = true
            }
            if let bottom = bottom {
                bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
            }
            if let right = right {
                rightAnchor.constraint(equalTo: right, constant: padding.right).isActive = true
            }
            
            if size.width != 0{
                widthAnchor.constraint(equalToConstant: size.width).isActive = true
            }
            if size.height != 0 {
                heightAnchor.constraint(equalToConstant: size.height).isActive = true
            }
        }
        
        func anchorWithCenter(centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor? , paddingX: CGFloat = 0,paddingY:CGFloat = 0, size: CGSize = .zero){
            translatesAutoresizingMaskIntoConstraints = false
            if let centerX = centerX {
                self.centerXAnchor.constraint(equalTo: centerX, constant: paddingX).isActive = true
            }
            if let centerY = centerY {
                self.centerYAnchor.constraint(equalTo: centerY, constant: paddingY).isActive = true
            }
            if size.width != 0{
                widthAnchor.constraint(equalToConstant: size.width).isActive = true
            }
            if size.height != 0 {
                heightAnchor.constraint(equalToConstant: size.height).isActive = true
            }
        }
}
