local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class HighScore : pd_sprite
--- @field fileName string The file name of the high score
--- @field topN number The number of high scores to display
class("HighScoreTable").extends(gfx.sprite)

--- Initializes the high score
-- @param x number The x position of the high score
-- @param y number The y position of the high score
-- @param fileName string The file name of the high score
-- @param topN number The number of high scores to display
-- @return nil
function HighScoreTable:init(x, y, fileName, isVisible)
    HighScoreTable.super.init(self)

    self.topN = 3
    self.width = 250
    self.height = 150
    self.fileName = fileName or "highScoreTable"
    self.highScores = self:loadScores()

    local image = self:createImage()
    self:setImage(image)
    self:setVisible(isVisible or false)
    self:setCenter(0.5, 0.5)
    self:setZIndex(99)
    self:moveTo(x, y)
    self:add()
end

--- Load the high scores
-- @return table The high scores
-- @return nil
function HighScoreTable:loadScores()
    local highScores = {}

    if pd.file.exists(self.fileName .. ".json") then
        highScores = pd.datastore.read(self.fileName)
    else
        pd.datastore.write(highScores, self.fileName)
    end

    return highScores
end

--- Save the high scores
-- @return nil
function HighScoreTable:saveScores()
    table.insert(self.highScores, CURRENT_SCORE)
    table.sort(self.highScores, function(a, b) return a > b end)
    while #self.highScores > self.topN do
        table.remove(self.highScores, #self.highScores)
    end
    pd.datastore.write(self.highScores, self.fileName)
end

--- Create the image
-- @return pd_image The image
-- @return nil
function HighScoreTable:createImage()
    local offset = 10
    local image = gfx.image.new(self.width + offset, self.height + offset)

    gfx.pushContext(image)
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(5, 5, self.width + offset, self.height + offset)

    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, self.width + offset / 2, self.height + offset / 2)

    gfx.setColor(gfx.kColorBlack)
    gfx.drawRect(0, 0, self.width + offset / 2, self.height + offset / 2)

    gfx.drawText("*High Scores*", 10, 10)

    for index, score in ipairs(self.highScores) do
        local placeText = tostring(index) .. "."
        local scoreText = tostring(score)

        if index == 1 then
            placeText = "*" .. tostring(index) .. ".*"
            scoreText = "*" .. tostring(score) .. "*"
        end

        local textHeight = gfx.getSystemFont():getHeight()
        local textWidth = gfx.getSystemFont():getTextWidth("0000")

        local x = 20
        local y = textHeight + index * (textHeight + 10)
        gfx.drawText(placeText, x, y)
        gfx.drawLine(x + 20, y + (textHeight / 2),
            self.width - (40 + textWidth),
            textHeight + index * (textHeight + 10) + (textHeight / 2))
        gfx.drawText(scoreText, self.width - (x + textWidth), y)
    end

    gfx.popContext()

    return image
end
