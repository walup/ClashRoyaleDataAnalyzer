classdef DataAnalyzer
   
    properties
        retriever;
    end
    
    methods
        %Constructor
        function obj = DataAnalyzer(retriever)
            obj.retriever = retriever;
        end
        
        %Gives you a plot of your crown evolution in the last 
        %25 matches
        function y = recentTrophyEvolution(obj)
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
                disp(match);
                if(i == 1)
                    count  = match.team.startingTrophies;
                    matchArray = [matchArray,i];
                    crownArray = [crownArray,count];
                else
                    if(count ~= match.team.startingTrophies)
                       count  = match.team.startingTrophies;
                       matchArray = [matchArray,i];
                       crownArray = [crownArray,count];
                    end
                    
                end
            end
            figure()
            plot(matchArray,crownArray,'o-')
            title("Trophy Evolution (Last ladder matches) user: "+obj.retriever.playerTag.playerName);
            xlabel("Match")
            ylabel("Trophy count")
        end
        
        
        function y = saveTrophyData(obj)
            
            
        end
        
        function y = openTrophyData(obj)
            
            
            
        end
        
    end
    
    
    
    
end