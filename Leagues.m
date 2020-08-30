classdef Leagues < uint32
    enumeration
        Challenger_I (4000);
        Challenger_II (4300);
        Challenger_III (4600);
        Master_I (5000);
        Master_II (5300);
        Master_III (5600);
        Champion (6000);
        Grand_Champion (6300);
        Royal_Champion (6600);
        Ultimate_Champion (7000); 
    end
    
    methods
        function [low,high] = getInterval(obj)
            low = uint32(obj);
            if(obj == Leagues.Challenger_I)
                high = uint32(Leagues.Challenger_II);
            elseif(obj == Leagues.Challenger_II)
                high = uint32(Leagues.Challenger_III);
            elseif(obj == Leagues.Challenger_III)
                high = uint32(Leagues.Master_I);
            elseif(obj == Leagues.Master_I)
                high = uint32(Leagues.Master_II);
            elseif(obj == Leagues.Master_II)
                high = uint32(Leagues.Master_III);
            elseif(obj == Leagues.Master_III)
                high = uint32(Leagues.Champion);
            elseif(obj == Leagues.Champion)
                high = uint32(Leagues.Grand_Champion);
            elseif(obj == Leagues.Grand_Champion)
                high = uint32(Leagues.Royal_Champion);
            elseif(obj == Leagues.Royal_Champion)
                high = uint32(Leagues.Ultimate_Champion);
            elseif(obj == Leagues.Ultimate_Champion)
                high = 9000;
            end
        end
    end
    
    
    
end