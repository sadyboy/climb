import SwiftUI
import SpriteKit

struct ChallengeGameView: View {
    @ObservedObject var viewModel: ChallengeViewModel
    
    var body:  some View {
        VStack(spacing: 30) {
            Text(viewModel.selectedChallenge?.title ?? "Challenge")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 60)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 400)
                
                SpriteView(scene: createGameScene())
                    .frame(height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal)
            
            VStack(spacing: 16) {
                HStack {
                    Text("Score:")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(viewModel.challengeScore)")
                        .font(.system(size: 24, weight: .black, design: .monospaced))
                        .foregroundColor(.yellow)
                }
                .padding(.horizontal, 30)
                
                ProgressView(value: viewModel.challengeProgress)
                    .tint(.green)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Capsule())
                    .padding(.horizontal, 30)
            }
            
            Spacer()
            
            SecondaryButton(title: "Complete Challenge") {
                viewModel.completeChallenge()
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.15, green: 0.1, blue: 0.2),
                            Color(red: 0.25, green: 0.15, blue: 0.3)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.5), radius: 30)
        )
        .padding(20)
    }
    
    func createGameScene() -> SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 350, height: 400)
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .clear
        scene.viewModel = viewModel
        return scene
    }
}

class GameScene: SKScene {
    weak var viewModel: ChallengeViewModel?
    private var climber: SKSpriteNode!
    private var targets: [SKShapeNode] = []
    private var timer: Timer?
    
    override func didMove(to view: SKView) {
        setupGame()
        startSpawningTargets()
    }
    
    func setupGame() {
        climber = SKSpriteNode(color: .white, size: CGSize(width:  40, height: 40))
        climber.position = CGPoint(x: size.width / 2, y: 100)
        climber.physicsBody = SKPhysicsBody(rectangleOf: climber.size)
        climber.physicsBody?.isDynamic = false
        addChild(climber)
        
        let moveLeft = SKAction.moveTo(x: 100, duration: 1.5)
        let moveRight = SKAction.moveTo(x: size.width - 100, duration: 1.5)
        let sequence = SKAction.sequence([moveLeft, moveRight])
        let repeatAction = SKAction.repeatForever(sequence)
        climber.run(repeatAction)
    }
    
    func startSpawningTargets() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.spawnTarget()
        }
    }
    
    func spawnTarget() {
        let target = SKShapeNode(circleOfRadius: 20)
        target.fillColor = [.red, .blue, .green, .yellow, .orange].randomElement() ?? .red
        target.strokeColor = .white
        target.lineWidth = 3
        target.position = CGPoint(x: CGFloat.random(in: 50...300), y: size.height)
        target.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        target.physicsBody?.isDynamic = true
        target.physicsBody?.affectedByGravity = false
        
        addChild(target)
        targets.append(target)
        
        let moveDown = SKAction.moveTo(y: -50, duration: 3.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveDown, remove])
        target.run(sequence)
        
        let rotate = SKAction.rotate(byAngle: .pi * 2, duration: 2.0)
        let repeatRotate = SKAction.repeatForever(rotate)
        target.run(repeatRotate)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let touchedNodes = nodes(at: location)
        for node in touchedNodes {
            if let target = node as? SKShapeNode, targets.contains(target) {
                target.removeFromParent()
                if let index = targets.firstIndex(of: target) {
                    targets.remove(at: index)
                }
                
                viewModel?.incrementScore(50)
                
                let explosion = createExplosion(at: location)
                addChild(explosion)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    explosion.removeFromParent()
                }
            }
        }
    }
    
    func createExplosion(at position: CGPoint) -> SKEmitterNode {
        let emitter = SKEmitterNode()
        emitter.position = position
        emitter.particleTexture = SKTexture(imageNamed: "spark")
        emitter.particleBirthRate = 100
        emitter.numParticlesToEmit = 20
        emitter.particleLifetime = 0.5
        emitter.particleSpeed = 100
        emitter.particleSpeedRange = 50
        emitter.emissionAngleRange = .pi * 2
        emitter.particleAlpha = 1.0
        emitter.particleAlphaRange = 0.5
        emitter.particleScale = 0.3
        emitter.particleScaleRange = 0.2
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColor = .yellow
        return emitter
    }
    
    deinit {
        timer?.invalidate()
    }
}
