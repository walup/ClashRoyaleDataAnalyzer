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

%% request of the last matches
lastMatches = dataRetriever.requestLastMatches();

%% Request of player info 
playerInfo = dataRetriever.requestPlayerInfo();
