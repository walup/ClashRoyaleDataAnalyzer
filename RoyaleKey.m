%Class for creating a Key to connect with the clash royale api server
classdef RoyaleKey
    
    properties
        token = "";
    end
    
    
    methods
        
        function obj = setToken(obj,token)
            obj.token = token;
        end
        
        %Write a txt file with your token
        function writeToken(obj,path,tokenName)
            if(~isempty(obj.token))
                %The full path 
                fullPath = path+"/"+tokenName;
                %Open a new file in the path 
                file = fopen(fullPath,'w');
                %write the token into the file 
                fprintf(file,obj.token);
                fclose(file);
            end
        end
        
        %Import token from a .txt file
        function obj = importToken(obj,path)
            file = fopen(path,'r');
            %Format specifier of a string
            formatSpec = '%c';
            tokenString = fscanf(file,formatSpec);
            fclose(file);
            obj = obj.setToken(tokenString);
            
        end
        
    end
    
    
end