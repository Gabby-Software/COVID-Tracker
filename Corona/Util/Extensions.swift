//
//  Extensions.swift
//  Corona
//
//  Created by Mohammad on 3/3/20.
//  Copyright © 2020 Samabox. All rights reserved.
//

import MapKit

extension MKMapView {
    var zoomLevel: CGFloat {
        let maxZoom: CGFloat = 20
        let zoomScale = self.visibleMapRect.size.width / Double(self.frame.size.width)
        let zoomExponent = log2(zoomScale)
        return maxZoom - CGFloat(zoomExponent)
    }
}

extension CLLocationCoordinate2D {
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        return location.distance(from: coordinate.location)
    }
}

extension UIControl {
	func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping () -> ()) {
		let sleeve = ClosureSleeve(closure)
		addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
		objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
	}
}

/// WARNING: This solution causes memory leaks
@objc class ClosureSleeve: NSObject {
	let closure: () -> ()

	init (_ closure: @escaping () -> ()) {
		self.closure = closure
	}

	@objc func invoke() {
		closure()
	}
}

extension Locale {
	static let posix = Locale(identifier: "en_US_POSIX")
}

extension Calendar {
	static let posix: Calendar = {
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = .posix
		return calendar
	}()
}

extension Date {
	static let reference = Calendar.posix.date(from: DateComponents(year: 2000))!

	static func fromReferenceDays(days: Int) -> Date {
		Calendar.posix.date(byAdding: .day, value: days, to: Date.reference)!
	}

	var referenceDays: Int {
		Calendar.posix.dateComponents([.day], from: Date.reference, to: self).day!
	}
}

extension Double {
	var kmFormatted: String {
		if self >= 10_000, self < 1_000_000 {
			return String(format: "%.1fk", locale: .posix, self / 1_000).replacingOccurrences(of: ".0", with: "")
		}

		if self >= 1_000_000 {
			return String(format: "%.1fm", locale: .posix, self / 1_000_000).replacingOccurrences(of: ".0", with: "")
		}

		return String(format: "%.0f", locale: .posix, self)
	}
}

extension NumberFormatter {
	static let groupingFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.usesGroupingSeparator = true
		formatter.groupingSize = 3
		formatter.maximumFractionDigits = 1
		return formatter
	}()
}
