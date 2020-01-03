load('E:\hanzhao\segment_s3\lib\Class\mod_segment.mat')
check_pipe = '98';
[~,loc] = ismember(check_pipe,link.pipeID);
segment_flag = link.segment(loc);
segment{segment_flag}
valve_pipe_segment{segment_flag}