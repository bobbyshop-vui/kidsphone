import SwiftUI
import UIKit

struct PhoneKidsView: View {
    // Danh sách các ứng dụng được phép (bao gồm cả các ứng dụng nổi tiếng và App Store)
    let allowedApps = ["YouTube Kids", "Zalo", "Kidsphone", "TikTok", "Instagram", "Facebook", "Snapchat", "Minecraft", "App Store"]
    
    @State private var selectedApps: Set<String> = []
    @State private var isAllowedMode: Bool = false // Biến trạng thái cho chế độ cho phép
    @State private var isGuidedAccessEnabled: Bool = false // Biến trạng thái cho Guided Access
    @State private var showAlert: Bool = false // Biến trạng thái để hiển thị thông báo
    @State private var alertMessage: String = "" // Nội dung của thông báo

    var body: some View {
        NavigationView {
            VStack {
                // Nút bật tắt chế độ cho phép ứng dụng
                Toggle("Chế độ cho phép ứng dụng", isOn: $isAllowedMode)
                    .padding()

                List {
                    // Tạo danh sách các ứng dụng cho phép
                    ForEach(allowedApps, id: \.self) { app in
                        Button(action: {
                            toggleSelection(for: app)
                        }) {
                            HStack {
                                Text(app)
                                Spacer()
                                if selectedApps.contains(app) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Chọn Ứng Dụng Trẻ Em")
                
                // Nút để kích hoạt hoặc tắt Guided Access
                Button(action: {
                    toggleGuidedAccess()
                }) {
                    Text(isGuidedAccessEnabled ? "Tắt Guided Access" : "Bật Guided Access")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            // Hiển thị cảnh báo khi không thể bật/tắt Guided Access
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Thông báo"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // Hàm để chọn hoặc bỏ chọn ứng dụng
    private func toggleSelection(for app: String) {
        if selectedApps.contains(app) {
            selectedApps.remove(app)
        } else {
            // Thêm ứng dụng vào danh sách đã chọn
            selectedApps.insert(app)
        }
    }

    // Hàm để kích hoạt hoặc tắt Guided Access
    private func toggleGuidedAccess() {
        if isGuidedAccessEnabled {
            // Tắt Guided Access
            UIAccessibility.requestGuidedAccessSession(enabled: false) { success in
                if success {
                    print("Đã tắt Guided Access.")
                } else {
                    // Không thể tắt Guided Access - Hiển thị cảnh báo
                    alertMessage = "Không thể tắt Guided Access."
                    showAlert = true
                }
            }
        } else {
            // Bật Guided Access
            UIAccessibility.requestGuidedAccessSession(enabled: true) { success in
                if success {
                    print("Đã bật Guided Access.")
                } else {
                    // Không thể bật Guided Access - Hiển thị cảnh báo
                    alertMessage = "Không thể bật Guided Access."
                    showAlert = true
                }
            }
        }
        isGuidedAccessEnabled.toggle()
    }
}
