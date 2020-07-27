%Class for creating a Key to connect with the clash royale api server
classdef PlayerTag
    
    properties
        playerName = "";
        tag = "";
        modifiedTag = "";
    end
    
    
    methods
        function obj = PlayerTag(name)
           obj.playerName = name; 
        end
        
        
        
        function obj = setTag(obj,tag)
            obj.tag = tag;
            %The hexadecimal representation of # ASCII is 23
            obj.modifiedTag = "%23"+tag(2:end);
            
        end
        
        %Write a txt file with your token
        function writeTag(obj,path)
            %The full path 
            fullPath = path+"/"+obj.playerName+".txt";
            if(~isempty(obj.tag) && ~isfile(fullPath))
                %Open a new file in the path 
                file = fopen(fullPath,'w');
                %write the tag into the file 
                fprintf(file,obj.tag);
                fclose(file);
            elseif(isempty(obj.tag))
                error("Tag is empty");    
            elseif(isfile(fullPath))
                error("The file already exists")
            end
        end
        
        %Import tag from a .txt file
        function obj = importTag(obj,path)
            file = fopen(path,'r');
            %Format specifier of a string
            formatSpec = '%c';
            tagString = fscanf(file,formatSpec);
            fclose(file);
            obj = obj.setTag(tagString);
        end
        
    end
    
    
end