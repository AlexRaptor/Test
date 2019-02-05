//
//  ImageWarpSKViewController.swift
//  Test
//
//  Created by Alexander Selivanov on 04/02/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit
import SpriteKit

class ImageWarpSKViewController: UIViewController {

    let SPRITE_SIZE = CGSize(width: 200, height: 200) // swiftlint:disable:this identifier_name
    let PIN_OFFSET: CGFloat = 10 // swiftlint:disable:this identifier_name

    lazy var sourceSizeX: CGFloat =
        (sourcePinPositions[PinTypes.bottomRight.rawValue].x - sourcePinPositions[PinTypes.bottomLeft.rawValue].x)
    lazy var sourceSizeY: CGFloat =
        (sourcePinPositions[PinTypes.topLeft.rawValue].y - sourcePinPositions[PinTypes.bottomLeft.rawValue].y)

    var scene: SKScene!
    var sprite: SKSpriteNode!

    enum PinTypes: Int {
        case bottomLeft, bottomRight, topLeft, topRight
    }

    var pins: [SKNode] = []
    var sourcePinPositions: [CGPoint] = []
    let sourcePositions: [float2] = [float2(0, 0), float2(1, 0), float2(0, 1), float2(1, 1)]
    var destinationPositions: [float2] = [float2(0, 0), float2(1, 0), float2(0, 1), float2(1, 1)]

