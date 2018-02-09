function fullEndpoint = makeEndpoint(obj, endpoint)
% MAKEENDPOINT Returns a complete Alyx Rest API endpoint URL
%   Determines whether the endpoint is a full url or just a relative url
%   and returns a full one.
%
% See also ALYX, FLUSHQUEUE
%
% Part of Alyx

% 2017 -- created

if strcmp(endpoint(1:4), 'http')
  % this is a full url already
  fullEndpoint = endpoint;
else
  fullEndpoint = [obj.BaseURL, '/', endpoint];
end

% drop trailing slash
if fullEndpoint(end) == '/'
  fullEndpoint = fullEndpoint(1:end-1);
end