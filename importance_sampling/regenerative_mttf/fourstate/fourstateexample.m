% Four-state MTTF simulation example
DTMC = false;
N    = 1000;    % run for N paths

% Fail Rates:
F = [1 1];

% Repair Rates:
R = [10 10];
    
setupfigure


return_time = 0;
fail_time   = 0;

return_paths = 0;
fail_paths = 0;


for pdx=1:N
    t = 0;
    s = 0;
    
   while (((s > 0) || (t == 0)) && (s ~= 3))
       
       drawstatediagram
   
        
    
    % Select next transition:
    if (DTMC)
        switch s
            case 0
                p01 = F(1)/(F(1) + F(2));   % FAIL module 1 or module 2?
                if (rand(1,1) < p01)
                    s = 1;  t01.Color = 'blue';
                else
                    s = 2;  t02.Color = 'blue';
                end
                
                % advance path clock by average sojourn time:
                t = t + 1/(F(1)+F(2));
                
            case 1
                p10 = R(1)/(R(1) + F(2));  % REPAIR module 1 or FAIL module 2?
                if (rand(1,1) < p10)
                    s = 0;  t10.Color = 'blue';
                else
                    s = 3;  t13.Color = 'red';
                end
                
                % advance path clock by average sojourn time:
                t = t + 1/(R(1)+F(2));
            case 2
                p20 = R(2)/(R(2) + F(1));  % REPAIR module 2 or FAIL module 1?
                if (rand(1,1) < p20)
                    s = 0;  t20.Color = 'blue';
                else
                    s = 3;  t23.Color = 'red';
                end
                
                % advance path clock by average sojourn time:
                t = t + 1/(F(1)+R(2));
            case 3
                p31 = R(2)/(R(2) + R(1));  % REPAIR module 2 or module 1?
                if (rand(1,1) < p31)
                    s = 1;  t31.Color = 'blue';
                else
                    s = 2;  t32.Color = 'blue';
                end
                
                % advance path clock by average sojourn time:
                t = t + 1/(R(1)+R(2));
        end
    else  % CTMC model
        switch s
            case 0
                %p01 = F(1)/(F(1) + F(2));   % FAIL module 1 or module 2?
                ran_time1 = exprnd(1/F(1));
                ran_time2 = exprnd(1/F(2));
                if (ran_time1 < ran_time2)
                    s = 1;
                    t = t + ran_time1;
                    t01.Color = 'blue';
                else
                    s = 2;
                    t = t + ran_time2;
                    t02.Color = 'blue';
                end
            case 1
                %p10 = R(1)/(R(1) + F(2));  % REPAIR module 1 or FAIL module 2?
                ran_time1 = exprnd(1/R(1));
                ran_time2 = exprnd(1/F(2));
                if (ran_time1 < ran_time2)
                    s = 0;
                    t = t + ran_time1;
                    t10.Color = 'blue';
                else
                    s = 3;
                    t = t + ran_time2;
                    t13.Color = 'red';
                end
            case 2
                %p20 = R(2)/(R(2) + F(1));  % REPAIR module 2 or FAIL module 1?
                ran_time1 = exprnd(1/R(2));
                ran_time2 = exprnd(1/F(1));
                if (ran_time1 < ran_time2)
                    s = 0;
                    t = t + ran_time1;
                    t20.Color = 'blue';
                else
                    s = 3;
                    t = t + ran_time2;
                    t23.Color = 'red';
                end
            case 3
                %p31 = R(2)/(R(2) + R(1));  % REPAIR module 2 or module 1?
                ran_time1 = exprnd(1/R(2));
                ran_time2 = exprnd(1/R(1));
                if (ran_time1 < ran_time2)
                    s = 1;
                    t = t + ran_time1;
                    t31.Color = 'blue';
                else
                    s = 2;
                    t = t + ran_time2;
                    t32.Color = 'blue';
                end
        end
    end
    pause(0.05)
   end
   
   if (s==0)
       return_time = return_time + t;
       fail_time   = fail_time   + t;
       return_paths = return_paths + 1;
   elseif (s==3)
       fail_time  = fail_time + t;
       fail_paths = fail_paths + 1;
   end
   
   fail_string = sprintf("\\tau_d: %f/%d = %f",fail_time,fail_paths,fail_time/fail_paths);
   return_string = sprintf("\\tau_0: %f/%d = %f",return_time,return_paths,return_time/return_paths);
   time_string = sprintf("Time: %f",t);
   tau_0.String = return_string;
   tau_d.String = fail_string;
   timetext.String = time_string;
end