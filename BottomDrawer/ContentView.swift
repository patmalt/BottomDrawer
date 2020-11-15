//
//  ContentView.swift
//  BottomDrawer
//
//  Created by Patrick Maltagliati on 11/15/20.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        BottomDrawer(main: Main(), detail: Detail())
    }
}

struct BottomDrawer<Main: View, Detail: View>: View {
    let main: () -> Main
    let detail: () -> Detail
    @State private var expanded: Bool = false

    init(main: Main, detail: Detail) {
        self.main = { main }
        self.detail = { detail }
    }

    init(@ViewBuilder main: @escaping () -> Main, @ViewBuilder detail: @escaping () -> Detail) {
        self.main = main
        self.detail = detail
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                main()
                detail()
                    .frame(height: proxy.size.height / (expanded ? 1.1 : 4))
                    .background(Blur().ignoresSafeArea())
                    .onTapGesture {
                        withAnimation { expanded.toggle() }
                    }
            }
        }
    }
}

struct Main: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.627003, longitude: -90.199402),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    var body: some View {
        Map(coordinateRegion: $region).ignoresSafeArea(.all, edges: .bottom)
    }
}

struct Blur: UIViewRepresentable { // https://medium.com/@edwurtle/blur-effect-inside-swiftui-a2e12e61e750
    var style: UIBlurEffect.Style = .systemUltraThinMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct Detail: View {
    var body: some View {
        HStack {
            VStack {
                Group {
                    Label("Hello, World", systemImage: "pencil")
                }
                .padding()
                Spacer()
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
