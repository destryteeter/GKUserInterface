import GKCore
import SpriteKit

public enum GKUI {
    public static var version = "1.0"
}

extension GKC.SK.Scene {

    // Convenience function to draw tracers at a position
    public func showTracer(atPoint pos: CGPoint,
                           node: SKShapeNode,
                           color: SKColor? = nil,
                           actions: [SKAction]? = nil,
                           key: String? = nil,
                           completion: (() -> Void)? = nil) {
        let n: SKShapeNode = node.copy() as! SKShapeNode
        n.position = pos
        if color != nil {
            n.strokeColor = color!
        }
        self.addChild(n)
        var tracerActions: [SKAction] = []
        if actions != nil {
            tracerActions.append(contentsOf: actions!)
        }
        tracerActions.append(SKAction.removeFromParent())
        if key != nil {
            if completion != nil {
                n.run(action: SKAction.sequence(tracerActions), withKey: key!, optionalCompletion: completion)
            }
            else {
                n.run(SKAction.sequence(tracerActions), withKey: key!)
            }
        }
        else {
            if completion != nil {
                n.run(SKAction.sequence(tracerActions), completion: completion!)
            }
            else {
                n.run(SKAction.sequence(tracerActions))
            }
        }
    }
}

extension SKNode {
    func run(action: SKAction!, withKey: String!, optionalCompletion:(() -> Void)?) {
        if let completion = optionalCompletion
        {
            let completionAction = SKAction.run(completion)
            let compositeAction = SKAction.sequence([ action, completionAction ])
            run(compositeAction, withKey: withKey )
        }
        else
        {
            run( action, withKey: withKey )
        }
    }

    open func actionForKeyIsRunning(key: String) -> Bool {
        return self.action(forKey: key) != nil ? true : false
    }
}

extension SKAction {
    public class func changeLabelColor(_ labelNode: SKLabelNode, color: SKColor, withDuration: TimeInterval) -> SKAction {
        return SKAction.sequence([
            SKAction.fadeOut(withDuration: withDuration / 2.0),
            SKAction.customAction(withDuration: 0, actionBlock: { (node, elapsedTime) in
                if let label = node as? SKLabelNode {
                    label.fontColor = color
                }
            }),
            SKAction.fadeIn(withDuration: withDuration / 2.0)
        ])
    }
    public class func fadeLabelToColor(_ labelNode: SKLabelNode, color: SKColor, withDuration: TimeInterval) -> SKAction {
        return SKAction.customAction(withDuration: withDuration, actionBlock: { (node, elapsedTime) in
            if let label = node as? SKLabelNode,
                let colorSpace = CGColorSpace.init(name: CGColorSpace.genericRGBLinear),
                let toColorComponents = color.cgColor.converted(to: colorSpace, intent: .defaultIntent, options: nil)?.components,
                let fromColorComponents = label.fontColor!.cgColor.converted(to: colorSpace, intent: .defaultIntent, options: nil)?.components {
                
                let finalRed = fromColorComponents[0] + (toColorComponents[0] - fromColorComponents[0])*CGFloat(elapsedTime / CGFloat(withDuration))
                let finalGreen = fromColorComponents[1] + (toColorComponents[1] - fromColorComponents[1])*CGFloat(elapsedTime / CGFloat(withDuration))
                let finalBlue = fromColorComponents[2] + (toColorComponents[2] - fromColorComponents[2])*CGFloat(elapsedTime / CGFloat(withDuration))
                let finalAlpha = fromColorComponents[3] + (toColorComponents[3] - fromColorComponents[3])*CGFloat(elapsedTime / CGFloat(withDuration))

                labelNode.fontColor = SKColor(red: finalRed, green: finalGreen, blue: finalBlue, alpha: finalAlpha)
            }
        })
    }
}
