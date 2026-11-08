import SpriteKit

/// A floating ghost that smoothly changes color.
final class ShimmeringGhost: SKSpriteNode {}

extension ShimmeringGhost: SceneObject {
    func setup(scene: LevelScene) {
        let ghostTexture = SKTexture(imageNamed: Assets.Image.ghost)
        texture = ghostTexture
        if size == .zero { size = ghostTexture.size() }
        anchorPoint = CGPoint(
            x: 0.5,
            y: 0.5
        )
        zPosition = Layer.scenery

        // SKDefaultShading preserves the sprite's normal texture and alpha.
        // u_time is supplied by SpriteKit; no per-frame Swift update is needed.
        shader = SKShader(source: """
        vec3 shimmerColor(float step) {
            float choice = fract(sin(step * 127.1 + 17.0) * 43758.5453);
            if (choice < 0.333) return vec3(1.0, 1.0, 1.0);
            if (choice < 0.666) return vec3(0.75, 0.02, 0.03);
            return vec3(0.12, 0.12, 0.14);
        }

        void main() {
            vec4 color = SKDefaultShading();
            float colorTime = u_time * 0.7;
            float colorStep = floor(colorTime);
            vec3 tint = mix(shimmerColor(colorStep), shimmerColor(colorStep + 1.0),
                            smoothstep(0.35, 0.85, fract(colorTime)));
            color.rgb = mix(color.rgb, tint * color.a, 0.85);
            gl_FragColor = color;
        }
        """)

        // Scale the floating distance with the sprite and return to its starting point.
        let offset = size.height * 0.2
        let up = SKAction.moveBy(
            x: 0,
            y: offset,
            duration: 1.2
        )
        let down = SKAction.moveBy(
            x: 0,
            y: -offset * 2,
            duration: 2.4
        )
        let back = SKAction.moveBy(
            x: 0,
            y: offset,
            duration: 1.2
        )
        [up, down, back].forEach { $0.timingMode = .easeInEaseOut }
        run(
            .repeatForever(.sequence([up, down, back])),
            withKey: Constants.ghostFloat
        )
    }
}

private enum Constants {
    static let ghostFloat = "ghostFloat"
}
