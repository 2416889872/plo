function [Best_score,Best_pos,Curve]=PLO(...
    SearchAgents,...
    Max_iter,...
    lb,...
    ub,...
    dim,...
    fobj)




%% 初始化

Positions=zeros(SearchAgents,dim);



for i=1:SearchAgents

    Positions(i,:)=...
        lb+(ub-lb).*rand(1,dim);

end



%% 计算适应度


Fitness=zeros(SearchAgents,1);



for i=1:SearchAgents

    Fitness(i)=fobj(Positions(i,:));

end



%% 初始化最优


[Best_score,index]=min(Fitness);


Best_pos=Positions(index,:);



Curve=zeros(1,Max_iter);


% 迭代过程


for t=1:Max_iter



    %% 自适应权重

    W1 = 1/(1+exp(4*(t/Max_iter-0.5)));

    W2 = exp(-2*(t/Max_iter));



    %% 更新每个粒子


    for i=1:SearchAgents



        X=Positions(i,:);



        % 1. 回转运动
        % Rotation Movement
     

        r1=rand();


        Rotation = ...
            W1*r1*(Best_pos-X);



        X1 = X + Rotation;



        % 2. 极光椭圆搜索
        % Aurora Elliptical Walking


        r2=rand();


        Levy = Levy_Flight(dim);



        X2 = X1 + ...
            W2*r2*Levy.*...
            (Best_pos-X);



        % 3. 粒子碰撞
        % Particle Collision



        r3=rand();



        if r3<0.3


            j=randi(SearchAgents);


            X3 = X2 + ...
                sin(pi*rand())*...
                rand()*(Positions(j,:)-X2);


        else


            X3=X2;


        end



        %% 边界处理


        X3=max(X3,lb);

        X3=min(X3,ub);



        %% 新适应度


        NewFitness=fobj(X3);



        %% 贪婪选择


        if NewFitness<Fitness(i)


            Positions(i,:)=X3;

            Fitness(i)=NewFitness;


        end



        %% 更新全局最优


        if Fitness(i)<Best_score


            Best_score=Fitness(i);

            Best_pos=Positions(i,:);


        end



    end



    Curve(t)=Best_score;



end



end



% Levy Flight


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