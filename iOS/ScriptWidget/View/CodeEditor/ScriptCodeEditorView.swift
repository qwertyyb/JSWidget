//
//  ScriptCodeEditorView.swift
//  ScriptWidget
//
//  Created by everettjf on 2020/10/24.
//

import SwiftUI
import UIKit
import Combine

enum ScriptCodeEditorViewMode {
    case creator
    case editor
}

struct ScriptCodeEditorNavButtonView: View {
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: image)
                .font(.title3)
        }
    }
}


class ScriptCodeEditorViewDataObject : ObservableObject {
    
    @Published var scriptModel: ScriptModel
    
    init(scriptModel: ScriptModel) {
        self.scriptModel = scriptModel
        
        NotificationCenter.default.addObserver(forName: ScriptWidgetHomeViewDataObject.scriptRenameNotification, object: nil, queue: OperationQueue.main) { (noti) in
            
            guard let newName = noti.userInfo?["newName"] as? String else { return }
            
            self.scriptModel = ScriptModel(package:sharedScriptManager.getScriptPackage(packageName: newName))
        }
    }
}

struct ScriptCodeEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var dataObject: ScriptCodeEditorViewDataObject
    let mode: ScriptCodeEditorViewMode
    let actionCreate: (() -> Void)?
    
    @State var name: String = ""
    
    @State var showRunnerView = false
    @State var showEditAttributesView = false
    @State var showShareActivity = false
    @State var showResourceCodeView = false
    @State var showDocsOverlay = false
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isSoftwareKeyboard = false
    
    init(mode: ScriptCodeEditorViewMode, scriptModel: ScriptModel) {
        self.mode = mode
        self.dataObject = ScriptCodeEditorViewDataObject(scriptModel: scriptModel)
        self.actionCreate = nil
    }
    
    init(mode: ScriptCodeEditorViewMode, scriptModel: ScriptModel, actionCreate: @escaping () -> Void) {
        self.mode = mode
        self.dataObject = ScriptCodeEditorViewDataObject(scriptModel: scriptModel)
        self.actionCreate = actionCreate
    }
    
    var codeeditor: some View {
        ScriptPackageEditorView(model: dataObject.scriptModel, filePath: dataObject.scriptModel.package.jsxPath)
            .onDisappear {
                ScriptWidgetTimelineRefresher.requestReload(immediate: true)
            }
    }
    
    func showAlert(_ message: String) {
        alertMessage = message
        showingAlert = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            codeeditor
            floatingToolbar
        }
        // NOTE: 只忽略 .container 安全区域（硬件刘海/home indicator），保留 .keyboard 安全区域。
        // 这样软键盘弹出时 SwiftUI 自动将悬浮工具栏推到键盘上方，无需手动计算键盘高度。
        // 如果用 .all 则需要自行监听键盘通知并计算 padding，但 padding(.bottom) 的参考基准
        // 在真机和模拟器上表现不一致（真机上存在约 22pt 的偏差），极难对齐。
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarTitle(self.dataObject.scriptModel.name, displayMode: .inline)
        .toolbar {
            if self.mode == .creator {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        DispatchQueue.main.async {
                            if let action = self.actionCreate {
                                action()
                            }
                        }
                    } label: {
                        Image(systemName: "plus.square")
                            .font(.title3)
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        // NOTE: 硬件键盘连接时 iOS 仍会弹出 accessory bar（~44pt），触发 keyboardWillShow。
        // 此时 SwiftUI 的键盘安全区域不足以将工具栏推到 accessory bar 上方，
        // 所以通过 visibleHeight > 100 区分软键盘（需要缩小 padding 避免叠加过多）
        // 和硬件键盘 accessory bar（保持 insetBottom + 12 让工具栏在其上方）。
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let visibleHeight = UIScreen.main.bounds.height - frame.origin.y
                isSoftwareKeyboard = visibleHeight > 100
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isSoftwareKeyboard = false
        }
    }

    var previewView: some View {
        ScriptCodePreviewView(model: dataObject.scriptModel)
    }

    var floatingToolbar: some View {
        HStack {
            HStack(spacing: 20) {
                Button {
                    self.showResourceCodeView.toggle()
                } label: {
                    Image(systemName: "book")
                        .font(.system(size: 16, weight: .medium))
                }
                .sheet(isPresented: $showResourceCodeView) {
                    ResourceCodeView(model: dataObject.scriptModel)
                }

                Button {
                    self.showDocsOverlay = true
                } label: {
                    Image(systemName: "doc.text")
                        .font(.system(size: 16, weight: .medium))
                }
                .sheet(isPresented: $showDocsOverlay) {
                    DocsOverlayView()
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                }
            }

            Spacer()

            HStack(spacing: 20) {
                if self.mode != .creator {
                    if #available(iOS 16.1, *) {
                        Button {
                            let buildResult = sharedScriptManager.buildScriptPackage(package: self.dataObject.scriptModel.package)
                            print("build result = \(buildResult)")
                            sharedLiveActivityManager.create(scriptName: self.dataObject.scriptModel.name, scriptParameter: "")
                            showAlert("Lock screen live activity created :)")
                        } label: {
                            Image(systemName: "lock")
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                }

                Button {
                    self.showRunnerView = true
                } label: {
                    Image(systemName: "play.fill")
                        .font(.system(size: 16, weight: .medium))
                }
                .sheet(isPresented: $showRunnerView, content: {
                    previewView
                })
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.thickMaterial)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.primary.opacity(0.1), lineWidth: 0.5))
        .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
        .padding(.horizontal, 16)
        .padding(.bottom, {
            if isSoftwareKeyboard {
                return CGFloat(12)
            }
            let insetBottom = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows.first?.safeAreaInsets.bottom ?? 0
            return insetBottom + 12
        }())
    }
}

struct ScriptCodeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScriptCodeEditorView(mode: .editor, scriptModel: globalScriptModel)
        }
    }
}
