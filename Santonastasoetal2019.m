% test 
% ������ʽ�Ľű������ǲ��ԣ��Դ���ļ���
% addpath(genpath(pwd))
% pipe_segment ֮ǰ���ļ���pipe_segment���ݱ��ļ�д�����ġ�
% ����ΪSantonastasoetal2019��
clear;clc;tic;
example_file_dir = '.\examples\Santonastasoetal2019\';
source = readtable([example_file_dir,'source.csv'],'ReadVariableNames',true);
link = readtable([example_file_dir,'pipe.csv'],'ReadVariableNames',true);
node = readtable([example_file_dir,'node.csv'],'ReadVariableNames',true);
valve = readtable([example_file_dir,'valve.csv'],'ReadVariableNames',true);
node_coordination = [3,3;...
    2,2;2,1;2,0;...
    1,2;1,1;1,0;...
    0,2;0,1;0,0];
node_x = node_coordination(:,1);
node_y = node_coordination(:,2);

graph_net = graph(link.N1,link.N2);
p = graph_net.plot
p.XData = node_x;
p.YData = node_y;
% graph_net.plot
% [pipe_flage,segment]= pipe_segment(link,valve);
[new_link] = relocat_pipe(graph_net,link);
p2 = plot(graph_net,'EdgeLabel',new_link.pipeID);
p2.XData = node_x;p2.YData = node_y;
%%%%
[y1,y2,y3,y4]= pipe_segment(link,valve);