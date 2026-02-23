import SwiftUI
import UIKit

struct CountdownDurationPicker: UIViewRepresentable {
    @Binding var duration: TimeInterval

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.preferredDatePickerStyle = .wheels
        picker.minuteInterval = 1
        picker.countDownDuration = max(60, duration)
        picker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        return picker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        let safeDuration = max(60, duration)
        if abs(uiView.countDownDuration - safeDuration) >= 1 {
            uiView.countDownDuration = safeDuration
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(duration: $duration)
    }

    final class Coordinator: NSObject {
        private var duration: Binding<TimeInterval>

        init(duration: Binding<TimeInterval>) {
            self.duration = duration
        }

        @objc func changed(_ sender: UIDatePicker) {
            duration.wrappedValue = max(60, sender.countDownDuration)
        }
    }
}
