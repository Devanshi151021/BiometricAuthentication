import SwiftUI
import LocalAuthentication
import Playgrounds

struct ContentView: View {
    @State private var biometricEnabled = false
    @State private var showText = false
    
    var body: some View {
        VStack {
                 Text("Biometric Authentication")
                     .font(.largeTitle)
            if(showText){
                Text("123456")
            }

                 if biometricEnabled {
                     Button("Authenticate with Biometrics") {
                         BiometricAuthManager.shared.authenticateWithBiometrics { success, error in
                             if success {
                                 // Biometric authentication was successful, proceed to login or reveal protected information.
                                 showText.toggle()
                             } else {
                                 if let error = error as? LAError {
                                     // Handle the authentication error
                                     switch error.code {
                                     case .userCancel, .systemCancel:
                                         // The user canceled the authentication
                                         print("cancel authentication")
                                     case .userFallback:
                                         // The user chose to enter a password
                                         print("user fallback")
                                     default:
                                         // Handle other authentication errors
                                         print("Authentication failed: \(error.localizedDescription)")
                                     }
                                 }
                             }
                         }
                     }
                 } else {
                     Text("Biometric authentication is disabled. Enable it in your device settings.")
                 }

                 Toggle("Enable Biometrics", isOn: $biometricEnabled)
                     .onChange(of: biometricEnabled) { enabled in
                         if enabled {
                             enableBiometrics()
                         }
                     }
             }
    }
    
    func enableBiometrics() {
           if BiometricAuthManager.shared.canUseBiometricAuthentication() {
               biometricEnabled = true
           } else {
               // Biometric authentication is not available; guide the user to the device settings.
               showBiometricsSettingsAlert()
           }
       }

       func showBiometricsSettingsAlert() {
           // Display an alert to guide the user to the device settings.
       }
}

#Preview {
    ContentView()
}

