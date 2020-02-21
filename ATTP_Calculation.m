function[ATTP] = ATTP_Calculation(timeprocessing,poolconfig,totmessages )
numpools=size(timeprocessing,1);%quantidade de tarefas
finaltime=zeros(numpools,totmessages);%tempos finais
ttp=zeros(1,totmessages);
sttp=0; % sum of total processing times
j=1;% variavel auxiliar, apenas incrementa a coluna de 1 em 1
b=1;% variavel auxiliar, apenas incrementa a coluna de n em n

totthreads=poolconfig(1);%numero de threads do primeiro pool

while j<=totmessages
    for k=1:totthreads
        finaltime(1,j)=b*timeprocessing(1);
        j=j+1;
        if j>totmessages
            break
        end
    end
    b=b+1;
end

j=1;b=1;k=1;

for i=2: numpools
    totthreads=poolconfig(i);
    pool=zeros(totthreads,1);
    
    while  j<=totmessages
        if j==1
            for l=1:totthreads
                pool(l)= finaltime(i-1,1);
            end
            delay=min(pool);
        end
        
        while k<=totthreads
            if j<=totmessages
                if delay>finaltime(i-1,j)
                    finaltime(i,j)=timeprocessing(i)+delay;
                else
                    finaltime(i,j)=timeprocessing(i)+finaltime(i-1,j);
                end
            else
                break
            end
            
            if b<=totthreads
                pool(b)=finaltime(i,k);
            else
                for l=1:totthreads-1
                    pool(l)=pool(l+1);
                end
                pool(totthreads)=finaltime(i,j);
                pool=sortvetor(pool);
            end
            k=k+1;j=j+1;b=b+1;
            delay=min(pool);
        end
        
        if k>=totthreads
            k=1;
        end;
    end
    j=1;
end
for i=1:totmessages
    ttp(1,i)=finaltime(numpools,i);%total processing time
    sttp=sttp+ttp(1,i);
end
ATTP=sttp/totmessages;
end

