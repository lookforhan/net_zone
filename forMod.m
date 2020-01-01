% 准备MOD管网
clear;clc;tic;
net = epanet('.\examples\Modena\MOD.inp');
pipeID = net.LinkPipeNameID';
N1 = net.NodesConnectingLinksID(:,1);
N2 = net.NodesConnectingLinksID(:,2);
net.delete
link = cell2table([pipeID,N1,N2],'VariableNames',{'pipeID','N1','N2'});
writetable(link,'.\examples\Modena\link.csv');
rng(10) 
% 阀门准备
pipe_num = numel(pipeID) ;
pipe2v_num = floor(pipe_num*0.2296);
pipe2v_index = randperm(pipe_num,pipe2v_num);
pipe2v = pipeID(pipe2v_index);
pipeID(pipe2v_index) = [];
pipeID2 = pipeID;

pipe_lift_num = floor(pipe_num*0.3931);
pipe_lift_index = randperm(pipe_num-pipe2v_num,pipe_lift_num);
pipe_lift_id = pipeID2(pipe_lift_index);

pipeID2(pipe_lift_index) = [];
pipeID3 = pipeID2;

pipe_right_num = floor(pipe_num*0.1311);
pipe_right_index = randperm(pipe_num-pipe2v_num-pipe_lift_num,pipe_right_num);
pipe_right_id = pipeID3(pipe_right_index);

v1_1= ones(pipe2v_num,1);
v2_1 = ones(pipe2v_num,1);
v1_2 = ones(pipe_lift_num,1);
v2_2 = zeros(pipe_lift_num,1);
v1_3 = zeros(pipe_right_num,1);
v2_3 = ones(pipe_right_num ,1);
v1 = [v1_1;v1_2;v1_3];
v2 = [v2_1;v2_2;v2_3];

v_pipe_id =[pipe2v;pipe_lift_id;pipe_right_id];
valve.pipeID = v_pipe_id;
valve.V1 = v1;
valve.V2 = v2;

valve2 = struct2table(valve);
writetable(valve2,'.\examples\Modena\valve.csv')
[pipe_flag,pipe_segment,valve_pipe_segment,link] = pipe_segment(link,valve);
segment = pipe_segment;
 save('mod_segment','valve2','link','pipe_flag','segment','valve_pipe_segment','link');
