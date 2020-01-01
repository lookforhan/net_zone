function [new_link] = relocat_pipe(graph,link)
%relocat_pipe ͨ��graph����������󣬱ߵ�����ᷢ���仯��
%   Ϊ��ʹ�ߵı�����Ӧ�ڵ���һ�£���Ҫ�������¶�λ
num = numel(link.pipeID);
for i = 1:num
    idxOut = findedge(graph,link.N1{i},link.N2{i});
    re_link.pipeID{idxOut,1} = link.pipeID{i};
    re_link.N1{idxOut,1} = link.N1{i};
    re_link.N2{idxOut,1} = link.N2{i};
end
new_link = struct2table(re_link);
end