    var touchedPin: SKNode?
    var indexOfTouchedPin: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // swiftlint:disable:next force_cast
        if let view = self.view as! SKView? {

            scene = SKScene(size: view.bounds.size)

            scene.scaleMode = .aspectFill

            configureScene()
            view.presentScene(scene)

            addGestures()
        }
    }

    private func addGestures() {

        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(handlePan(recognizer:)))

        scene.view?.addGestureRecognizer(panGestureRecognizer)

    }

    fileprivate func recalculateDestinationPositions(_ indexOfTouchedPin: Int, _ touchedPin: SKNode) {

        var destX: CGFloat = 0
        var destY: CGFloat = 0

        switch indexOfTouchedPin {

        case PinTypes.bottomLeft.rawValue:

            destX = (touchedPin.position.x - sourcePinPositions[PinTypes.bottomLeft.rawValue].x) / sourceSizeX

            destY = (touchedPin.position.y - sourcePinPositions[PinTypes.bottomLeft.rawValue].y) / sourceSizeY

        case PinTypes.bottomRight.rawValue:

            destX = 1 + (touchedPin.position.x - sourcePinPositions[PinTypes.bottomRight.rawValue].x) / sourceSizeX

            destY = (touchedPin.position.y - sourcePinPositions[PinTypes.bottomRight.rawValue].y) / sourceSizeY

        case PinTypes.topLeft.rawValue:

            destX = (touchedPin.position.x - sourcePinPositions[PinTypes.bottomLeft.rawValue].x) / sourceSizeX

            destY = 1 + (touchedPin.position.y - sourcePinPositions[PinTypes.topLeft.rawValue].y) / sourceSizeY

        case PinTypes.topRight.rawValue:

            destX = 1 + (touchedPin.position.x - sourcePinPositions[PinTypes.topRight.rawValue].x) / sourceSizeX

            destY = 1 + (touchedPin.position.y - sourcePinPositions[PinTypes.topRight.rawValue].y) / sourceSizeY

        default:
            break
        }

        destinationPositions[indexOfTouchedPin] = float2(Float(destX), Float(destY))
    }

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {

        print("pan")

        switch recognizer.state {

        case .began:
print("began")
            let touchLocation = recognizer.location(in: recognizer.view)
            let skTouchLocation = CGPoint(x: touchLocation.x, y: recognizer.view!.bounds.height - touchLocation.y)

            guard let touchedPin = scene.nodes(at: skTouchLocation).filter({ self.pins.contains($0) }).first
                else {

                    print("touchLocation: \(touchLocation)")
                    print("skTouchLocation: \(skTouchLocation)")

                    for pin in pins {
                        print("\(pin.name): \(pin.position)")
                    }

                    break

}

            self.touchedPin = touchedPin
            indexOfTouchedPin = pins.firstIndex(of: touchedPin)

if indexOfTouchedPin == nil {
print("NIL")
} else {
print("indexOfTouchedPin: \(indexOfTouchedPin)")
            }

        case .ended:
print("ended")
            guard let touchedPin = self.touchedPin else { break }

            let translation = recognizer.translation(in: self.view)

            touchedPin.position = CGPoint(x: touchedPin.position.x + translation.x,
                                          y: touchedPin.position.y - translation.y)
            self.touchedPin = nil
            self.indexOfTouchedPin = nil
print("\n\n\n")
        case .changed:
//print("changed")
            guard let touchedPin = self.touchedPin,
                let indexOfTouchedPin = self.indexOfTouchedPin
                else { break }

            let translation = recognizer.translation(in: self.view)

            touchedPin.position = CGPoint(x: touchedPin.position.x + translation.x,
                                          y: touchedPin.position.y - translation.y)

            recalculateDestinationPositions(indexOfTouchedPin, touchedPin)

            warpImage()

        default:
print("default")
            break
        }

        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }

    private func configureScene() {

        addSprite(imageNamed: "monalisa.jpg")
        configurePins()
    }

    private func configurePins() {

        var pin = SKShapeNode(circleOfRadius: 10)
        pin.name = "bottomLeftPin"
        pin.fillColor = .yellow
        pin.position = CGPoint(x: sprite.position.x - sprite.size.width / 2 - PIN_OFFSET,
                               y: sprite.position.y - sprite.size.height / 2 - PIN_OFFSET)
        pins.insert(pin, at: PinTypes.bottomLeft.rawValue)
        sourcePinPositions.insert(pin.position, at: PinTypes.bottomLeft.rawValue)
        scene.addChild(pin)

        pin = SKShapeNode(circleOfRadius: 10)
        pin.name = "bottomRightPin"
        pin.fillColor = .blue
        pin.position = CGPoint(x: sprite.position.x + sprite.size.width / 2 + PIN_OFFSET,
                               y: sprite.position.y - sprite.size.height / 2 - PIN_OFFSET)
        pins.insert(pin, at: PinTypes.bottomRight.rawValue)
        sourcePinPositions.insert(pin.position, at: PinTypes.bottomRight.rawValue)
        scene.addChild(pin)

        pin = SKShapeNode(circleOfRadius: 10)
        pin.name = "topLeftPin"
        pin.fillColor = .red
        pin.position = CGPoint(x: sprite.position.x - sprite.size.width / 2 - PIN_OFFSET,
                               y: sprite.position.y + sprite.size.height / 2 + PIN_OFFSET)
        pins.insert(pin, at: PinTypes.topLeft.rawValue)
        sourcePinPositions.insert(pin.position, at: PinTypes.topLeft.rawValue)
        scene.addChild(pin)

        pin = SKShapeNode(circleOfRadius: 10)
        pin.name = "topRightPin"
        pin.fillColor = .green
        pin.position = CGPoint(x: sprite.position.x + sprite.size.width / 2 + PIN_OFFSET,
                               y: sprite.position.y + sprite.size.height / 2 + PIN_OFFSET)
        pins.insert(pin, at: PinTypes.topRight.rawValue)
        sourcePinPositions.insert(pin.position, at: PinTypes.topRight.rawValue)
        scene.addChild(pin)
    }

    private func addSprite(imageNamed: String) {

        sprite = SKSpriteNode(imageNamed: imageNamed)

        sprite.size = SPRITE_SIZE

        guard let center = view?.center else { return }

        sprite.position = center

        scene.addChild(sprite)
    }

    private func warpImage() {

        let warpGrid = SKWarpGeometryGrid(columns: 1,
                                          rows: 1,
                                          sourcePositions: sourcePositions,
                                          destinationPositions: destinationPositions)

        guard let action = SKAction.warp(to: warpGrid, duration: 0) else { return }

        sprite.run(action)
    }
}
