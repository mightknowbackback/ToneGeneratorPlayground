//
//  ContentView.swift
//  ToneGeneratorPlayground
//
//  Created by mightknow on 11/6/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TestView().environmentObject(ViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
