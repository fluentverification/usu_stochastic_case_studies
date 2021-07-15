    % draw state figure:
    
    t01.Color = 'black'; % = annotation('arrow',[center0(1) center1(1)+cwid/2], [center0(2)+cwid/2 center1(2)+cwid],'Color','black');
    t10.Color = 'black'; % = annotation('arrow',[center1(1)+cwid center0(1)+cwid/2 ], [center1(2)+cwid/2 center0(2)]);
    t02.Color = 'black'; % = annotation('arrow',[center0(1)+cwid center2(1)+cwid/2], [center0(2)+cwid/2 center2(2)+cwid]);
    t20.Color = 'black'; % = annotation('arrow',[center2(1) center0(1)+cwid/2 ], [center2(2)+cwid/2 center0(2)]);
    t23.Color = 'black'; % = annotation('arrow',[center3(1)+cwid center2(1)+cwid/2], [center3(2)+cwid/2 center2(2)]);
    t32.Color = 'black'; % = annotation('arrow',[center2(1) center3(1)+cwid/2 ], [center2(2)+cwid/2 center3(2)+cwid]);
    t13.Color = 'black'; % = annotation('arrow',[center3(1) center1(1)+cwid/2], [center3(2)+cwid/2 center1(2)]);
    t31.Color = 'black'; % = annotation('arrow',[center1(1)+cwid center3(1)+cwid/2 ], [center1(2)+cwid/2 center3(2)+cwid]);
    
    
    if (s == 0)
        s0.FaceColor = 'blue';
    else
        s0.FaceColor = 'none';
    end
    
    
    if (s == 1)
        s1.FaceColor = 'blue';
    else
        s1.FaceColor = 'none';
    end
    
    
    if (s == 2)
        s2.FaceColor = 'blue';
    else
        s2.FaceColor = 'none';
    end

    
    if (s == 3)
        s3.FaceColor = 'red';
    else
        s3.FaceColor = 'none';
    end
