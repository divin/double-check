-- Playdate SDK Core Libraries
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
import "CoreLibs/timer"
import "CoreLibs/easing"
import "CoreLibs/ui"

-- Import libraries
import "libraries/gridView"
import "libraries/icons/icon"
import "libraries/sceneManager"

-- Import scenes
import "scenes/gameMenuScene"

-- Define shorthands
local pd <const> = playdate
local gfx <const> = pd.graphics

ITEMS = {
    "Nothing",
    "Bag",
    "Beard",
    "Bottle",
    "Dog",
    "Glasses",
    "Headphones",
    "Longsleeve",
    "Shirt",
    "Shoes",
    "Shorts",
    "Socks",
    "T-Shirt",
    "Trousers",
}

NEEDED_ITEMS = {}
MISSING_ITEMS = {}

CURRENT_SCORE = 0
MAX_HEARTS = 3
CURRENT_HEARTS = MAX_HEARTS
HIGH_SCORE_TABLE_FILE_NAME = "highScoreTable"

-- Switch to the game menu scene
SCENE_MANAGER = SceneManager()
SCENE_MANAGER:switchScene(GameMenuScene)

local samplePlayer = pd.sound.sampleplayer.new("assets/sounds/fx/loop.wav")
samplePlayer:play(0)

-- Main loop
function pd.update()
    -- Update sprite & timers
    gfx.sprite.update()
    pd.timer.updateTimers()
    -- pd.drawFPS(5, 225)
end
