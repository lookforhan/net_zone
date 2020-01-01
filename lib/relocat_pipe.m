function [new_link] = relocat_pipe(graph,link)
%relocat_pipe 通过graph类生成网络后，边的排序会发生变化，
%   为了使边的编号与对应节点编号一致，需要进行重新定位
num = numel(link.pipeID);
for i = 1:num
    idxOut = findedge(graph,link.N1{i},link.N2{i});
    re_link.pipeID{idxOut,1} = link.pipeID{i};
    re_link.N1{idxOut,1} = link.N1{i};
    re_link.N2{idxOut,1} = link.N2{i};
end
new_link = struct2table(re_link);
end

