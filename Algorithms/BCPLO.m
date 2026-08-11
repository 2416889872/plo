function [Best_score,Best_pos,Curve]=BCPLO(...
    SearchAgents,...
    Max_iter,...
    lb,...
    ub,...
    dim,...
    fobj)

% Logistic混沌初始化


Positions=zeros(SearchAgents,dim);



Positions=zeros(SearchAgents,dim);


for i=1:SearchAgents

    Positions(i,:) = ...
        lb + (ub-lb).*rand(1,dim);

end




% 初始适应度



Fitness=zeros(SearchAgents,1);



for i=1:SearchAgents

    Fitness(i)=fobj(Positions(i,:));

end



%% 全局最优


[Best_score,index]=min(Fitness);


Best_pos=Positions(index,:);



Curve=zeros(1,Max_iter);




% 迭代



for t=1:Max_iter



    %% 排序获得优秀个体


    [Fitness,order]=sort(Fitness);


    Positions=Positions(order,:);



    Elite=Positions(1,:);



   
    % 质心引导策略
   

    Centroid=mean(Positions);




    % 自适应阻尼系数
 


    damping=...
        exp(-2*t/Max_iter);



    for i=1:SearchAgents



        X=Positions(i,:);




        % 极光旋转搜索



        r1=rand();



        Rotation=...
            r1*(Elite-X);



        X1=X+Rotation;



  
        % 极光椭圆搜索
  


        Levy=Levy_Flight(dim);



        X2=X1+...
            damping*rand()*...
            Levy.*(Elite-X);



        % 质心引导
 


        X3=X2+...
            rand()*(Centroid-X2);



      
        % 人工蜂鸟局部搜索


        Food=Positions(randi(SearchAgents),:);



        Direction=Food-X3;



        X4=X3+...
            rand()*Direction;




        % 随机扰动
     


        if rand()<0.2


            X4=X4+...
                0.1*randn(1,dim).*(ub-lb);


        end



        %% 边界约束


        X4=max(X4,lb);

        X4=min(X4,ub);



        %% 新适应度


        NewFitness=fobj(X4);



        %% 贪婪更新


        if NewFitness<Fitness(i)



            Positions(i,:)=X4;

            Fitness(i)=NewFitness;


        end



        %% 更新最优


        if Fitness(i)<Best_score


            Best_score=Fitness(i);

            Best_pos=Positions(i,:);


        end



    end



   
    % 精英保留
  


    [Worst,index]=max(Fitness);



    if fobj(Elite)<Worst


        Positions(index,:)=Elite;

        Fitness(index)=fobj(Elite);


    end



    Curve(t)=Best_score;



end



end

function step=Levy_Flight(dim)


beta=1.5;



sigma=(...
gamma(1+beta)*sin(pi*beta/2)/...
(gamma((1+beta)/2)*beta*...
2^((beta-1)/2)))^(1/beta);



u=randn(1,dim)*sigma;

v=randn(1,dim);



step=u./abs(v).^(1/beta);



end