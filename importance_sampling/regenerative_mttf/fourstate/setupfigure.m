figure(1)
clf
axis off
cwid = 0.2;

center0 = [0.5 0.75] - [cwid/2 cwid/2];
center1 = [0.25 0.5] - [cwid/2 cwid/2];
center2 = [0.75 0.5] - [cwid/2 cwid/2];
center3 = [0.5 0.25] - [cwid/2 cwid/2];

s0 = annotation('ellipse', [center0 cwid cwid], 'FaceColor','none');
s1 = annotation('ellipse', [center1 cwid cwid], 'FaceColor','none');
s2 = annotation('ellipse', [center2 cwid cwid], 'FaceColor','none');
s3 = annotation('ellipse', [center3 cwid cwid], 'FaceColor','none');

% Draw Transitions
    t01 = annotation('arrow',[center0(1) center1(1)+cwid/2], [center0(2)+cwid/2 center1(2)+cwid],'Color','black');
    t10 = annotation('arrow',[center1(1)+cwid center0(1)+cwid/2 ], [center1(2)+cwid/2 center0(2)]);
    t02 = annotation('arrow',[center0(1)+cwid center2(1)+cwid/2], [center0(2)+cwid/2 center2(2)+cwid]);
    t20 = annotation('arrow',[center2(1) center0(1)+cwid/2 ], [center2(2)+cwid/2 center0(2)]);
    t32 = annotation('arrow',[center3(1)+cwid center2(1)+cwid/2], [center3(2)+cwid/2 center2(2)]);
    t23 = annotation('arrow',[center2(1) center3(1)+cwid/2 ], [center2(2)+cwid/2 center3(2)+cwid]);
    t31 = annotation('arrow',[center3(1) center1(1)+cwid/2], [center3(2)+cwid/2 center1(2)]);
    t13 = annotation('arrow',[center1(1)+cwid center3(1)+cwid/2 ], [center1(2)+cwid/2 center3(2)+cwid]);
    
    
annotation('textbox', [center0+[cwid/3 -cwid/3] cwid cwid], 'String','00','LineStyle','none','FontSize',24);
annotation('textbox', [center1+[cwid/3 -cwid/3] cwid cwid], 'String','01','LineStyle','none','FontSize',24);
annotation('textbox', [center2+[cwid/3 -cwid/3] cwid cwid], 'String','10','LineStyle','none','FontSize',24);
annotation('textbox', [center3+[cwid/3 -cwid/3] cwid cwid], 'String','11','LineStyle','none','FontSize',24);

timetext = annotation('textbox', [0.01 0.9 0.4 0.1], 'String','Time: 0','LineStyle','none','FontSize',16);
tau_0    = annotation('textbox', [0.01 0.85 0.4 0.1], 'String','\tau_0: inf','LineStyle','none','FontSize',16);
tau_d    = annotation('textbox', [0.01 0.8 0.4 0.1], 'String','\tau_d: inf','LineStyle','none','FontSize',16);

if (DTMC)
    annotation('textbox',[0.625 0.9 0.35 0.1], 'String', 'Embedded DTMC Simulation');
else
    annotation('textbox',[0.625 0.9 0.35 0.1], 'String', 'CTMC Simulation');
end

