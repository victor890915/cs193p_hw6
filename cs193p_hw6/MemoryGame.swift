//
//  MemoryGame.swift
//  Memorize_ch5
//
//  Created by 鄭勝偉 on 2023/7/13.
//

import Foundation

struct MemoryGame<CardContent> where CardContent : Equatable{
    private(set) var cards: Array<Card>
    
    private var indexOfTheOnlyFacedUpCard : Int?
    
    private(set) var scoreOfGame : Int = 0
    
    mutating func choose(_ card: Card){
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}) ,
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMathced{
            if let potentialMatchIndex = indexOfTheOnlyFacedUpCard{
                if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                    cards[chosenIndex].isMathced = true
                    cards[potentialMatchIndex].isMathced = true
                    scoreOfGame += 2
                }
                else if (cards[chosenIndex].seenBefore || cards[potentialMatchIndex].seenBefore){
                    scoreOfGame -= 1
                }
                indexOfTheOnlyFacedUpCard = nil
            }else{
                for index in cards.indices{
                    if cards[index].isFaceUp{
                        cards[index].seenBefore = true
                    }
                    if !cards[index].isMathced{
                        cards[index].isFaceUp = false
                    }

                }
                indexOfTheOnlyFacedUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
//            print("\(cards[chosenIndex])")
        }
        
    }
    

    
    init(numberOfPairsOfCards: Int, createCardContent:(Int) -> CardContent){
        cards = Array<Card>()
        for pairindex in 0..<numberOfPairsOfCards{
            let content = createCardContent(pairindex)
            cards.append(Card(content: content, id: pairindex*2))
            cards.append(Card(content: content, id: pairindex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable{

        var isFaceUp: Bool = false
        var isMathced: Bool = false
        var content: CardContent
        var seenBefore: Bool = false
        var id: Int
    }
}
