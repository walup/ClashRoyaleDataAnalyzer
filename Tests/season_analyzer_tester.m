%% Create a season analyzer
seasonAnalyzer = SeasonAnalyzer();
%% Prepare some data to process for the analyzer
token = RoyaleKey();
token = token.importToken("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\Tokens\my_token.txt");
tag = PlayerTag("walup");
tag = tag.importTag("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\Tags\walup.txt");
dataRetriever = DataRetriever(token);
dataRetriever = dataRetriever.setPlayerTag(tag);
dataHandler = DataHandler(dataRetriever);
%update the data of the data handler
dataHandler.saveMatchData("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\MatchData\walup.txt");
%load the saved data
dataHandler = dataHandler.openMatchData("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\MatchData\walup.txt");
%% 
[dayGrid,trophyGrid,frequencyGrid] = seasonAnalyzer.computeFrequencyGrid(dataHandler.data,Leagues.Master_I);
