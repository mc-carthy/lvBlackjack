-- require('src.utils.debug')

function takeCard(hand)
    table.insert(hand, table.remove(deck, love.math.random(#deck)))
end

function getTotal(hand)
    local total = 0
    local hasAce = false
    
    for k, card in pairs(hand) do
        if card.rank > 10 then
            total = total + 10
        else
            total = total + card.rank
        end

        if card.rank == 1 then
            hasAce = true
        end
    end

    if hasAce and total <= 11 then
        total = total + 10
    end
    
    return total
end

function hasHandWon(thisHand, otherHand)
    return getTotal(thisHand) <= 21 and (getTotal(otherHand) > 21 or getTotal(thisHand) > getTotal(otherHand))
end

function drawCard(card, x, y)
    local cardWidth, cardHeight = 53, 73
    local numberOffsetX, numberOffsetY = 3, 4
    local suitOffsetX, suitOffsetY = 3, 14
    local suitImage = images['mini_' .. card.suit]

    local function drawCorner(image, offsetX, offsetY)
        love.graphics.draw(image, x + offsetX, y + offsetY)
        love.graphics.draw(image, x + cardWidth - offsetX, y + cardHeight - offsetY, 0, -1, -1)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(images.card, x, y)

    if card.suit == 'heart' or card.suit == 'diamond' then
        love.graphics.setColor(0.89, 0.06, 0.39)
    else
        love.graphics.setColor(0.2, 0.2, 0.2)
    end

    drawCorner(images[card.rank], numberOffsetX, numberOffsetY)
    drawCorner(suitImage, suitOffsetX, suitOffsetY)

    if card.rank > 10 then
        local faceImage
        if card.rank == 11 then
            faceImage = images.face_jack
        elseif card.rank == 12 then
            faceImage = images.face_queen
        elseif card.rank == 13 then
            faceImage = images.face_king
        end
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(faceImage, x + 12, y + 11)
    else
        local function drawPip(offsetX, offsetY, mirrorX, mirrorY)
            local pipImage = images['pip_' .. card.suit]
            local pipWidth = 11

            love.graphics.draw(pipImage, x + offsetX, y + offsetY)
            if mirrorX then
                love.graphics.draw(pipImage, x + cardWidth - offsetX - pipWidth, y + offsetY)
            end
            if mirrorY then
                love.graphics.draw(pipImage, x + offsetX + pipWidth, y + cardHeight - offsetY, 0, -1, -1)
            end
            if mirrorX and mirrorY then
                love.graphics.draw(pipImage, x + cardWidth - offsetX, y + cardHeight - offsetY, 0, -1, -1)
            end
        end

        local xLeft, xMid = 11, 21
        local yTop, yThird, yQtr, yMid = 7, 19, 23, 31

        if card.rank == 1 then
            drawPip(xMid, yMid)
        elseif card.rank == 2 then
            drawPip(xMid, yTop, false, true)
        elseif card.rank == 3 then
            drawPip(xMid, yTop, false, true)
            drawPip(xMid, yMid)
        elseif card.rank == 4 then
            drawPip(xLeft, yTop, true, true)
        elseif card.rank == 5 then
            drawPip(xLeft, yTop, true, true)
            drawPip(xMid, yMid)
        elseif card.rank == 6 then
            drawPip(xLeft, yTop, true, true)
            drawPip(xLeft, yMid, true)
        elseif card.rank == 7 then
            drawPip(xLeft, yTop, true, true)
            drawPip(xLeft, yMid, true)
            drawPip(xMid, yThird)
        elseif card.rank == 8 then
            drawPip(xLeft, yTop, true, true)
            drawPip(xLeft, yMid, true)
            drawPip(xMid, yThird, false, true)
        elseif card.rank == 9 then
            drawPip(xLeft, yTop, true, true)
            drawPip(xLeft, yQtr, true, true)
            drawPip(xMid, yMid)
        elseif card.rank == 10 then
            drawPip(xLeft, yTop, true, true)
            drawPip(xLeft, yQtr, true, true)
            drawPip(xMid, 16, false, true)
        end
    end
end

function isMouseInButton(buttonX, buttonWidth)
    return love.mouse.getX() >= buttonX and 
        love.mouse.getX() < buttonX + buttonWidth and 
        love.mouse.getY() >= buttonY and 
        love.mouse.getY() < buttonY + buttonHeight
end

function love.load()
    roundOver = false
    buttonY = 230
    buttonHeight = 25

    buttonHitX = 10
    buttonHitWidth = 53

    buttonStandX = 70
    buttonStandWidth = 53

    buttonPlayAgainX = 10
    buttonPlayAgainWidth = 113

    deck = {}
    for suitIndex, suit in ipairs({ 'club', 'diamond', 'heart', 'spade' }) do
        for rank = 1, 13 do
            print('suit: '..suit..', rank: '..rank)
            table.insert(deck, { suit = suit, rank = rank })
        end
    end

    playerHand = {}
    takeCard(playerHand)
    takeCard(playerHand)
    
    dealerHand = {}
    takeCard(dealerHand)
    takeCard(dealerHand)
    
    images = {}
    for nameIndex, name in ipairs({
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
        'pip_heart', 'pip_diamond', 'pip_club', 'pip_spade',
        'mini_heart', 'mini_diamond', 'mini_club', 'mini_spade',
        'card', 'card_face_down',
        'face_jack', 'face_queen', 'face_king',
    }) do
        images[name] = love.graphics.newImage('images/'..name..'.png')
    end
end

function love.update(dt)
    
end

function love.draw()
    love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.setColor(1, 1, 1)
    local cardSpacing, marginX = 60, 10
    for cardIndex, card in ipairs(dealerHand) do
        local dealerMarginY = 30
        if not roundOver and cardIndex == 1 then
            love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
        else
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 30)
        end
    end

    for cardIndex, card in ipairs(playerHand) do
        drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
    end

    love.graphics.setColor(0, 0, 0)

    if roundOver then
        love.graphics.print('Total: '.. getTotal(dealerHand), marginX, 10)
    else
        love.graphics.print('Total: ?', marginX, 10)
    end

    love.graphics.print('Total: '.. getTotal(playerHand), marginX, 120)

    if roundOver then
        local function drawWinner(message)
            love.graphics.print(message, marginX, 268)
        end

        if hasHandWon(playerHand, dealerHand) then
            drawWinner('Player wins')
        elseif hasHandWon(dealerHand, playerHand) then
            drawWinner('Dealer wins')
        else
            drawWinner('Draw')
        end
    end

    local function drawButton(text, buttonX, buttonWidth, textOffsetX)
        if isMouseInButton(buttonX, buttonWidth) then
            love.graphics.setColor(1, 0.8, 0.3)
        else
            love.graphics.setColor(1, 0.5, 0.2)
        end
        love.graphics.rectangle('fill', buttonX, buttonY, buttonWidth, 25)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(text, buttonX + textOffsetX, buttonY + 6)
    end

    if roundOver then
        drawButton('Play again', buttonPlayAgainX, buttonPlayAgainWidth, 24)
    else
        drawButton('Hit!', buttonHitX, buttonHitWidth, 16)
        drawButton('Stand', buttonStandX, buttonStandWidth, 8)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousereleased()
    function love.mousereleased()
        if not roundOver then
            if isMouseInButton(buttonHitX, buttonHitWidth) then
                takeCard(playerHand)
                if getTotal(playerHand) > 21 then
                    roundOver = true
                end
            elseif isMouseInButton(buttonStandX, buttonStandWidth) then
                roundOver = true
            end
    
            if roundOver then
                while getTotal(dealerHand) < 17 do
                    takeCard(dealerHand)
                end
            end
        elseif isMouseInButton(buttonPlayAgainX, buttonPlayAgainWidth) then
            love.load()
        end
    end
end