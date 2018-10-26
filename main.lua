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
    
    print('Player hand:')
    for cardIndex, card in ipairs(playerHand) do
        print('suit: '.. card.suit ..', rank: '.. card.rank)
    end
    print('Total number of cards in deck: '.. #deck)
    
end

function love.update(dt)
    
end

function love.draw()
    local output = {}
    
    table.insert(output, 'Player hand:')
    for cardIndex, card in ipairs(playerHand) do
        table.insert(output, 'suit: '.. card.suit ..', rank: '.. card.rank)
    end
    table.insert(output, getTotal(playerHand))
    
    table.insert(output, '')
    
    table.insert(output, 'Dealer hand:')
    for cardIndex, card in ipairs(dealerHand) do
        table.insert(output, 'suit: '.. card.suit ..', rank: '.. card.rank)
    end
    table.insert(output, getTotal(dealerHand))

    if roundOver then
        table.insert(output, '')

        if hasHandWon(playerHand, dealerHand) then
            table.insert(output, 'Player wins')
        elseif hasHandWon(dealerHand, playerHand) then
            table.insert(output, 'Dealer wins')
        else
            table.insert(output, 'Draw')
        end
    end
    
    love.graphics.print(table.concat(output, '\n'), 15, 15)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if not roundOver then
        if key == 'h' and not roundOver then
            takeCard(playerHand)
        elseif key == 's' then
            roundOver = true
        end
    else
        love.load()
    end
end