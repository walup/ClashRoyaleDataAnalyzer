%% SeasonDayTest
%Create a seaon day converter
seasonDayConverter = SeasonDayConverter();

%% Ok so this required a bit of research but just for reference a date for a season is
dat = "20200301";
daysTillEnd = 35;

%% Writing a new initial condition
seasonDayConverter.writeSeasonInitialCondition("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\SeasonInfo",dat,daysTillEnd);

%% Reading an initial condition
seasonDayConverter = seasonDayConverter.readSeasonInitialCondition("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\SeasonInfo");
%% Get the day of this season 
[n,seasonsPassed,durationOfSeason] = seasonDayConverter.getSeasonDay("20200822");
