extends Node

var playerLife: float = 10
var maxLife: float = 10
var playerStamina: float = 500
var maxStamina: float = 500
var regenStamina: float = 0.5
var swordTime: float = 0
var maxSwordTime: float = 15

const velWalk: int = 75
const velRun: int = 150
const velRoll: int = 200

var positionPlayer: Vector2
var activeSword: bool = false

#var iFrames: bool = false
var recibirDanio: bool = false

var alive: bool = true
var animacion: float = 1
var partidaComenzada = false
var musicVolume: float = -10
var sfxVolume: float
var masterVolume: float

var hexColor:Color = Color("ffffff")
