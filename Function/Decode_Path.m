function path=Decode_Path(x,map,dim)


point_num=dim/2;


P=zeros(point_num,2);


for i=1:point_num

    P(i,1)=x(2*i-1);

    P(i,2)=x(2*i);

end



% 按距离起点排序

S=map.start;

G=map.goal;


dir=G-S;


value=zeros(point_num,1);


for i=1:point_num

    value(i)=dot(P(i,:)-S,dir);

end


[~,idx]=sort(value);


P=P(idx,:);



path=[
    S;
    P;
    G
];


end