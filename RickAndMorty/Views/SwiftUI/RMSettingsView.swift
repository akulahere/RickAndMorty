//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 03.03.2023.
//

import SwiftUI

struct RMSettingsView: View {
  
  let viewModel: RMSettingsViewViewModel
  
  init(viewModel: RMSettingsViewViewModel) {
    self.viewModel = viewModel
  }
  
  
  var body: some View {
    List(viewModel.cellViewModels) { vm in
      HStack {
        if let image = vm.image {
          Image(uiImage: image)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .foregroundColor(.white)
            .padding(8)
            .background(Color(vm.iconContainerColor))
            .cornerRadius(6)
        }
        Text(vm.title)
          .padding(.leading, 10)
        Spacer()
      }
      .padding(.bottom, 3)
      .onTapGesture {
        vm.onTapHandler(vm.type)
      }
      
    }
    
  }
}

struct RMSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({ setting in
      return RMSettingsCellViewModel(type: setting) { option in
        
      }
    })))
  }
}
