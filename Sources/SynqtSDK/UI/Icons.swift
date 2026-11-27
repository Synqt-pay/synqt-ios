import SwiftUI

/// The sheet's line icons: Phosphor Icons, Regular weight (@phosphor-icons/core 2.1.1, MIT licence, see
/// THIRD_PARTY_NOTICES.md), on Phosphor's 256 by 256 grid.
enum SynqtIcon: CaseIterable {
    case lock, close, warning, chevronDown, copy, timer

    var path: Path {
        switch self {
        case .lock: return svgPath("M208,80H176V56a48,48,0,0,0-96,0V80H48A16,16,0,0,0,32,96V208a16,16,0,0,0,16,16H208a16,16,0,0,0,16-16V96A16,16,0,0,0,208,80ZM96,56a32,32,0,0,1,64,0V80H96ZM208,208H48V96H208V208Zm-68-56a12,12,0,1,1-12-12A12,12,0,0,1,140,152Z")
        case .close: return svgPath("M205.66,194.34a8,8,0,0,1-11.32,11.32L128,139.31,61.66,205.66a8,8,0,0,1-11.32-11.32L116.69,128,50.34,61.66A8,8,0,0,1,61.66,50.34L128,116.69l66.34-66.35a8,8,0,0,1,11.32,11.32L139.31,128Z")
        case .warning: return svgPath("M128,24A104,104,0,1,0,232,128,104.11,104.11,0,0,0,128,24Zm0,192a88,88,0,1,1,88-88A88.1,88.1,0,0,1,128,216Zm-8-80V80a8,8,0,0,1,16,0v56a8,8,0,0,1-16,0Zm20,36a12,12,0,1,1-12-12A12,12,0,0,1,140,172Z")
        case .chevronDown: return svgPath("M213.66,101.66l-80,80a8,8,0,0,1-11.32,0l-80-80A8,8,0,0,1,53.66,90.34L128,164.69l74.34-74.35a8,8,0,0,1,11.32,11.32Z")
        case .copy: return svgPath("M216,32H88a8,8,0,0,0-8,8V80H40a8,8,0,0,0-8,8V216a8,8,0,0,0,8,8H168a8,8,0,0,0,8-8V176h40a8,8,0,0,0,8-8V40A8,8,0,0,0,216,32ZM160,208H48V96H160Zm48-48H176V88a8,8,0,0,0-8-8H96V48H208Z")
        case .timer: return svgPath("M128,40a96,96,0,1,0,96,96A96.11,96.11,0,0,0,128,40Zm0,176a80,80,0,1,1,80-80A80.09,80.09,0,0,1,128,216ZM173.66,90.34a8,8,0,0,1,0,11.32l-40,40a8,8,0,0,1-11.32-11.32l40-40A8,8,0,0,1,173.66,90.34ZM96,16a8,8,0,0,1,8-8h48a8,8,0,0,1,0,16H104A8,8,0,0,1,96,16Z")
        }
    }
}

/// An icon at `size` points in `color`, growing with Dynamic Type like the text beside it. Decorative: the control it
/// sits on carries the label.
struct IconView: View {
    let icon: SynqtIcon
    var size: CGFloat = 24
    let color: Color
    @ScaledMetric private var scale: CGFloat = 1

    var body: some View {
        let scaledSize = size * scale
        icon.path.applying(CGAffineTransform(scaleX: scaledSize / 256, y: scaledSize / 256))
            .fill(color)
            .frame(width: scaledSize, height: scaledSize)
            .accessibilityHidden(true)
    }
}

/// The Synqt wordmark, 26pt tall (the smallest size the brand uses). Paths and offsets are copied unchanged from the
/// brand's synqt-logo-positive.svg: letters in the logo ink (positive on light, negative on dark),
/// the dot always magenta. Never redraw it.
struct SynqtLogo: View {
    let ink: Color

