//
//  ContentView.swift
//  casinoApp
//
//  Created by IrisDarka on 28/11/22.
//

import SwiftUI

struct ContentView: View {
    private var array = ["apple", "cherry", "star"]
    @State private var option1 = "apple"
    @State private var option2 = "cherry"
    @State private var option3 = "star"
    @State private var points = 1500
    var body: some View {
        ZStack{
            Image("").ignoresSafeArea()
            VStack{
                Spacer()
                Text("Casino App")
                    .font(.title)
                    .foregroundColor(.black)
                Spacer()
                Text(String(points))
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                HStack(){
                    Image(option1)
                        .imageScale(.small)
                    Image(option2)
                        .imageScale(.small)
                    Image(option3)
                        .imageScale(.small)

                }.padding()
                Spacer()
                Button {
                    let optionNum1 = Int.random(in: 0...2)
                    let optionNum2 = Int.random(in: 0...2)
                    let optionNum3 = Int.random(in: 0...2)
                    option1 = array[optionNum1]
                    option2 = array[optionNum2]
                    option3 = array[optionNum3]
                    if option1 == option2 && option2 == option3{
                        points += 15
                    }else{
                        if points > 0{
                            points -= 15
                        }
                    }
                } label: {
                    Text("Spin")
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
