

function filePath = expFilePath(subject, queryDate, sessNum, dsetType, conn)
% function filePath = expFilePath(subject, queryDate, sessNum, dsetType [, conn])
% 
% returns the file path where you can find a specified file. You specify:
% - subject - a string with the subject name
% - queryDate - a string in 'yyyy-mm-dd' format or a datenum
% - sessNum - an integer number of the experiment you want
% - dsetType - a string specifying which file you want, like 'Block']
% - conn - optional argument supplying the SQL connection object obtained
% from openAlyxSQL(). If not supplied, then one is created and then closed
% at the end of the query, which slows down the code!
%
% if more than one matching paths are found, output argument filePath will 
% be a cell array of strings, otherwise just a string
%
% Future todo:
% - enable excluding sessNum to return all sessions
% - enable excluding dsetType to return all files found
% - enable a range of queryDates
% - enable multiple subjects

if nargin == 5 && ~isempty(conn)
    suppliedConn = true;
else
    suppliedConn = false;
    conn = openAlyxSQL(); 
end

myQuery = sprintf([...
    'select data_filerecord.relative_path, data_datarepository.path '...
    'from data_filerecord '...      
    'left join data_dataset on data_filerecord.dataset_id=data_dataset.id '...
    'left join actions_session on data_dataset.session_id=actions_session.id '...
    'left join subjects_subject on actions_session.subject_id=subjects_subject.id '...
    'left join data_datarepository on data_filerecord.data_repository_id=data_datarepository.id '...
    'left join data_datasettype on data_dataset.dataset_type_id=data_datasettype.id '...
    'where subjects_subject.nickname=''%s'' '...
    'and actions_session.start_time>=''%s'' '...
    'and actions_session.start_time<''%s'' '...
    'and actions_session.type=''Experiment'' '...
    'and actions_session.number=%d '...
    'and data_datasettype.name=''%s'' '...    
    ],...
    subject, ...
    datestr(floor(datenum(queryDate)), 'yyyy-mm-dd'), ...
    datestr(floor(datenum(queryDate)+1), 'yyyy-mm-dd'), ...
    sessNum, ...
    dsetType ...
    );

q = fetch(exec(conn, myQuery));

if ~isempty(q.Data) && ~strcmp(q.Data{1}, 'No Data')
    %cell2table(q.Data, 'VariableNames', myColNames(q))
    filePath = arrayfun(@(x)fullfile(q.Data{x,2}, q.Data{x,1}), 1:size(q.Data,1), 'uni', false);
    if numel(filePath)==1
        filePath = filePath{1};
    end
else
    fprintf(1, 'no results returned\n');
    filePath = '';
end

if suppliedConn == false
    %Close connection
    conn.close;
end