    private static let letters: Path = {
        var path = Path()
        for (x, y, pathData) in [
            (0.0, 10.8311, "M14.81 11.49 C10.65 10.99 8.19 10.76 8.19 8.58 C8.19 6.73 10.21 5.61 13.29 5.61 C16.38 5.61 18.68 7.01 18.90 9.31 L26.47 9.31 C26.08 3.42 20.75 0.00 13.01 0.00 C5.61 -0.06 0.62 3.70 0.62 9.42 C0.62 15.14 5.83 16.88 12.56 17.66 C17.22 18.28 19.18 18.45 19.18 20.81 C19.18 22.83 17.16 23.89 13.86 23.89 C9.99 23.89 7.80 22.15 7.52 19.63 L0.00 19.63 C0.34 25.80 5.78 29.56 13.80 29.56 C21.82 29.56 26.92 25.91 26.92 20.19 C26.92 13.68 21.43 12.17 14.81 11.49 Z"),
            (60.7460, 10.8827, "M16.55 0.00 C12.12 0.00 9.48 1.68 7.63 3.93 L6.90 0.34 L0.00 0.34 L0.00 29.17 L7.91 29.17 L7.91 14.42 C7.91 9.43 10.26 6.51 14.36 6.51 C18.46 6.51 20.20 9.09 20.20 13.97 L20.20 29.17 L28.11 29.17 L28.11 13.18 C28.11 3.31 22.78 0.00 16.55 0.00 Z"),
            (92.6092, 10.8827, "M23.05 0.34 L22.05 0.34 L22.05 3.93 C20.19 1.61 17.35 0.00 13.41 0.00 C5.67 -0.06 0.00 5.89 0.00 14.81 C0.00 23.73 5.66 29.50 13.35 29.50 C17.33 29.50 20.14 27.82 22.04 25.46 L22.04 34.46 L22.05 34.46 L22.05 35.99 C22.05 38.41 24.02 40.38 26.45 40.38 L29.95 40.38 L29.95 19.25 C29.95 16.83 27.99 14.86 25.56 14.86 L22.05 14.86 L22.05 16.33 C21.53 20.35 18.98 23.05 15.15 23.05 C10.83 23.05 8.08 19.62 8.08 14.69 C8.08 9.75 10.83 6.44 15.15 6.44 C18.83 6.44 21.32 8.89 21.98 12.67 L22.05 12.64 L22.05 12.69 L25.56 12.69 C27.96 12.69 29.90 10.77 29.95 8.39 L29.95 8.32 C29.95 8.32 29.95 8.31 29.95 8.30 L29.95 0.33 L23.05 0.33 L23.05 0.34 Z"),
            (126.7834, 0.0, "M0.00 19.19 C0.00 21.61 1.97 23.58 4.40 23.58 L7.91 23.58 L7.91 21.66 L7.91 21.66 L7.91 17.89 L14.53 17.89 L14.53 11.22 L7.91 11.22 L7.91 0.00 L0.00 0.00 L0.00 17.90 L0.00 19.19 L0.00 19.19 Z"),
            (126.7928, 25.7395, "M10.77 7.63 C8.69 7.63 7.91 6.79 7.91 4.77 L7.91 0.75 C7.91 0.75 7.91 0.75 7.90 0.75 L7.90 0.00 L4.39 0.00 C1.97 0.00 0.00 1.97 0.00 4.39 L0.00 4.51 L0.00 6.06 L0.00 6.81 L0.03 6.81 C0.27 11.80 3.01 14.30 8.25 14.30 L14.70 14.30 L14.70 7.62 L10.77 7.62 L10.77 7.63 Z"),
            (27.3574, 11.2183, "M30.74 0.00 L22.27 0.00 L15.43 20.53 L8.41 0.00 L0.00 0.00 L11.09 28.96 L6.78 40.05 L11.37 40.05 C13.67 40.05 15.73 38.64 16.56 36.50 L18.65 31.11 L30.73 0.00 L30.74 0.00 Z"),
        ] { path.addPath(svgPath(pathData), transform: CGAffineTransform(translationX: x, y: y)) }
        return path
    }()

    private static let dot = svgPath("M4.57 9.14 C7.10 9.14 9.14 7.10 9.14 4.57 C9.14 2.05 7.10 0.00 4.57 0.00 C2.05 0.00 0.00 2.05 0.00 4.57 C0.00 7.10 2.05 9.14 4.57 9.14 Z")
        .applying(CGAffineTransform(translationX: 145.7092, y: 31.0714))

