import UIKit

struct Alert {
    static func showAlert(onVC vc: UIViewController, actionTapped: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: "Проверьте соединение с сетью.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Обновить данные", style: .default) { (_) in
                actionTapped()
            }
            alert.addAction(action)
            vc.present(alert, animated: true)
        }
    }
}
