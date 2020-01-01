% test 
% 不是正式的脚本，而是测试，试错的文件。
% addpath(genpath(pwd))
clear;clc;tic;
source = readtable('source.csv','ReadVariableNames',true);
link = readtable('pipe.csv','ReadVariableNames',true);
node = readtable('node.csv','ReadVariableNames',true);
valve = readtable('valve.csv','ReadVariableNames',true);
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