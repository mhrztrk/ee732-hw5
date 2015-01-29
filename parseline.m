function [ model ] = parseline(input)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    global strsplit_loc;

    % Both matlab and bnt contain the function strsplit, detect which one
    % is being used right now.
    
    strsplit_loc = isempty(strfind(which('strsplit'),'KPMtools'));

    
    % get the string between the parentheses 
    subchunk = regexp(input, '(?<=\()(.*?)(?=\))', 'match');
    input = subchunk{1};

    % Check if it a conditional probability
    out = strsplit_wrapper(input,'|');
    
    isCond = 0;
    if(size(out,2) == 2)
       isCond = 1; 
    end

    % Find comma separeted entries
    entries = strsplit_wrapper(out{1},',');
    for i=1:size(entries,2)
        var = strsplit_wrapper(entries{i},'=');
        model.variables{i}.label = var{1};
        model.variables{i}.value = str2num(var{2});
    end

    model.cond_variables = {};
    if(isCond)
        entries = strsplit_wrapper(out{2},','); 
        for i=1:size(entries,2)
            var = strsplit_wrapper(entries{i},'=');
            model.cond_variables{i}.label = var{1};
            model.cond_variables{i}.value = str2num(var{2});
        end
    end
end
    
    
function parts = strsplit_wrapper(str, splitstr)
    
    global strsplit_loc;

    if(strsplit_loc)
        parts = strsplit(input, splitstr);
    else
        parts = strsplit(splitstr, str);
    end
end