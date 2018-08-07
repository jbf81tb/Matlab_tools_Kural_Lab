%%
lt4 = 3*[nsta([nsta.class]==4).lt];
lte = 3*[nsta([nsta.class]~=4&~blob).lt];
ltb = 3*[nsta(blob).lt];
mi4 = cellfun(@max,{nsta([nsta.class]==4).int});
mie = cellfun(@max,{nsta([nsta.class]~=4&~blob).int});
mib = cellfun(@max,{nsta(blob).int});
%%
close
figure('color',ones(1,3))
axes
axis off
hold on
plot(max(min(lt4+(1.5-3*rand(size(lt4))),100),9),min(mi4,10000),'r.','markersize',6)
plot(max(min(lte+(1.5-3*rand(size(lte))),100),9),min(mie,10000),'.','color', [0 .5 0],'markersize',6)
plot(max(min(ltb+(1.5-3*rand(size(ltb))),100),9),min(mib,10000),'b.','markersize',6)
xlim([9 100])
ylim([500 10000])
set(gca,'yscale','log','xscale','log')
%% with logging
lt4s = lt4+(1.5-3*rand(size(lt4)));
ltes = lte+(1.5-3*rand(size(lte)));
ltbs = ltb+(1.5-3*rand(size(ltb)));
cb = [1 0 0];
ce = [0 .7 .7];
c4 = [0 0 0];

close
figure('units','pixels','position',[1 1 1050 1050],'color',ones(1,3))

ahm = axes('Units','normalized',...
    'Position',[.2 .2 .799 .799],...
    'tickdir','out');%,...
%     'xtick',[],...
%     'ytick',[],...
% ahm.XAxis.LineWidth = 2;
% ahm.YAxis.LineWidth = 2;
hold on
plot(lt4s,mi4,'.','color',c4,'markersize',2)
plot(ltes,mie,'.','color',ce,'markersize',2)
plot(ltbs,mib,'.','color',cb,'markersize',2.5)
plot([7.5 259.5],[500 500],'k','linewidth',2)
plot([7.5 7.5],[500 40000],'k','linewidth',2)
xlim([7.5 259.5])
ylim([500 40000])
% xlabel('Lifetime (s)')
% ylabel('Max Intensity (AU)')
set(ahm,'yscale','log','xscale','log')

ahl = axes('Units','normalized',...
    'Position',[.2 .00 .799 .165],...
    'xtick',[]);
hold on
[lt4c,tmpx] = histcounts(log(lt4s(mi4>500&mi4<40000)),log(7.5):.1:log(259.5),'normalization','pdf');
lt4x = (tmpx(1:end-1)+tmpx(2:end))/2;
[ltec,tmpx] = histcounts(log(ltes(mie>500&mie<40000)),log(7.5):.1:log(259.5),'normalization','pdf');
ltex = (tmpx(1:end-1)+tmpx(2:end))/2;
[ltbc,tmpx] = histcounts(log(ltbs(mib>500&mib<40000)),log(7.5):.1:log(259.5),'normalization','pdf');
ltbx = (tmpx(1:end-1)+tmpx(2:end))/2;
plot(exp(lt4x(lt4c~=0)),lt4c(lt4c~=0),'color',c4,'linewidth',2)
plot(exp(ltex(ltec~=0)),ltec(ltec~=0),'color',ce,'linewidth',2)
plot(exp(ltbx(ltbc~=0)),ltbc(ltbc~=0),'color',cb,'linewidth',2)
xlim([7.5 259.5])
ylim([0 .93])
view(180,90)
set(ahl,'xscale','log','xdir','reverse')

ahm = axes('Units','normalized',...
    'Position',[0.00 .2 .165 .799],...
    'xtick',[]);
hold on
[mi4c,tmpx] = histcounts(log(mi4(lt4s>7.5&lt4s<259.5)),log(500):.1:log(40000),'normalization','pdf');
mi4x = (tmpx(1:end-1)+tmpx(2:end))/2;
[miec,tmpx] = histcounts(log(mie(ltes>7.5&ltes<259.5)),log(500):.1:log(40000),'normalization','pdf');
miex = (tmpx(1:end-1)+tmpx(2:end))/2;
[mibc,tmpx] = histcounts(log(mib(ltbs>7.5&ltbs<259.5)),log(500):.1:log(40000),'normalization','pdf');
mibx = (tmpx(1:end-1)+tmpx(2:end))/2;
plot(exp(mi4x(mi4c~=0)),mi4c(mi4c~=0),'color',c4,'linewidth',2)
plot(exp(miex(miec~=0)),miec(miec~=0),'color',ce,'linewidth',2)
plot(exp(mibx(mibc~=0)),mibc(mibc~=0),'color',cb,'linewidth',2)
xlim([500 40000])
ylim([0 1.6])
view(-90,90)
set(ahm,'xscale','log')
%% without logging
lt4s = lt4+(1.5-3*rand(size(lt4)));
ltes = lte+(1.5-3*rand(size(lte)));
ltbs = ltb+(1.5-3*rand(size(ltb)));
c4 = [1 0 0];
ce = [0 .7 .7];
cb = [0 0 0];

