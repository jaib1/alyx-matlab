function [obj, statusCode] = getToken(obj, username, password)
%GETTOKEN Acquire an authentication token for Alyx
%   Makes a request for an authentication token to an Alyx instance;
%   returns the token and status code.
%
% Example:
% statusCode = getToken('https://alyx.cortexlab.net', 'max', '123')
%
% See also ALYX, LOGIN

[statusCode, responseBody] = obj.jsonPost('auth-token',...
  ['{"username":"', username, '","password":"', password, '"}']);
if statusCode == 200
  obj.Token = responseBody.token;
  obj.User = username;
  % Add the token to the authorization header field
  obj.WebOptions.HeaderFields = {'Authorization', ['Token ' obj.Token]};
  
  % Flush the local queue on successful login
  obj.flushQueue();
else
  error(responseBody)
end
end

