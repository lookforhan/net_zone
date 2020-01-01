function [pipe_flag,segment] = pipe_segment(link,valve)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
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
graph_net2 = graph(link.N1,link.N2);
% 查询连通分量
bins_segment = conncomp(graph_net2)';% % this is right! somewhere below is wrong!
% 连通分区的个数
bins_uniq = unique(bins_segment);
segment_num = numel(bins_uniq);
segment = cell(1,segment_num);
node_id = graph_net2.Nodes.Name;
% 确认管道所属分区
pipe_flag = zeros(numel(link.pipeID),1);
for j = 1:numel(link.pipeID)
    node_flag = link.N1{j};
    [~,Locb_node] = ismember(node_flag,node_id);
    pipe_flag(j) = bins_segment(Locb_node);
end
for k = 1:segment_num
    lia = (pipe_flag == k);
    segment{k}= link.pipeID(lia);
end
end

