%Import the token
token = RoyaleKey();
token = token.importToken("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalizer\Tokens\my_token.txt");

%Import the player tag
tag = PlayerTag("walup");
tag = tag.importTag("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalizer\Tags\walup.txt");

%Create a new data retriever
dataRetriever = DataRetriever(token);
%Give it a player tag
dataRetriever = dataRetriever.setPlayerTag(tag);
%Create the Data Analyzer
dataAnalyzer = DataAnalyzer(dataRetriever);
%Give it a player tag
dataRetriever = dataRetriever.setPlayerTag(tag);
%% Recent trophy evolution
dataAnalyzer.recentTrophyEvolution();
%% Saving data
dataAnalyzer.saveMatchData("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\MatchData\walup.txt");
%% Retrieving saved data
dataAnalyzer = dataAnalyzer.openMatchData("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\MatchData\walup.txt");
%% Plotting the whole trophy evolution
dataAnalyzer.totalTrophyEvolution();