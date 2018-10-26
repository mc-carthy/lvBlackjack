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
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(images.card, x, y)
    love.graphics.setColor(0, 0, 0)
    love.graphics.draw(images[card.rank], x + 3, y + 4)
    love.graphics.print(card.suit, x, y + 15)
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