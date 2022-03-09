//
//  BasicButton.swift
//  Birds of Istanbul
//
//  Created by Omer Faruk Aksoy on 1.03.2022.
//

import Foundation
import SwiftUI

struct BasicButton: View {
    
    var title: String
    var textColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Text(title)
            .frame(width: 280, height: 50)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.system(size: 20, weight: .bold, design: .default))
            .cornerRadius(10)
    }
}
