V = cell(1,size(Centers,1));
C = cell(1,size(Centers,1));
for i = 1:size(Centers,1)
    [V{i},C{i}] = voronoin([squeeze(Centers(i,1,:)),squeeze(Centers(i,2,:))]);
end
i = 1;
close
figure
axes
hold on
for j = 1:length(C{i})
    C{i}{j}(end+1) = C{i}{j}(1);
    plot(V{i}(C{i}{j},1),V{i}(C{i}{j},2),'r');
end
plot(tb(:,1),tb(:,2),'r');
%%
points=cell(1,length(V));
for fr = 1:length(V)
    tmpV = V{fr};
    tmpC = C{fr};
    for(i=1:length(tmpV))
        list=[];
        for(j=1:length(tmpC))
            ind=find(tmpC{j}==i);
            if(isempty(ind)==0)
                if(ind>1)
                    if(tmpC{j}(ind-1)>i)
                        if(ismember(tmpC{j}(ind-1),list)==0)
                            points{fr}(end+1,:)=[i,tmpC{j}(ind-1)];
                            list(end+1)=tmpC{j}(ind-1);
                        end
                    end
                elseif(tmpC{j}(end)>i)
                    if(ismember(tmpC{j}(end),list)==0)
                        points{fr}(end+1,:)=[i,tmpC{j}(end)];
                        list(end+1)=tmpC{j}(end);
                    end
                end
                
                if(ind<length(tmpC{j}))
                    if(tmpC{j}(ind+1)>i)
                        if(ismember(tmpC{j}(ind+1),list)==0)
                            points{fr}(end+1,:)=[i,tmpC{j}(ind+1)];
                            list(end+1)=tmpC{j}(ind+1);
                        end
                    end
                elseif(tmpC{j}(1)>i)
                    if(ismember(tmpC{j}(1),list)==0)
                        points{fr}(end+1,:)=[i,tmpC{j}(1)];
                        list(end+1)=tmpC{j}(1);
                    end
                end
            end
        end
    end
    points{fr}(points{fr}(:,1)==1,:)=[];
    points{fr} = points{fr}-1;
end