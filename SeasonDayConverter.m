%Converts a given day in the format yyyymmdd to the corresponding day of
%the season will last 28 days if it has 4 mondays and it will last 35 days
%if it has 5 mondays.


classdef SeasonDayConverter
    
    properties 
        initialDate = "";
        daysMissingOnInitialDate = 0;
        fileName = "init_cond.txt";        
    end 
    
    
    methods
        
        function obj = writeSeasonInitialCondition(obj,path,initialDate,daysMissingOnInitialDate)
            
            %Initial date originally will be in the format yyyymmdd and we
            %neef to change it to dd-mm-yyyy
            newInitDate = "";
            newInitDate = newInitDate+initialDate{1}(7:8)+"-"+initialDate{1}(5:6)+"-"+initialDate{1}(1:4);
            obj.initialDate = newInitDate;
            obj.daysMissingOnInitialDate = daysMissingOnInitialDate;
            %Store the initial condition in a structure 
            dataContainer.initialDate = newInitDate;
            dataContainer.daysMissingOnInitialDate = daysMissingOnInitialDate;
            %Full path to write on 
            fullPath = path+"/"+obj.fileName;
            file = fopen(fullPath,'w');
            jsonString = jsonencode(dataContainer);
            fprintf(file,jsonString);            
            fclose(file);
        end
        
        function obj = readSeasonInitialCondition(obj,path)
            fullPath = path+"/"+obj.fileName;
            file = fopen(fullPath,'r');
            tline  = fgetl(file);
            %Decode the json
            structure = jsondecode(tline);
            %Read the season initial conditions
            obj.initialDate = structure.initialDate;
            obj.daysMissingOnInitialDate = structure.daysMissingOnInitialDate;
        end
        
        %Gets the season day using a date and also the seasons that have passed since the initial condition season 
        %The order of this algorithm is O(d) where d is the number of
        %seasons passed since the initial condition, d can be controlled by
        %updating the initial condition, but it shouldn't be a big problem
        %if you don't do it for a year
        function [n,seasonsPassed,duration] = getSeasonDay(obj,date)
            
            if(obj.initialDate ~= "" && obj.daysMissingOnInitialDate~= 0)
            %Put the date in a better format
            date = date{1}(7:8)+"-"+date{1}(5:6)+"-"+date{1}(1:4);
            d = datetime(date,'InputFormat','dd-MM-yyyy');
            %Now this is the heavy part, and i might change it in the
            %future  but i'm actually going to use the initial conditions
            %to find out when the season currently being examined started
            foundSeason = false;
            initDate = datetime(obj.initialDate,'InputFormat','dd-MM-yyyy');
            endOfSeasonDays = obj.daysMissingOnInitialDate;
            seasonsPassed= 0;
            while(foundSeason == false)
                %Get the duration of the season
                if(seasonsPassed == 0)
                    duration = obj.getSeasonDuration(initDate);
                else
                    duration = endOfSeasonDays;
                end
                
                if(d >= initDate && d<initDate+days(endOfSeasonDays))
                    n  = duration-obj.daysBetween(d,initDate+days(endOfSeasonDays));
                    foundSeason = true;
                else
                    initDate = initDate+days(endOfSeasonDays);
                    endOfSeasonDays = obj.getSeasonDuration(initDate+days(3));
                    seasonsPassed = seasonsPassed+1;
                end
            end
            
            else
                error("Please open some initial date conditions first. Make sure to update them once in a while too using writeSeasonInitialConditions");
            end
        end
        
        
        function n = getSeasonDuration(obj,refDate)
           if(obj.initialDate ~= "" && obj.daysMissingOnInitialDate~= 0)
               %Get the month of the  reference date
               m = month(refDate);
               %Get the year of the reference date
               y = year(refDate);
               %Get the number of mondays in the current month
               mondays = obj.numberOfMondaysInMonth(m,y);
               if(mondays == 5)
                   n = 35;
               elseif(mondays == 4)
                   n = 28;
               end
           end
        end
        
        
        function n = numberOfMondaysInMonth(obj, m,y)
            n = 1;
            daysInMonth = obj.numberOfDaysInMonth(m,y);
            %We will get the day of the first monday 
            day  = 1;
            isMonday = false;
            while(~isMonday)
                if(weekday(datetime(y,m,day)) == 2)
                    isMonday = true;
                else
                    day = day+1;
                end
            end
            
            %Now that we have the first monday we can  do some calculations
            %to get the rest of the mondays
            n = n+fix((daysInMonth-day)/7);            
        end
        
        
        
        function n = numberOfDaysInMonth(obj,m,y)
            result = obj.leap(y);
            if (m<1) || (m>12)
                disp('month ERROR');
            elseif (m==2 && result==0)
                n = 28;
            elseif (m==2 && result==1)
                n = 29;
            elseif (m==1||m == 3||m == 5||m == 7||m == 8||m == 10||m == 12)
                n = 31;
            elseif (m==4||m == 6||m == 9||m == 11)
                n = 30;
            end
        end
        
        function y = leap(obj,x)
            y = false;
           if(mod(x,4) == 0 && mod(x,100)~= 0)
              y = true;
           elseif(mod(x,100) == 0 && mod(x,400) == 0)
               y = true;
           end               
        end
         
        function  n = daysBetween(obj,a,b)
            n = caldays(between(a,b,'days'));
        end
               
    end
       
        
 end 
    
    
    
    
    