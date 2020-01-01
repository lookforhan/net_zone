function [pipe_flag,pipe_segment,valve_pipe_segment,link] = pipe_segment(link,valve)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
link_before_zone=link;
for i = 1:numel(valve.V1)
    [~,Locb] = ismember(valve.pipeID{i},link.pipeID);
    if valve.V1(i) ==1
        New_node_id = [valve.pipeID{i},'-V1'];% 增加节点
        link.N1{Locb} = New_node_id;% 修改连接
    end
    if valve.V2(i) == 1
         New_node_id = [valve.pipeID{i},'-V2'];% 增加节点
        link.N2{Locb} = New_node_id;% 修改连接
    end
end

graph_net2 = graph(link.N1,link.N2);% here is the problem !!!

% relocate_link = relocat_pipe(graph_net2,link);
% figure
% p3 = plot(graph_net2,'EdgeLabel',relocate_link.pipeID);

node_segment_flag = conncomp(graph_net2)';
% p3 = plot(graph_net2,'NodeLabel',node_segment_flag);
node_segment.node_id = graph_net2.Nodes.Name;
node_segment.segment_flag = node_segment_flag;
% 对管道分区
pipe_num = numel(link.pipeID);
for j = 1:pipe_num
    check_node = link.N1{j};
    [~,Locb] = ismember(check_node,node_segment.node_id);
    segment_flag = node_segment.segment_flag(Locb);
    link.segment(j) =  segment_flag;
end
pipe_flag = link.segment;
% 
segment_num = numel(unique(node_segment_flag));
pipe_segment = cell(1,segment_num);
for k = 1:segment_num
    lia = (link.segment == k);
    pipe_segment{k} = link.pipeID(lia);
end

% 带阀门的管道分区,即寻找分区边界管道
pipe_valve_nameID = valve.pipeID;

% 管道涉及的节点
for m = 1:numel(pipe_valve_nameID)
    [~,Loc_pipe_before] = ismember(pipe_valve_nameID{m},link_before_zone.pipeID);
    valve_N1 = link_before_zone.N1{Loc_pipe_before};
    [~,Loc_node_flag1] = ismember(valve_N1,node_segment.node_id);
    segment_flag_valve_n1(m,1) = node_segment.segment_flag(Loc_node_flag1);
    valve_N2 = link_before_zone.N2{Loc_pipe_before};
    [~,Loc_node_flag2] = ismember(valve_N2,node_segment.node_id);
    try
    segment_flag_valve_n2(m,1) = node_segment.segment_flag(Loc_node_flag2);
    catch
        m
        Loc_node_flag2
        keyboard
    end
     [~,Loc_pipe_after] = ismember(pipe_valve_nameID{m},link.pipeID);
    valve_after_N1 = link.N1{Loc_pipe_after};
    [~,Loc_node_flag3] = ismember(valve_after_N1,node_segment.node_id);
    segment_flag_valve_n3(m,1) = node_segment.segment_flag(Loc_node_flag3);
    valve_after_N2 = link.N2{Loc_pipe_after};
    [~,Loc_node_flag4] = ismember(valve_after_N2,node_segment.node_id);
    segment_flag_valve_n4(m,1) = node_segment.segment_flag(Loc_node_flag4);
end
all_pipe_valve.nameID = [pipe_valve_nameID;pipe_valve_nameID;pipe_valve_nameID;pipe_valve_nameID];
all_pipe_valve.segment = [segment_flag_valve_n1;segment_flag_valve_n2;segment_flag_valve_n3;segment_flag_valve_n4];
% 分区的边界管道
valve_pipe_segment = cell(1,segment_num);
for h = 1:segment_num
    lia = (all_pipe_valve.segment ==h);
     segment_repeat = all_pipe_valve.nameID(lia);
     valve_pipe_segment{h}= unique(segment_repeat);
end
end

