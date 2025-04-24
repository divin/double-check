local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class TimeCounter : pd_sprite
--- @field timer pd_timer The timer for the time counter
--- @field radius number The radius of the time counter
class("TimeCounter").extends(gfx.sprite)

--- Initializes the time counter
-- @param x number The x position of the time counter
-- @param y number The y position of the time counter
-- @param radius number The radius of the time counter
-- @param timer pd_timer The timer for the time counter
-- @return nil
function TimeCounter:init(x, y, radius, timer)
    TimeCounter.super.init(self)

    self.timer = timer
    self.radius = radius
    self.currentTime = self.timer.currentTime
    self.samplePlayer = pd.sound.sampleplayer.new("assets/sounds/fx/tick-01.wav")
    local image = self:createImage()
    self:setImage(image)
    self:setCenter(0.5, 0.5)
    self:moveTo(x, y)
    self:add()
end

--- Create the image for the timer counter
function TimeCounter:createImage()
    local lineWidth = 3
    local image = gfx.image.new(2 * (self.radius + lineWidth), 2 * (self.radius + lineWidth))

    -- Get the start and end angle based on the current time
    local startAngle = 0
    local endAngle = 360 * (self.timer.timeLeft / self.timer.duration)
    local text = tostring(math.ceil(self.timer.timeLeft / 1000))

    -- Play a sound effect every second
    if not self.samplePlayer:isPlaying() then
        local elapsedTime = self.timer.currentTime - self.currentTime
        if elapsedTime > 1000 then
            self.samplePlayer = pd.sound.sampleplayer.new("assets/sounds/fx/tick-01.wav")
            self.samplePlayer:play()
            self.currentTime = self.timer.currentTime
        end
    end

    local fontHeight = gfx.getSystemFont():getHeight()
    local fontWidth = gfx.getSystemFont():getTextWidth(text)

    gfx.pushContext(image)
    gfx.setLineWidth(lineWidth)
    gfx.drawArc(self.radius, self.radius, self.radius, startAngle, endAngle)
    gfx.setLineWidth(1)
    gfx.drawText(tostring(math.ceil(self.timer.timeLeft / 1000)), self.radius - (fontWidth / 2),
        self.radius + 2 - (fontHeight / 2))
    gfx.popContext()

    return image
end

--- Update the time counter
function TimeCounter:update()
    self:setImage(self:createImage())
end
