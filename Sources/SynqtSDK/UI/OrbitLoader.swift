import SwiftUI

/// Frames in one loop of the Lottie file (60fps), and how far aqua runs behind magenta.
let orbitLoop = 174.0
let orbitDelay = 7.2

/**
 The Synqt Orbit loader, drawn natively from the designer's Lottie file (synqt-loaders/lottie/orbit-*.json): a hub in
 the text colour, with a magenta and an aqua dot that each turn once, glide into the hub and back out. Decorative, so
 VoiceOver skips it; with Reduce Motion on it holds still.
 */
struct OrbitLoader: View {
    @Environment(\.colorScheme) private var scheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation(minimumInterval: nil, paused: reduceMotion)) { context in
            let frame = reduceMotion ? 0 : context.date.timeIntervalSinceReferenceDate * 60
            Canvas { graphics, size in
                let unit = min(size.width, size.height) / 100 // the Lottie canvas is 100 by 100
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius = 11 * unit
                func dot(_ at: CGPoint, _ color: Color) {
                    graphics.fill(Path(ellipseIn: CGRect(x: at.x - radius, y: at.y - radius, width: 2 * radius, height: 2 * radius)), with: .color(color))
                }
                dot(center, SynqtColors.for(scheme).text)
                // Later dots are drawn on top, as in the Lottie file: hub, then aqua, then magenta.
                for (offset, color) in [(orbitDelay, SynqtColors.aqua), (0, SynqtColors.magenta)] {
                    let (angle, distance) = orbitDot(frame - offset)
                    let rad = angle * .pi / 180
                    dot(CGPoint(x: center.x + distance * unit * sin(rad), y: center.y - distance * unit * cos(rad)), color)
                }
            }
        }
        .accessibilityHidden(true)
    }
}

/// Where an Orbit dot is at `frame` (60fps, looping every 174): degrees clockwise from the top, and distance from the
/// centre on the 100-unit canvas. Keyframes from the Lottie file: turn 0 to 96.05, glide in to 120.06, wait, glide out
/// from 149.99 to 174.
func orbitDot(_ frame: Double) -> (angle: Double, distance: Double) {
    let loopFrame = (frame.truncatingRemainder(dividingBy: orbitLoop) + orbitLoop).truncatingRemainder(dividingBy: orbitLoop)
    let angle = loopFrame < 96.05 ? 360 * ease(loopFrame / 96.05) : 360
    let distance: Double
    switch loopFrame {
    case ..<96.05: distance = 40
    case ..<120.06: distance = 40 * (1 - ease((loopFrame - 96.05) / 24.01))
    case ..<149.99: distance = 0
    default: distance = 40 * ease((loopFrame - 149.99) / 24.01)
    }
    return (angle, distance)
}

/// The file's one easing curve, cubic-bezier(0.65, 0, 0.35, 1), solved for x by bisection.
func ease(_ progress: Double) -> Double {
    func bezier(_ parameter: Double, _ control1: Double, _ control2: Double) -> Double { 3 * (1 - parameter) * (1 - parameter) * parameter * control1 + 3 * (1 - parameter) * parameter * parameter * control2 + parameter * parameter * parameter }
    var lo = 0.0, hi = 1.0
    for _ in 0..<24 {
        let mid = (lo + hi) / 2
        if bezier(mid, 0.65, 0.35) < progress { lo = mid } else { hi = mid }
    }
    return bezier((lo + hi) / 2, 0, 1)
}
