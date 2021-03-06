%Import the token
token = RoyaleKey();
token = token.importToken("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\Tokens\my_token.txt");

%Import the player tag
tag = PlayerTag("walup");
tag = tag.importTag("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\Tags\walup.txt");

%Create a new data retriever
dataRetriever = DataRetriever(token);
%Give it a player tag
dataRetriever = dataRetriever.setPlayerTag(tag);
%Create the Data Handler
dataHandler = DataHandler(dataRetriever);
%% Recent trophy evolution
dataHandler.recentTrophyEvolution();
%% Saving data
dataHandler.saveMatchData("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\MatchData\walup.txt");
%% Retrieving saved data
dataHandler = dataHandler.openMatchData("C:\Users\walup\OneDrive\Documentos\MATLAB\RoyaleAnalyzer\MatchData\walup.txt");
%% Plotting the whole trophy evolution
dataHandler.totalTrophyEvolution();