    var body: some View {
        let scale = CGAffineTransform(scaleX: 26 / 51.266, y: 26 / 51.266) // the artwork is 154.854 by 51.266
        ZStack(alignment: .topLeading) {
            Self.letters.applying(scale).fill(ink)
            Self.dot.applying(scale).fill(SynqtColors.magenta)
        }
        .frame(width: 154.854 * 26 / 51.266, height: 26, alignment: .topLeading)
        .accessibilityElement()
        .accessibilityLabel(text("synqt_sheet_logo"))
    }
}

/**
 An SVG path's `d` attribute as a Path. Handles the commands the icons and wordmark use (M, L, H, V, C, S, A and Z, in
 absolute and relative form). Arcs become cubic curves, as SVG renderers draw them.
 */
func svgPath(_ pathData: String) -> Path {
    var path = Path()
    var scanner = SVGScanner(Array(pathData.utf8))
    var command: UInt8 = 0
    var current = CGPoint.zero, start = CGPoint.zero, lastControl: CGPoint?
    while let letter = scanner.command() ?? (command != 0 && scanner.hasNumber ? command : nil) {
        // After M, further coordinate pairs are lines.
        command = letter == UInt8(ascii: "M") ? UInt8(ascii: "L") : letter == UInt8(ascii: "m") ? UInt8(ascii: "l") : letter
        let relative = letter >= UInt8(ascii: "a")
        let origin = relative ? current : .zero
        func point() -> CGPoint { CGPoint(x: origin.x + scanner.number(), y: origin.y + scanner.number()) }
        var control: CGPoint?
        switch letter | 0x20 { // lower case
        case UInt8(ascii: "m"):
            current = point(); start = current
            path.move(to: current)
        case UInt8(ascii: "l"):
            current = point()
            path.addLine(to: current)
        case UInt8(ascii: "h"):
            current.x = origin.x + scanner.number()
            path.addLine(to: current)
        case UInt8(ascii: "v"):
            current.y = (relative ? current.y : 0) + scanner.number()
            path.addLine(to: current)
        case UInt8(ascii: "c"):
            let c1 = point(), c2 = point()
            current = point(); control = c2
            path.addCurve(to: current, control1: c1, control2: c2)
        case UInt8(ascii: "s"):
            let c1 = lastControl.map { CGPoint(x: 2 * current.x - $0.x, y: 2 * current.y - $0.y) } ?? current
            let c2 = point()
            current = point(); control = c2
            path.addCurve(to: current, control1: c1, control2: c2)
        case UInt8(ascii: "a"):
            let rx = scanner.number(), ry = scanner.number(), rotation = scanner.number()
            let large = scanner.flag(), sweep = scanner.flag()
            let end = point()
            addArc(&path, from: current, to: end, rx: rx, ry: ry, rotation: rotation, large: large, sweep: sweep)
            current = end
        case UInt8(ascii: "z"):
            path.closeSubpath()
            current = start
            command = 0
        default:
            return path // an unsupported command: stop rather than draw something wrong
        }
        lastControl = control
    }
    return path
}

