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

    var scene: SKScene!
    var sprite: SKSpriteNode!

    enum PinTypes: Int {
        case topLeft, topRight, bottomRight, bottomLeft
    }

    var pins: [SKNode] = []
    var touchedPin: SKNode?

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

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {

        switch recognizer.state {

        case .began:

            let touchLocation = recognizer.location(in: recognizer.view)
            let skTouchLocation = CGPoint(x: touchLocation.x, y: recognizer.view!.bounds.height - touchLocation.y)
            
            touchedPin = scene.nodes(at: skTouchLocation).filter({ self.pins.contains($0) }).first

        case .ended:

            guard let touchedPin = self.touchedPin else { break }

            let translation = recognizer.translation(in: self.view)

            touchedPin.position = CGPoint(x: touchedPin.position.x + translation.x,
                                          y: touchedPin.position.y - translation.y)
            self.touchedPin = nil

        case .changed:

            guard let touchedPin = self.touchedPin else { break }
            let translation = recognizer.translation(in: self.view)

            touchedPin.position = CGPoint(x: touchedPin.position.x + translation.x,
                                          y: touchedPin.position.y - translation.y)

        default:
            break
        }

        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }

    private func configureScene() {

        addSprite(imageNamed: "monalisa.jpg")
        configurePins()
    }

    private func configurePins() {

        let topLeftPin = SKShapeNode(circleOfRadius: 10)
        topLeftPin.name = "topLeftPin"
        topLeftPin.fillColor = .red
        topLeftPin.position = CGPoint(x: sprite.position.x - sprite.size.width / 2 - PIN_OFFSET,
                                      y: sprite.position.y + sprite.size.height / 2 + PIN_OFFSET)
        pins.insert(topLeftPin, at: PinTypes.topLeft.rawValue)
        scene.addChild(topLeftPin)

        let topRightPin = SKShapeNode(circleOfRadius: 10)
        topRightPin.name = "topRightPin"
        topRightPin.fillColor = .green
        topRightPin.position = CGPoint(x: sprite.position.x + sprite.size.width / 2 + PIN_OFFSET,
                                       y: sprite.position.y + sprite.size.height / 2 + PIN_OFFSET)
        pins.insert(topRightPin, at: PinTypes.topRight.rawValue)
        scene.addChild(topRightPin)

        let bottomRightPin = SKShapeNode(circleOfRadius: 10)
        bottomRightPin.name = "bottomRightPin"
        bottomRightPin.fillColor = .blue
        bottomRightPin.position = CGPoint(x: sprite.position.x + sprite.size.width / 2 + PIN_OFFSET,
                                          y: sprite.position.y - sprite.size.height / 2 - PIN_OFFSET)
        pins.insert(bottomRightPin, at: PinTypes.bottomRight.rawValue)
        scene.addChild(bottomRightPin)

        let bottomLeftPin = SKShapeNode(circleOfRadius: 10)
        bottomLeftPin.name = "bottomLeftPin"
        bottomLeftPin.fillColor = .yellow
        bottomLeftPin.position = CGPoint(x: sprite.position.x - sprite.size.width / 2 - PIN_OFFSET,
                                         y: sprite.position.y - sprite.size.height / 2 - PIN_OFFSET)
        pins.insert(bottomLeftPin, at: PinTypes.bottomLeft.rawValue)
        scene.addChild(bottomLeftPin)
    }

    private func addSprite(imageNamed: String) {

        sprite = SKSpriteNode(imageNamed: imageNamed)

        sprite.size = SPRITE_SIZE

        guard let center = view?.center else { return }

        sprite.position = center

        scene.addChild(sprite)
    }
}
