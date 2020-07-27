
%This is my simplified interface to retrieve data i'm interested in and
%that i might use to do some statistics
classdef DataRetriever
    
    
    properties
       %The token 
       key;
       %An optional player tag
       playerTag = "";
       %The base url
       url = "https://api.clashroyale.com/v1";
       authorization;
       options;
    end
    
    
    methods
        
        function obj = DataRetriever(token)
           obj.key = token;
           obj.authorization = {'Authorization', ['Bearer ', obj.key.token]};
           obj.options = weboptions('HeaderFields', obj.authorization, 'ContentType','json');
        end
        
        function obj = setPlayerTag(obj,playerTag) 
           obj.playerTag = playerTag;
        end
        
        
        function resp = requestLastMatches(obj)
           if(~isempty(obj.playerTag))
               req = obj.url+"/players/"+obj.playerTag.modifiedTag+"/"+"battlelog";
               resp = webread(req,obj.options);
           else
               error("A player tag needs to be specified before retrieving this information");               
           end
        end
        
        
        function resp = requestPlayerInfo(obj)
           if(~isempty(obj.playerTag))
               req = obj.url+"/players/"+obj.playerTag.modifiedTag;
               resp = webread(req,obj.options);
           else
               error("A player tag needs to be specified before retrieving this information");
           end
        end
        
    end
end