/// Endpoint arc to cubic curves, following the SVG spec's conversion (appendix B.2.4) in quarter turns or less.
private func addArc(_ path: inout Path, from startPoint: CGPoint, to endPoint: CGPoint, rx: CGFloat, ry: CGFloat, rotation: CGFloat, large: Bool, sweep: Bool) {
    var rx = abs(rx), ry = abs(ry)
    guard rx > 0, ry > 0, startPoint != endPoint else { return path.addLine(to: endPoint) }
    let phi = rotation * .pi / 180, cosPhi = cos(phi), sinPhi = sin(phi)
    let dx = (startPoint.x - endPoint.x) / 2, dy = (startPoint.y - endPoint.y) / 2
    let x1 = cosPhi * dx + sinPhi * dy, y1 = -sinPhi * dx + cosPhi * dy
    let scale = x1 * x1 / (rx * rx) + y1 * y1 / (ry * ry)
    if scale > 1 { rx *= scale.squareRoot(); ry *= scale.squareRoot() }
    let num = rx * rx * ry * ry - rx * rx * y1 * y1 - ry * ry * x1 * x1
    let coefficient = (large == sweep ? -1 : 1) * (max(0, num) / (rx * rx * y1 * y1 + ry * ry * x1 * x1)).squareRoot()
    let cx1 = coefficient * rx * y1 / ry, cy1 = -coefficient * ry * x1 / rx
    let center = CGPoint(x: cosPhi * cx1 - sinPhi * cy1 + (startPoint.x + endPoint.x) / 2, y: sinPhi * cx1 + cosPhi * cy1 + (startPoint.y + endPoint.y) / 2)
    func angle(_ ux: CGFloat, _ uy: CGFloat) -> CGFloat { atan2(uy, ux) }
    let start = angle((x1 - cx1) / rx, (y1 - cy1) / ry)
    var delta = angle((-x1 - cx1) / rx, (-y1 - cy1) / ry) - start
    if sweep && delta < 0 { delta += 2 * .pi }
    if !sweep && delta > 0 { delta -= 2 * .pi }
    let segments = Int((abs(delta) / (.pi / 2)).rounded(.up))
    let step = delta / CGFloat(segments), handle = 4 / 3 * tan(step / 4)
    func onEllipse(_ angle: CGFloat) -> (CGFloat, CGFloat) { (rx * cos(angle), ry * sin(angle)) }
    func place(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: center.x + cosPhi * x - sinPhi * y, y: center.y + sinPhi * x + cosPhi * y) }
    var theta = start
    for _ in 0..<segments {
        let next = theta + step
        let (x0, y0) = onEllipse(theta), (x3, y3) = onEllipse(next)
        path.addCurve(to: place(x3, y3),
                   control1: place(x0 - handle * rx * sin(theta), y0 + handle * ry * cos(theta)),
                   control2: place(x3 + handle * rx * sin(next), y3 - handle * ry * cos(next)))
        theta = next
    }
}

private struct SVGScanner {
    let bytes: [UInt8]
    var index = 0

    init(_ bytes: [UInt8]) { self.bytes = bytes }

    private mutating func skip() {
        while index < bytes.count, bytes[index] == UInt8(ascii: " ") || bytes[index] == UInt8(ascii: ",") || bytes[index] == UInt8(ascii: "\n") || bytes[index] == UInt8(ascii: "\t") { index += 1 }
    }

    var hasNumber: Bool {
        var lookahead = index
        while lookahead < bytes.count, bytes[lookahead] == UInt8(ascii: " ") || bytes[lookahead] == UInt8(ascii: ",") { lookahead += 1 }
        return lookahead < bytes.count && (bytes[lookahead] == UInt8(ascii: "-") || bytes[lookahead] == UInt8(ascii: ".") || (UInt8(ascii: "0")...UInt8(ascii: "9")).contains(bytes[lookahead]))
    }

    mutating func command() -> UInt8? {
        skip()
        guard index < bytes.count, (bytes[index] | 0x20) >= UInt8(ascii: "a"), (bytes[index] | 0x20) <= UInt8(ascii: "z") else { return nil }
        defer { index += 1 }
        return bytes[index]
    }

    /// One number; "1.5.5" is two numbers and "-8-8" is two, as SVG allows.
    mutating func number() -> CGFloat {
        skip()
        let begin = index
        if index < bytes.count, bytes[index] == UInt8(ascii: "-") || bytes[index] == UInt8(ascii: "+") { index += 1 }
        var dot = false
        while index < bytes.count {
            let byte = bytes[index]
            if (UInt8(ascii: "0")...UInt8(ascii: "9")).contains(byte) { index += 1 }
            else if byte == UInt8(ascii: "."), !dot { dot = true; index += 1 }
            else if byte == UInt8(ascii: "e") || byte == UInt8(ascii: "E") { index += 1; if index < bytes.count, bytes[index] == UInt8(ascii: "-") { index += 1 } }
            else { break }
        }
        return CGFloat(Double(String(decoding: bytes[begin..<index], as: UTF8.self)) ?? 0)
    }

    /// An arc flag: a single 0 or 1, which SVG lets run straight into the next number.
    mutating func flag() -> Bool {
        skip()
        defer { index += 1 }
        return index < bytes.count && bytes[index] == UInt8(ascii: "1")
    }
}
