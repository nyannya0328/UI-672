//
//  Home.swift
//  UI-672
//
//  Created by nyannyan0328 on 2022/09/20.
//

import SwiftUI

struct Home: View {
    @State var currentImage : CustomShape = .cloud
    @State var PickerImage : CustomShape = .cloud
    
    @State var animteMorphy : Bool = false
    
    @State var trunOffImageMorpth : Bool = false
    
    @State var blurRadius : CGFloat = 0
    
    var body: some View {
       
        
        VStack{
            
            GeometryReader{proxy in
                
                let size = proxy.size
                
                Image("p1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width,height: size.height)
                    .overlay(content: {
                        
                        Rectangle()
                            .fill(.white)
                            .opacity(trunOffImageMorpth ? 1: 0)
                    })
                    .mask {
                        
                        Canvas { context, size in
                            
                            
                        
                            context.addFilter(.alphaThreshold(min: 0.3))
                            
                            context.addFilter(.blur(radius: blurRadius >= 20 ? 20 - (blurRadius - 20) : blurRadius))
                            
                            context.drawLayer { ctx in
                            
                                if let revovedImage = context.resolveSymbol(id: 1){
                                   
                                    ctx.draw(revovedImage, at: CGPoint(x: size.width / 2, y: size.height / 2),anchor: .center)
                                }
                            }
                            
                        } symbols: {
                            
                            ResolveView(currentImage: $currentImage)
                                .tag(1)
                        }
                        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
                            
                            
                            if animteMorphy{
                                
                                
                                if blurRadius <= 40{
                                    
                                    blurRadius += 0.5
                                    
                                    if blurRadius.rounded() == 20{
                                        
                                        currentImage = PickerImage
                                    }
                                    
                                    
                                    
                                }
                                
                                if blurRadius.rounded() == 40{
                                    
                                    animteMorphy = false
                                    blurRadius = 0
                                    
                                }
                                
                            }
                            
                        }

                        
                    }

                    
                
            }
            .frame(height: 400)
            
            
            Picker("", selection: $PickerImage) {
                
                ForEach(CustomShape.allCases,id:\.self){shape in
                    
                    
                    Image(systemName: shape.rawValue)
                        .tag(shape)
                    
                    
                }
                
            }
           
            .overlay {
                
                Rectangle()
                    .fill(.red)
                    .opacity(animteMorphy ? 0.01 : 0)
                
            }
            .pickerStyle(.segmented)
            .padding(13)
            .onChange(of: PickerImage) { newValue in
                animteMorphy = true
            }
            Toggle("Turn Off image morphy", isOn: $trunOffImageMorpth)
                .fontWeight(.semibold)
                .padding(.horizontal,5)
                .padding(.top,10)
            
            
          
        }
        .frame(maxHeight: .infinity,alignment: .top)
    }
}

struct ResolveView : View{
    
    @Binding var currentImage : CustomShape
    
    var body: some View{
        
        Image(systemName: currentImage.rawValue)
            .font(.system(size: 200))
            .animation(.interactiveSpring(response: 0.5,dampingFraction: 0.5,blendDuration: 0.6), value: currentImage)
            .frame(width: 300,height: 300)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
