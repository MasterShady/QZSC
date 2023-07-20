//
//  FeedBackView.swift
//  QZSC
//
//  Created by 刘思源 on 2023/7/19.
//

import SwiftUI
import PhotosUI


struct FeedBackView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var questionDescription : String = ""
    @State var contact: String = ""
    @State private var selectedImages: [UIImage] = .init()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            QuestionView(questionDescription: $questionDescription)
            ImagePickView(selectedImages: $selectedImages)
            ContactView(contact: $contact)
            Spacer()
            Button {
                commit()
            } label: {
                Text("提交").font(.system(size: 14, weight: .semibold)).foregroundColor(.white).frame(width:kScreenWidth - 32, height: 48).background(Color.init(hex: 0x333333)).cornerRadius(24)
            }

            
        }.navigationTitle("意见反馈").navigationBarTitleDisplayMode(.inline).navigationBarBackButtonHidden(true) //隐藏系统的导航返回按钮
            .navigationBarItems(leading: Button(action: { //自定义导航的返回按钮
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("back_arrow") //导航返回按钮图标
            })).padding(.init(top: 12, leading: 16, bottom: 12, trailing: 16)).background(Color.init(hex: 0xF6F8FA)).hiddenTabBar()
    }
    
    func commit(){
        if questionDescription.count < 15{
            UMToast.show("请填写15字以上描述")
            return
        }
        if contact.isEmpty{
            UMToast.show("请填联系方式")
            return
        }
        UMToast.show("感谢您的提交,我们会及时处理~")
        presentationMode.wrappedValue.dismiss()
    }
}

struct QuestionView: View {
    @Binding var questionDescription: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("问题描述（必填）").font(.system(size: 16, weight: .semibold)).foregroundColor(.init(hex: 0x000000))
            TextEditor(text: $questionDescription).placeholder(when: questionDescription.isEmpty) {
                Text("请填写15字以上描述，以便我们更好地为您提供帮助~").font(.system(size: 16)).foregroundColor(.init(hex: 0x868A96)).padding(.init(top: 0, leading: 5, bottom: 30, trailing: 0))


            }.font(.system(size: 16)).foregroundColor(.init(hex: 0x333333)).frame(height: 80)
                            
                            
            
        }
        .padding(.init(top: 12, leading: 16, bottom: 24, trailing: 16)).background(.white).cornerRadius(8)
    }
}

struct ImagePickView: View {
    @Binding var selectedImages: [UIImage]
    @State private var showImagePicker = false
    
    var loopList : [Int]{
        Array(0..<min(3,selectedImages.count + 1))
    }
    
    //@Binding var questionDescription: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("上传图片（最多3张）").font(.system(size: 16, weight: .semibold)).foregroundColor(.init(hex: 0x000000))
            
            HStack {
                ForEach(Array(loopList.enumerated()),id: \.offset) { idx, element in
                    if idx == selectedImages.count{
                        Button {
                            showImagePicker = true
                        } label: {
                            Image("feedback_plus")
                        }.sheet(isPresented: $showImagePicker) {
                            // Present the image picker as a sheet
                            ImagePicker(images: $selectedImages)
                        }.frame(width: 80,height: 80)

                    }else{
                        ZStack {
                            Image(uiImage: selectedImages[idx]).resizable()
                        }.frame(width: 80,height: 80)
                    }
                }
                Spacer()
            }
            
                            
                            
            
        }.padding(.init(top: 12, leading: 16, bottom: 12, trailing: 16)).frame(height: 154).background(.white).cornerRadius(8)
    }
}


struct ContactView: View{
    @Binding var contact: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("联系方式（必填）").font(.system(size: 16, weight: .semibold)).foregroundColor(.init(hex: 0x000000))
            TextField("", text: $contact).placeholder(when: contact.isEmpty, alignment: .topLeading) {
                Text("请填写您的微信或者手机号码").font(.system(size: 16)).foregroundColor(.init(hex: 0x868A96)).disabled(true)
            }
            
        }.padding(.init(top: 12, leading: 16, bottom: 24, trailing: 16)).background(.white).cornerRadius(8)
    }
}



struct FeedBackView_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationView {
            FeedBackView()
        //}
        
    }
}


