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


function love.load()
    roundOver = false
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
    -- local output = {}
    
    -- table.insert(output, 'Player hand:')
    -- for cardIndex, card in ipairs(playerHand) do
    --     table.insert(output, 'suit: '.. card.suit ..', rank: '.. card.rank)
    -- end
    -- table.insert(output, getTotal(playerHand))
    
    -- table.insert(output, '')
    
    -- table.insert(output, 'Dealer hand:')
    -- for cardIndex, card in ipairs(dealerHand) do
    --     if not roundOver and cardIndex == 1 then
    --         table.insert(output, '(Card hidden)')
    --     else
    --         table.insert(output, 'suit: '.. card.suit ..', rank: '.. card.rank)
    --     end
    -- end
    -- if roundOver then
    --     table.insert(output, getTotal(dealerHand))
    -- else
    --     table.insert(output, '?')
    -- end

    -- if roundOver then
    --     table.insert(output, '')

    --     if hasHandWon(playerHand, dealerHand) then
    --         table.insert(output, 'Player wins')
    --     elseif hasHandWon(dealerHand, playerHand) then
    --         table.insert(output, 'Dealer wins')
    --     else
    --         table.insert(output, 'Draw')
    --     end
    -- end
    
    -- love.graphics.print(table.concat(output, '\n'), 15, 15)

    for cardIndex, card in ipairs(playerHand) do
        drawCard(card, (cardIndex - 1) * 60, 0)
    end
    
    for cardIndex, card in ipairs(dealerHand) do
        drawCard(card, (cardIndex - 1) * 60, 80)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if not roundOver then
        if key == 'h' and not roundOver then
            takeCard(playerHand)
            if getTotal(playerHand) >= 21 then
                roundOver = true
            end
        elseif key == 's' then
            roundOver = true
        end

        if roundOver then
            while getTotal(dealerHand) < 17 do
                takeCard(dealerHand)
            end
        end
    else
        love.load()
    end
end