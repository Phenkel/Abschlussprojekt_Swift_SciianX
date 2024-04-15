//
//  ProfileViewFilter.swift
//  SciianX
//
//  Created by Philipp Henkel on 22.01.24.
//

import Foundation

enum ProfileViewFilter: Int, CaseIterable, Identifiable {
    case xpression, xchange, xtacts
    
    var title: String {
        switch self {
        case .xchange: return "Xchange"
        case .xpression: return "Xpressions"
        case .xtacts: return "Xtacts"
        }
    }
    
    var id: Int { return self.rawValue}
}
