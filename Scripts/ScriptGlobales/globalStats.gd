extends Node

# Script de variables globales para el manejo del juego

var playerLife: float = 15
var playerDmgIncress:float = 0
var maxLife: float = 15
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
var partidaComenzada: bool = false
var selectStatistic: bool = false
var enemyCounter: int = 0
var maxEnemyCounter: int = 10
var actualLevel: int = 1 
var playerWin: bool = false

var enemyLifeIncrement: float = 1
var enemyDmgIncress: float = 1
var maxSlimeVerde: int = 4
var maxSlimeRojo: int = 3
var maxSlimeMage: int = 2

var maxPickUpsScreen: Array = []

var hexColor:Color = Color("ffffff")

var derecha: bool = true
