classdef SeasonAnalyzer
    
    properties
        %our season day converter 
        seasonDayConverter;
        %our intervals
        cardLevelInterval;
        dayInterval;
        %our grids
        cardLevelGrid;
        dayGrid;
        normalizedFrequencyGrid;
        %Resolution for our grids
        cardLevelResolution;
        dayResolution;  
        initialConditionPath = "C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\SeasonInfo";
    end
    
    
    methods
        %SeasonData will be an array of match data holders
        function obj  = SeasonAnalyzer(obj)
            %initialize the season day converter 
            obj.seasonDayConverter = SeasonDayConverter();
            obj.seasonDayConverter = obj.seasonDayConverter.readSeasonInitialCondition(obj.initialConditionPath);
            %Initialize the trophy and day resolution
            obj.cardLevelResolution = 0.1;
            obj.dayResolution = 1;
            %We can create the trophy interval the interval for the days
            %will depend on whether we are talking about a short season or
            %a long one and it will have to wait till we receive this
            %respective data
            endCardLevel = 13;
            initCardLevel = 9;
            n = (endCardLevel-initCardLevel)/obj.cardLevelResolution;
            cardLevelInterval = linspace(initCardLevel,endCardLevel,n);
            obj.cardLevelInterval= cardLevelInterval; 
            
        end
        
        %This function should be O(n*d) where d would be the maximum number
        %of seasons that has passed since the initial condition stablished
        %for the match data holder and any of the dataHolders passed to the
        %function and n would be the number of dataHolders passed to the
        %function. So as long as we keep d small this should be for all purposes O(n)
        
        function [dayGrid,cardLevelGrid,frequencyGrid] = computeFrequencyGrid(obj,dataHolders,league)
            %Get the season you want to analyze and the duration of the
            %season
            [low,high] = league.getInterval();
            sampleDataHolder = dataHolders(1);
            [~,seasonsPassed,durationOfSeason] =obj.seasonDayConverter.getSeasonDay(convertCharsToStrings(sampleDataHolder.date));
            %with that info you can obtain our dayGrid that we are missing
            %currently
            initDay = 1;
            finalDay = double(durationOfSeason);
            arrayLength = double(((finalDay-initDay)/obj.dayResolution)+1);
            disp(finalDay);
            dayInterval = linspace(initDay,finalDay,arrayLength);
            obj.dayInterval = dayInterval;
            %create the grids
            [dayGrid,cardLevelGrid] = meshgrid(obj.dayInterval,obj.cardLevelInterval);
            obj.dayGrid = dayGrid;
            obj.cardLevelGrid = cardLevelGrid;
            %Obtain the length of the data Holders
            n = length(dataHolders);
            frequencyGrid = zeros(size(dayGrid,1),size(dayGrid,2));
            maxCardLevel = 13;
            numberOfCardsInDeck = 8;
            initCardLevel = 9;
            for i = 1:n
               holder = dataHolders(i); 
               date = holder.date;
               [seasonDay,seasons,~] = obj.seasonDayConverter.getSeasonDay(convertCharsToStrings(date));
               %if we are on the same season
               if(seasons == seasonsPassed)
                   %we want to get the average level card from the deck
                   %defficiency
                   rivalDeckAvg = maxCardLevel - holder.enemyDeckDefficiency/numberOfCardsInDeck;
                   %we will get the index int he grid for such a value
                   if(rivalDeckAvg >= 9 && holder.trophies >= low && holder.trophies <= high)
                    indexCardLevel = round((rivalDeckAvg-initCardLevel)/obj.cardLevelResolution);
                    disp(rivalDeckAvg);
                    disp(indexCardLevel);
                    frequencyGrid(indexCardLevel,seasonDay) = frequencyGrid(indexCardLevel,seasonDay)+1;
                   end
               end
            end
            
            %some processing of the league's name so that the title will
            %look nice
            
            leagueName = string(league);
            leagueName = strrep(leagueName,'_',' ');
            
            
            figure();
            %hold on 
            sgtitle("Card level distribution during season for league " + leagueName)
            imagesc(obj.dayInterval,obj.cardLevelInterval,frequencyGrid)
            xlabel("Day of season")
            ylabel("Average card level")
            set(gca,'YDir','normal')
            %hold off
        end
        
        
        
    end    
end

