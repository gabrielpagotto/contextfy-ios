//
//  HomeController.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 10/10/24.
//

import Foundation

class HomeController : ObservableObject {
    
    @Published
    var firstGenderAndArtistSelectionPresented = false
	@Published
	var context = nil as ContextModel?
}
