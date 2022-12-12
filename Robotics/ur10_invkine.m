%% Import robot and settings 
ur10 = loadrobot("universalUR10",DataFormat='column'); %import robot

%define a simulation time and a time step
tf = 4; 
dt = 0.05;

tvec = linspace(0, tf, (tf/dt) + 1);

%define the task-space trajectory (time, waypoints)
waypoints = [0.5 0.25 0.25; 0.75 0 0.35; 0.5 -0.25 0.25; 0.5 0.25 0.25]';
wayTime = linspace(tvec(1),tvec(end),tf);

%create a trapezoidal trajectory
[pos,vel] = trapveltraj(waypoints,tf/dt);

%% Solve the inverse kinematics problem using robotics toolbox
rng(0) % Seed the RNG so the inverse kinematics solution is consistent
ik = inverseKinematics(RigidBodyTree=ur10);
ik.SolverParameters.AllowRandomRestart = false;

q = zeros(6, tf/dt);
weights = [0.2 0.2 0.2 1 1 1]; % Prioritize position over orientation
initialGuess = [0, 0, 0, -pi/2, 0, 0]'; % Choose an inital guess within the robot joint limits


for i = 1:size(pos,2)
    targetPose = trvec2tform(pos(:,i)')*eul2tform([0, 0, pi]);
    q(:,i) = ik('tool0',targetPose,weights,initialGuess);
    initialGuess = q(:,i); % Use the last result as the next initial guess
end

%% Path visualisation

figure
set(gcf,'Visible','on')
show(ur10);

rc = rateControl(1/dt);
for i = 1:tf/dt
    show(ur10, q(:,i),FastUpdate=true,PreservePlot=false);
    waitfor(rc);
end

