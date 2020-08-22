classdef DataAnalyzer
   
    properties
        retriever;
        data  = [];
        DATA_CAP;
        
    end
    
    methods
        %Constructor
        function obj = DataAnalyzer(retriever)
            obj.retriever = retriever;
            obj.DATA_CAP = 10000;
        end
        
        %Gives you a plot of your crown evolution in the last 
        %25 matches
        function recentTrophyEvolution(obj)
            %Get the last matches
            lastMatches = obj.retriever.requestLastMatches();
            n = size(lastMatches,1);
            matchArray = [];
            crownArray = [];
            for i = 1:n
                %Get the ith match
                match = lastMatches(n-i+1);
                if(iscell(match))
                    match = match{1};
                end
                if(match.type == "PvP")
                    count  = match.team.startingTrophies+match.team.trophyChange;
                    matchArray = [matchArray,i];
                    crownArray = [crownArray,count];
                end
            end
            figure()
            plot(matchArray,crownArray,'o-')
            title("Trophy Evolution (Last ladder matches) user: "+obj.retriever.playerTag.playerName);
            xlabel("Match")
            ylabel("Trophy count")
        end
        
        %This function will save the data of your matches 
        %It is O(n) because of the use of the function extractLast25Lines
        %where n is the number of lines in the fle
        function saveMatchData(obj,path)
            %Retrieve the data
            matchData = obj.retriever.requestLastMatches();
            n = size(matchData,1);
            [nLines,stringsToCompare] = obj.extractLast25Lines(path);
            if(nLines > obj.DATA_CAP)
               error("File exceeds the maximum number of data"); 
            end
            file = fopen(path,'a+');
            %For now it is zero but in the new version i will improve this
            %to reflect previous matches which wont be a problem at all
            tiltCounter = 0;
            winCounter = 0;
            tilt = false;
            %More than two losses means you are tilted, more than 2 wins
            %means you are out of the tilt (if you were tilted)
            tiltThreshold = 2; 
            for i= 1:n
                match = matchData(n-i+1);
                win = false;
                if(iscell(match))
                    match = match{1};
                end
                if(match.type == "PvP")
                    %The trophies
                    trophies = match.team.startingTrophies+match.team.trophyChange;
                    %Win and tilt
                    if(match.team.trophyChange > 0)
                        win = true; 
                        if(winCounter>tiltThreshold && tilt)
                            tiltCounter = 0;
                            tilt = false;
                        else
                            winCounter = winCounter+1;
                        end
                    else
                        tiltCounter = tiltCounter +1;
                        %If you've lost more than 2 times then you are tilted
                        if(tiltCounter > tiltThreshold)
                            tilt = true; 
                        end
                    end
                    %Deck
                    deck = match.team.cards;
                    rivalDeck = match.opponent.cards;
                    %Obtain the deck defficiency (this takes constant time because decks always have the same size)
                    defficiency = 0;
                    opponentDefficiency = 0;
                
                    for i = 1:8
                        defficiency = defficiency + (deck(i).maxLevel-deck(i).level);
                        if(iscell(rivalDeck(i)))
                            rivDeck = rivalDeck(i);
                            rivDeck = rivDeck{1};
                            opponentDefficiency = opponentDefficiency + (rivDeck.maxLevel-rivDeck.level);
                            
                        else
                            opponentDefficiency = opponentDefficiency + (rivalDeck(i).maxLevel-rivalDeck(i).level);
                        end
                    end
                    %Obtain the date
                    date = match.battleTime(1:8);
                    %Create a match data holder 
                    dataHolder = MatchDataHolder(trophies,win,tilt,deck,defficiency,opponentDefficiency,date);
                    %Now add this json to the file
                    json = jsonencode(dataHolder);
                    if(~ismember(json,stringsToCompare))
                        fprintf(file,'%s\r\n',json);
                    end
                end
            end
            fclose(file);
        end
        
        %Opens data and returns an array of match data holders
        function obj = openMatchData(obj,path)
            %The array of match data holders
            arr = [];
            file = fopen(path,'r');
            tline  = fgetl(file);
            jsonData = jsondecode(tline);
            matchData = MatchDataHolder(jsonData.trophies,jsonData.win, jsonData.tilt,jsonData.deck,jsonData.deckDefficiency,jsonData.enemyDeckDefficiency,jsonData.date);
            arr = [arr,matchData];
            
            while true
                
               tline = fgetl(file);
               if(ischar(tline))
                    jsonData = jsondecode(tline);
                    matchData = MatchDataHolder(jsonData.trophies,jsonData.win, jsonData.tilt,jsonData.deck,jsonData.deckDefficiency,jsonData.enemyDeckDefficiency,jsonData.date);
                    arr = [arr,matchData];
               else
                   break;
               end
            end
            
            obj.data = arr;
        end
        
        %Obtains a plot of the stored trophy history
        function totalTrophyEvolution(obj)
            matchArray  = [];
            trophiesArray = [];
            counter = 0;
            if(~isempty(obj.data))
                for i = 1:length(obj.data)
                    match = obj.data(i);
                    counter = counter+1;
                    matchArray = [matchArray,counter];
                    trophiesArray = [trophiesArray,match.trophies];
                end
                
                figure()
                plot(matchArray,trophiesArray,'o-')
                title("Trophy Evolution (Last ladder matches) user: "+obj.retriever.playerTag.playerName);
                xlabel("Match")
                ylabel("Trophy count")
            else
                error("No data to process, open a data file using the instruction openMatchData")
            end            
        end
        
        
        %Auxiliiary function to extract last 25 matches in a log
        function [counter,a] = extractLast25Lines(obj,path)
            a = strings([25,1]);
            fid=fopen(path,'r');
            tline = fgetl(fid);
            counter = 0;
            a(mod(counter,25)+1) = tline;
            
            while ischar(tline)
                counter = counter+1;
                tline = fgetl(fid);
                a(mod(counter,25)+1) = tline;
            end
            %Counter should  be the number of lines at the end
            counter  = counter+1;
            fclose(fid);
        end
        
        
        
    end
    
    
    
    
end