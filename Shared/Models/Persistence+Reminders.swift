//
//  Persistence+Reminders.swift
//  PortfolioishWidgetExtension
//
//  Created by Deirdre Saoirse Moen on 2/23/22.
//

import CoreData
import UserNotifications

extension Persistence {
	/// Reminders, for managing notifications if user's given
	/// permission and has enabled them for this project. Or,
	/// for removing them when no longer desired.
	func addReminders(for project: Project, completion: @escaping (Bool) -> Void) {
		let center = UNUserNotificationCenter.current()

		center.getNotificationSettings { settings in
			switch settings.authorizationStatus {
			case .notDetermined:
				self.requestNotifications { success in
					if success {
						self.placeReminders(for: project, completion: completion)
					} else {
						DispatchQueue.main.async {
							completion(false)
						}
					}
				}
			case .authorized:
				self.placeReminders(for: project, completion: completion)
			default:
				DispatchQueue.main.async {
					completion(false)
				}
			}
		}
	}

	// swiftlint:disable:next todo
	// TODO: code to ensure reminders are removed for closed projects

	/// removeReminders - like it says on the tin
	func removeReminders(for project: Project) {
		let center = UNUserNotificationCenter.current()
		let id = project.objectID.uriRepresentation().absoluteString
		center.removePendingNotificationRequests(withIdentifiers: [id])
	}

	/// requestNotifications - private so not called from elsewhere.
	/// Checks to ensure the notifications are authorized.
	private func requestNotifications(completion: @escaping (Bool) -> Void) {
		let center = UNUserNotificationCenter.current()

		center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
			completion(granted)
		}
	}

	private func placeReminders(for project: Project, completion: @escaping (Bool) -> Void) {
		let content = UNMutableNotificationContent()
		content.sound = .default
		content.title = project.projectTitle

		if let projectDetail = project.detail {
			content.subtitle = projectDetail
		}
		let components = Calendar.current.dateComponents([.hour, .minute], from: project.reminderTime ?? Date())
		let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
		let id = project.objectID.uriRepresentation().absoluteString
		let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

		UNUserNotificationCenter.current().add(request) { error in
			DispatchQueue.main.async {
				if error == nil {
					completion(true)
				} else {
					completion(false)
				}
			}
		}
	}
}
