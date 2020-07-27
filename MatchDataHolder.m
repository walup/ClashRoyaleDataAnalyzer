classdef MatchDataHolder
    properties
        %Ammount of trophies
        trophies;
        %Did you win?
        win;
        %Are you tilted
        tilt;
        %Deck you are using
        deck;
        %Deck defficiency is defined as the sum of (maxlevelcard-currentlevelcard)
        %I might account for actual counters later but i need to
        %familiarize myself more with what the counters are 
        deckDefficiency;
        enemyDeckDefficiency;
    end
    
    methods
        function obj = MatchDataHolder(trophies,win,tilt,deck, deckDefficiency,enemyDeckDefficiency)
            obj.trophies = trophies;
            obj.win = win;
            obj.tilt = tilt;
            obj.deck = deck;
            obj.deckDefficiency = deckDefficiency;
            obj.enemyDeckDefficiency = enemyDeckDefficiency;
        end
    end
    
    
end