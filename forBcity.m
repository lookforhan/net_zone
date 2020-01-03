% 关于BPDRR的程序
study_dir = '.\examples\BPDRR\';
data = readcell([study_dir,'BBM-EPS-valve.txt'],'Delimiter',';');
data_valves = data(:,2);
data_pipe = data(:,1);
writecell(data_valves,[study_dir,'valves.txt']);
writecell(data_pipe,[study_dir,'pipes.txt']);
valves_code = readmatrix([study_dir,'valves.txt'],'Delimiter','-');
pipe_info = readcell([study_dir,'pipes.txt']);

link.pipeID = pipe_info(:,1);
link.N1 = pipe_info(:,2);
link.N2 = pipe_info(:,3);
link_table = struct2table(link);

valve.pipeID = pipe_info(:,1);
valve.V1 = valves_code(:,1);
valve.V2 = valves_code(:,2);
valve_table = struct2table(valve);
% output
writetable(link_table,[study_dir,'link.csv']);
writetable(valve_table,[study_dir,'valve.csv'])