close
figure('units','pixels','position',[1 1 1050 1050],'color',ones(1,3))

ahm = axes('Units','normalized',...
    'Position',[.2 .2 .799 .799],...
    'tickdir','out');%,...
%     'xtick',[],...
%     'ytick',[],...
% ahm.XAxis.LineWidth = 2;
% ahm.YAxis.LineWidth = 2;
hold on
plot(lt4s,mi4,'.','color',c4,'markersize',2)
plot(ltes,mie,'.','color',ce,'markersize',2)
plot(ltbs,mib,'.','color',cb,'markersize',2.5)
plot([7.5 259.5],[500 500],'k','linewidth',2)
plot([7.5 7.5],[500 40000],'k','linewidth',2)
xlim([7.5 259.5])
ylim([500 40000])

ahl = axes('Units','normalized',...
    'Position',[.2 .00 .799 .165],...
    'xtick',[]);
hold on
[lt4c,tmpx] = histcounts(lt4s,7.5:3:259.5,'normalization','pdf');
lt4x = (tmpx(1:end-1)+tmpx(2:end))'/2;
lt4c = lt4c';
[ltec,tmpx] = histcounts(ltes,7.5:3:259.5,'normalization','pdf');
ltex = (tmpx(1:end-1)+tmpx(2:end))'/2;
ltec = ltec';
[ltbc,tmpx] = histcounts(ltbs,7.5:3:259.5,'normalization','pdf');
ltbx = (tmpx(1:end-1)+tmpx(2:end))'/2;
ltbc = ltbc';
plot(lt4x(lt4c~=0),lt4c(lt4c~=0),'color',c4,'linewidth',1)
plot(ltex(ltec~=0),ltec(ltec~=0),'color',ce,'linewidth',1)
plot(ltbx(ltbc~=0),ltbc(ltbc~=0),'color',cb,'linewidth',1)
xlim([7.5 259.5])
% ylim([0 .93])
view(180,90)
set(ahl,'xdir','reverse')

ahm = axes('Units','normalized',...
    'Position',[0.00 .2 .165 .799],...
    'xtick',[]);
hold on
[mi4c,tmpx] = histcounts(mi4,500:1000:40000,'normalization','pdf');
mi4x = (tmpx(1:end-1)+tmpx(2:end))'/2;
mi4c = mi4c';
[miec,tmpx] = histcounts(mie,500:1000:40000,'normalization','pdf');
miex = (tmpx(1:end-1)+tmpx(2:end))'/2;
miec = miec';
[mibc,tmpx] = histcounts(mib,500:1000:40000,'normalization','pdf');
mibx = (tmpx(1:end-1)+tmpx(2:end))'/2;
mibc = mibc';
plot(mi4x(mi4c~=0),mi4c(mi4c~=0),'color',c4,'linewidth',1)
plot(miex(miec~=0),miec(miec~=0),'color',ce,'linewidth',1)
plot(mibx(mibc~=0),mibc(mibc~=0),'color',cb,'linewidth',1)
xlim([500 40000])
% ylim([0 2.2])
view(-90,90)
%% hist counts with log
[lt4c,tmpx] = histcounts(log(lt4s(mi4>=500&mi4<=40000)),log(7.5):.1:log(259.5));
lt4x = (tmpx(1:end-1)+tmpx(2:end))'/2;
[ltec,~] = histcounts(log(ltes(mie>=500&mie<=40000)),log(7.5):.1:log(259.5));
[ltbc,~] = histcounts(log(ltbs(mib>=500&mib<=40000)),log(7.5):.1:log(259.5));
lt4c = lt4c';
ltec = ltec';
ltbc = ltbc';
[mi4c,tmpx] = histcounts(log(mi4(lt4s>7.5&lt4s<259.5)),log(500):.1:log(40000));
mi4x = (tmpx(1:end-1)+tmpx(2:end))'/2;
[miec,~] = histcounts(log(mie(ltes>7.5&ltes<259.5)),log(500):.1:log(40000));
[mibc,~] = histcounts(log(mib(ltbs>7.5&ltbs<259.5)),log(500):.1:log(40000));
mi4c = mi4c';
miec = miec';
mibc = mibc';