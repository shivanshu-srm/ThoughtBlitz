import SwiftUI
import SpriteKit

class Level1: SKScene, ShapeClicked {
    
    @Binding var value1: Int
    @Binding var value2: String
    @Binding var moves: Int
    @Binding var targetValue: Int
    @Binding var targetColor: UIColor
    @Binding var targetShape: String
    @Binding var timerCount: CGFloat
    @Binding var playerPoints: Int
    @Binding var gameState: String
    @Binding var isPlaying: Bool
    
    init(value1: Binding<Int>, value2: Binding<String>, moves: Binding<Int>, targetValue: Binding<Int>, targetColor: Binding<UIColor>, targetShape: Binding<String>, timerCount: Binding<CGFloat>, playerPoints: Binding<Int>, gameState: Binding<String>, isPlaying: Binding<Bool>) {/*till targetcolor*/
        
        _value1 = value1
        _value2 = value2
        _moves = moves
        _targetValue = targetValue
        _targetColor = targetColor
        _targetShape = targetShape
        _timerCount = timerCount
        _playerPoints = playerPoints
        _gameState = gameState
        _isPlaying = isPlaying
        
        super.init(size: CGSize(width: 600, height: 600))
        self.scaleMode = .fill
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var timer = GameTimer()
    var shape = ShapeClass()
    var shapesOnBoard = [ShapeClass()]
    var valuesOnBoard = [Int()]
    var shapeIndex = Int()
    var levelTimerStart = 30.0
    var level = 1
    var highScore = Int()
    var currentHighScore = Int()
    var levelClearPerfect = Bool()
    
    
    let colors = [ UIColor(.blue),
                   UIColor(.orange),
                   UIColor(.green),
                   UIColor(.yellow)]
    
    
    
    let shapes = [ "Lion",
                   "Duck",
                   "Monkey",
                   "Elephant"]
    
    
 
    let gridPositions = [CGPoint(x: 300, y: 100),
                         CGPoint(x: 300, y: 500),
                         CGPoint(x: 300, y: 300),
                         CGPoint(x: 100, y: 100),
                         CGPoint(x: 100, y: 500),
                         CGPoint(x: 100, y: 300),
                         CGPoint(x: 500, y: 100),
                         CGPoint(x: 500, y: 500),
                         CGPoint(x: 500, y: 300)
    ]
    
    let startPositions = [CGPoint(x: 700, y: -100),
                          CGPoint(x: -700, y: 500),
                          CGPoint(x: 700, y: -300),
                          CGPoint(x: 400, y: 700),
                          CGPoint(x: 100, y: -700),
                          CGPoint(x: 200, y: 700),
                          CGPoint(x: -700, y: 700),
                          CGPoint(x: 500, y: -700),
                          CGPoint(x: 300, y: 700)
    ]
    
    
    override func didMove(to view: SKView) {
        
        levelClearPerfect = true
        currentHighScore = UserDefaults().integer(forKey: "")
        
        timer = GameTimer()
        addChild(timer)
        timer.restartTimer(duration: levelTimerStart)
        shapesOnBoard = []
        
      
        if gameState != "WIN" {
            playerPoints = 0
        }
        
        var i = 0 
        
        while i < gridPositions.count {
            let randomColor = getRandomColor()
            let randomShape = getRandomShape()
            let textureString = randomShape
            shape = ShapeClass(texture: SKTexture(imageNamed: textureString), color: randomColor, size: CGSize(width: 150, height: 150))
            shape.position = startPositions.randomElement()!
            shape.run(SKAction.move(to: gridPositions[i], duration: 0.25))
            shape.delegate = self
            shape.shapeShape = randomShape
            shape.colorBlendFactor = 1
            shape.value = Int.random(in: 1...5)
            shape.label.text = "\(shape.value)"
            shape.label.position = CGPoint(x: 0, y: -20)
            shapesOnBoard.append(shape)
            valuesOnBoard.append(shape.value)
            addChild(shape)
            i += 1
        }
        
        getPlayerTargets()
        
    }
    
    func resetBoard() {
        
        let levelClearBonus = (level * 3) * Int(timer.totalSeconds)
        
        if levelClearPerfect {
           
            playerPoints += levelClearBonus * 2
        } else {
     
            playerPoints += levelClearBonus
        }
        
        levelClearPerfect = true
        
        timer.restartTimer(duration: 30 - CGFloat(level * 2))
        level += 1
        
        shapesOnBoard = []
        
        var i = 0 
        
        while i < gridPositions.count {
            let randomColor = getRandomColor()
            let randomShape = getRandomShape()
            let textureString = randomShape
            shape = ShapeClass(texture: SKTexture(imageNamed: textureString), color: randomColor, size: CGSize(width: 150, height: 150))
            shape.position = startPositions.randomElement()!
            shape.run(SKAction.move(to: gridPositions[i], duration: 0.25))
            shape.delegate = self
            shape.shapeShape = randomShape
            shape.colorBlendFactor = 1
            shape.value = Int.random(in: 1...5)
            shape.label.text = "\(shape.value)"
            shape.label.position = CGPoint(x: 0, y: -20)
            shapesOnBoard.append(shape)
            valuesOnBoard.append(shape.value)
            addChild(shape)
            i += 1
        }
        
        getPlayerTargets()
        
    }
    
    func getPlayerTargets() {
        
        
        if shapesOnBoard.count == 0 {
            resetBoard()
            return
        }
        
      
        shapeIndex = Int.random(in: 0...(shapesOnBoard.count - 1))
        targetColor = shapesOnBoard[shapeIndex].color
        targetShape = shapesOnBoard[shapeIndex].shapeShape
        targetValue = shapesOnBoard[shapeIndex].value
        
    }
    
    func getRandomShape() -> String {
        
        var randomIndex = 0 
        
        switch level {
            
        case 1: randomIndex = Int.random(in: 0...1)
        case 2: randomIndex = Int.random(in: 0...2)
        case 3: randomIndex = Int.random(in: 0...3)
        case 4: randomIndex = Int.random(in: 0...3)
        case 5: randomIndex = Int.random(in: 0...3)
            
        default: print("no levels beyond 5")
        }
        
        let randomShape = shapes[randomIndex]
        return randomShape
        
    }
    
    func getRandomColor() -> UIColor {
        
        var randomIndex = 0 
        
        switch level {
            
        case 1: randomIndex = Int.random(in: 0...1)
        case 2: randomIndex = Int.random(in: 0...2)
        case 3: randomIndex = Int.random(in: 0...3)
        case 4: randomIndex = Int.random(in: 0...3)
        case 5: randomIndex = Int.random(in: 0...3)
            
        default: print("no levels beyond 5")
        }
        
        let randomColor = colors[randomIndex]
        return randomColor
        
    }
    
    func getRandomPosition() -> CGPoint {
        
        let randomPoint = gridPositions.randomElement()
        return randomPoint!
        
    }
    
    func shapeClicked(shape: ShapeClass) {
        
        if targetShape == shape.shapeShape && targetColor == shape.color && shape.value == targetValue {
            
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            shape.removeFromParent()
            playerPoints += (level * 10)
            shapesOnBoard.remove(at: shapeIndex)
            getPlayerTargets()
            
        } else {
            
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            let shake = SKAction.shake(duration: 0.3, amplitudeX: 50, amplitudeY: 50)
            shape.run(shake)
            
            timer.totalSeconds -= CGFloat(1 * level)
            playerPoints -= level * 2
            levelClearPerfect = false
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
      
        if gameState == "PLAYING" {
            isPlaying = true
        } else {
            isPlaying = false
        }
        
        timerCount = timer.totalSeconds
        
        if level > 5 {
            if playerPoints > currentHighScore {
                highScore = playerPoints
                UserDefaults().set(highScore, forKey: "")
            }
            UserDefaults().set(playerPoints, forKey: "")
            isPlaying = false
            gameState = "WIN"
        }
        
        if timer.totalSeconds <= 0 {
            isPlaying = false
            gameState = "LOSS"
        }
    }
}

extension SKAction {
    class func shake(duration:CGFloat, amplitudeX:Int = 3, amplitudeY:Int = 3) -> SKAction {
        let numberOfShakes = duration / 0.015 / 2.0
        var actionsArray:[SKAction] = []
        for _ in 1...Int(numberOfShakes) {
            let dx = CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let dy = CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            let forward = SKAction.moveBy(x: dx, y:dy, duration: 0.015)
            let reverse = forward.reversed()
            actionsArray.append(forward)
            actionsArray.append(reverse)
        }
        return SKAction.sequence(actionsArray)
    }
}
