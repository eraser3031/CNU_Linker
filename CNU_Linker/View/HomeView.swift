//
//  HomeView.swift
//  CNU_Linker
//
//  Created by Kimyaehoon on 31/08/2021.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    let zoomPlaceholder = "https://cnu-ac-kr.zoom.us/j/"
    var window = NSScreen.main?.visibleFrame
    
    @State var showAddView = false
    @State var lectureText = ""
    @State var zoomText = "https://cnu-ac-kr.zoom.us/j/"
    
    var body: some View {
        VStack(spacing: 28) {
            HStack(spacing: 24) {
                HStack(spacing: 4) {
                    Image("CNU_Logo_Color")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(4)
                        .background(Color.theme.background)
                        .clipShape(Circle())
                        .compositingGroup()
                    
                    Text("충남대 링크 바로가기")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                Link(destination: URL(string: "https://portal.cnu.ac.kr")!) {
                    Image(systemName: "house")
                        .font(Font.system(.title3, design: .default).weight(.bold))
                        .foregroundColor(.primary)
                }
                
                
                Link(destination: URL(string: "https://dcs-learning.cnu.ac.kr/std/myLecture")!) {
                    Image(systemName: "graduationcap")
                        .font(Font.system(.title3, design: .default).weight(.bold))
                        .foregroundColor(.primary)
                }
            }
            
            VStack(spacing: 20) {
                HStack {
                    
                    Button(action: {showAddView = true}) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                            Text("추가")
                        }
                        .font(Font.system(.title3, design: .default).weight(.bold))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showAddView){
                        addView
                    }
                    
                    Spacer()
                }
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 16) {
                        ForEach(items) { item in
                            if let _ = URL(string: item.zoomLink ?? "") {
                                itemView(item: item)
                            }
                        }
                    }
                }
                .dividerShadow()
                .floatShadow()
                
                Spacer()
            }
            
            HStack {
                Spacer()
                Text("referenced by UnivClick")
                    .foregroundColor(Color(.lightGray))
                    .font(.footnote)
            }
        }
        .padding()
        .frame(width: window!.width / 2, height: window!.height / 1.5)
        .background(Color.theme.background)
    }
    
    //  MARK: - Components
    
    private func itemView(item: Item) -> some View {
        
        HStack(spacing: 20) {
            Link(destination: URL(string: item.zoomLink ?? "")! ) {
                Group {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name ?? "")
                            .font(Font.system(.title3, design: .default).weight(.medium))
                        
                        Text(item.zoomLink ?? "")
                            .font(Font.system(.subheadline, design: .default).weight(.medium))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .contentShape(Rectangle())
                .foregroundColor(.primary)
            }
            
            Image(systemName: "xmark.circle.fill")
                .font(Font.system(.title2, design: .default).weight(.medium))
                .foregroundColor(.gray)
                .onTapGesture {
                    withAnimation {
                        deleteItem(item: item)
                    }
                }
        }
        .padding(16)
        .background(Color.theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
//        .overlay(
//            RoundedRectangle(cornerRadius: 8, style: .continuous)
//                .stroke(Color.theme.divider, lineWidth: 1)
//                .padding(1)
//        )
        .compositingGroup()
        .padding(.trailing, 8)
        
    }
    
    private var addView: some View {
        VStack {
            HStack {
                Text("취소")
                    .onTapGesture {
                        showAddView = false
                    }
                Spacer()
                
                Button(action: {
                    withAnimation {
                        addItem()
                        clear()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("추가")
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .font(Font.system(.title3, design: .default).weight(.semibold))
            .padding(.bottom, 16)
            
            CustomSection(label: "강의 이름") {
                TextField("건축응용설계2", text: $lectureText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .modifier(CustomTextFieldStyle())
            }
            
            CustomSection(label: "Zoom 링크") {
                TextField("", text: $zoomText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .modifier(CustomTextFieldStyle())
            }
            
            Spacer()
        }
        .padding()
        .frame(width: window!.width / 4, height: window!.height / 3)
    }
    
    //  MARK: - Functions
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.id = UUID().uuidString
            newItem.name = lectureText
            newItem.zoomLink = zoomText

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItem(item: Item) {
        viewContext.delete(item)
        do {
            try viewContext.save()
        } catch let error {
            print("error in \(#function) : \(error)")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func clear() {
        lectureText = ""
        zoomText = zoomPlaceholder
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct CustomTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color.theme.groupedBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct CustomSection<ContentView>: View where ContentView: View {
    
    let label: LocalizedStringKey
    let content: () -> ContentView
    
    init(label: LocalizedStringKey,
         @ViewBuilder content: @escaping () -> ContentView) {
        self.label = label
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(label)
                .foregroundColor(Color.primary)
                .font(Font.system(.subheadline, design: .default).weight(.semibold))
            
            content()
        }
    }
}

