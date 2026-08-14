function path=Decode_Path(x,map,dim)
%DECODE_PATH Convert optimisation variables into an ordered waypoint path.

point_num=dim/2;
P=zeros(point_num,2);

for i=1:point_num
    P(i,1)=x(2*i-1);
    P(i,2)=x(2*i);
end

P(:,1)=min(max(P(:,1),0),map.xmax);
P(:,2)=min(max(P(:,2),0),map.ymax);

S=map.start;
G=map.goal;
dir=G-S;
path_axis_len2=dot(dir,dir);
value=zeros(point_num,1);

for i=1:point_num
    value(i)=dot(P(i,:)-S,dir)/path_axis_len2;
end

[~,idx]=sort(value);
P=P(idx,:);

path=[
    S;
    P;
    G
];
end
