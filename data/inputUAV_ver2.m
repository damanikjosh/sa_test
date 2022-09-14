% 2022-02-01
% Simple UAV+UGV+USV Complex Mission Planning input tool
% Written by MCH
clear all; clc; close all;

fprintf('\n Complex Unmanned Mission Planning input tool\n')
pause(0.5)



%% (TEMP) Map Define
% 100*100 Size
mapsize_x=100;
mapsize_y=100;
MainMissionGlobalArea = [mapsize_x mapsize_y]; % 위치좌표(Area) : 전체 대표임무 수행 범위 (시뮬레이션 하는 전체 범위)

% plot Empty Map Figure
fig1 = figure;
title('Mission Map')
plot([],[],'-')
axis equal;
xlim([0 MainMissionGlobalArea(1)]); 
ylim([0 MainMissionGlobalArea(2)]);
hold on;










%% Input by User

% Mission Type Definition 
fprintf('\n Please Select Main Mission Type \n')
fprintf('1. 해양사고 조난자 수색 및 구조 \n')
fprintf('2. 불법 조업 및 영해 침범 감시 \n')
fprintf('3. 환경오염 모니터링 및 추적  \n')
fprintf('4. 긴급 무선 통신망 구축 \n')
fprintf('5. 정밀 농업 \n')
fprintf('6. 지뢰제거 (BETA) \n')

valid_input_flag=1;


mission_text = {'1. 해양사고 조난자 수색 및 구조 \n',
            '2. 불법 조업 및 영해 침범 감시 \n',
            '3. 환경오염 모니터링 및 추적 \n',
            '4. 긴급 무선 통신망 구축 \n',
            '5. 정밀 농업 \n',
            '6. 지뢰제거 (BETA) \n'};
        
while(valid_input_flag)
    mission_type = input('\nChoose Mission type [1~5]: ');
    valid_input_flag=0;
    while isempty(mission_type) || (mission_type > length(mission_text)) || (mission_type < 0)
        mission_type = input('\nChoose Mission type [1~5]: ');
    end
    
    switch mission_type
        case 1
            fprintf(mission_text{mission_type})
        case 2
            fprintf(mission_text{mission_type})
        case 3
            fprintf(mission_text{mission_type})
        case 4
            fprintf(mission_text{mission_type})
        case 5
            fprintf(mission_text{mission_type})
        case 6
            fprintf(mission_text{mission_type})
        otherwise
            fprintf('Please choose valid main mission type\n')
            valid_input_flag=1;
    end
    fprintf('(Selected)\n')
end







%%
% Base Input (TEMP) Location -> Map GUI / type selection will be automated
clc
fprintf(mission_text{mission_type})
fprintf('(Selected)\n')

% Load previous saved Base data (BaseTable.mat)
load_base = input('\n Do you want to load preivous Base information? (BaseTable.mat) (y/n) :','s');
if isempty(load_base)
    str = 'n';
end

if load_base == 'n'
    
    fprintf('\n\n\n----------------------Base input start------------------------------\n\n\n')

    fprintf('\n Please define Agent Base information \n')
    num_base = input('How many Bases on environment? :  ');
    while isempty(num_base) ||  (num_base < 0)
        num_base = input('How many Bases on environment? :  ');
    end


    fprintf('\nThere is %d base on environment \n',num_base)

    % initalizing base cell struct -> table
    BaseStruct = {};
    BaseTable = [];
    for i = 1:num_base
        BaseStruct{i}.id_base = i;
        BaseStruct{i}.Location_X={};
        BaseStruct{i}.Location_Y={};
        BaseStruct{i}.isSea_base = logical(1);
        BaseStruct{i}.isAir_base = logical(1);
        BaseStruct{i}.isLand_base = logical(1);    
        BaseTableTemp = struct2table(BaseStruct{i},'AsArray',true);
        BaseTable = [BaseTable; BaseTableTemp];
    end

else
    load BaseTable.mat
end
    


fprintf('\n---------------Base Edit Mode-------------\n')
BaseEditMode=1;
current_base_plot = cell(1,num_base);
while BaseEditMode
    disp(BaseTable)

    % Select base id for edit
    current_id_base = round(input("Select Base id for edit [1~" + num_base + "] : "));
    % for input mistake
    while isempty(current_id_base) || (current_id_base > num_base) || (current_id_base < 0)
        fprintf('\nThere is %d base on environment \n',num_base)
        current_id_base = input('Select valid Base id for edit : ');
    end

    % Current Base id 's Edit loop
    valid_input_flag = 1;
    while(valid_input_flag)

        fprintf('Current Base id is [%d] \n',current_id_base)
        fprintf('1. Draw Location on Map \n')
        fprintf('2. Property : Sea Y/N \n')
        fprintf('3. Property : Air Y/N \n')
        fprintf('4. Property : Land Y/N \n')
        fprintf('5. Location Edit \n')
        fprintf('6. Finish Editing \n')
        base_edit_type = input('Choose property type to edit [1~5]: ');
        while isempty(base_edit_type) || (base_edit_type > 7) || (base_edit_type < 0)
            base_edit_type = input('Choose property type to edit [1~5]: \n');
        end

        switch base_edit_type
            case 1
                fprintf('\n[EDIT] 1. Location \n')

                % delete base location on map if location was already exists
                if ~isempty(current_base_plot{current_id_base})
                    delete(current_base_plot{current_id_base})
                    drawnow
                end
                % launch a new figure and click the mouse as many time as you want within figure
                disp('Click the mouse wherever in the figure.');
                title('Click Base Location : Click the mouse wherever in the figure.')
                mousePointCoords = ginput(1);
                mousePointCoords(mousePointCoords>100)=100;
                mousePointCoords(mousePointCoords<0)=0;
                title('Mission Map.')

                % Update Base location
                BaseTable(current_id_base,:).Location_X   = {mousePointCoords(:,1)};
                BaseTable(current_id_base,:).Location_Y   = {mousePointCoords(:,2)};

                % Draw base location on map
                current_base_plot{current_id_base} = plot(BaseTable(current_id_base,:).Location_X{1}, BaseTable(current_id_base,:).Location_Y{1},'*r');

            case 2
                fprintf('\n[EDIT] 2. Property : is this base can contain Sea agents? Y/N ')
                BaseTable(current_id_base,:).isSea_base = ~BaseTable(current_id_base,:).isSea_base;
            case 3
                fprintf('\n[EDIT] 3. Property : is this base can contain Air agents? Y/N ')
                BaseTable(current_id_base,:).isAir_base = ~BaseTable(current_id_base,:).isAir_base;
            case 4
                fprintf('\n[EDIT] 4. Property : is this base can contain Land agents? Y/N ')
                BaseTable(current_id_base,:).isLand_base = ~BaseTable(current_id_base,:).isLand_base;

            case 5
                fprintf('\n[EDIT] 5. Current Base %d Location is [%f %f]\n', current_id_base, cell2mat(BaseTable(current_id_base,:).Location_X), cell2mat(BaseTable(current_id_base,:).Location_Y))
                BaseTable(current_id_base,:).Location_X = {input('Base X Coordinate [0~100]: ')};
                BaseTable(current_id_base,:).Location_Y = {input('Base Y Coordinate [0~100]: ')};

            case 6
                fprintf('\n--------------Base [%d] Edit Finised--------------\n\n\n\n', current_id_base)
                break
                valid_input_flag=0;
            otherwise
                fprintf('\n Please Select valid propety to edit \n')

        end
        fprintf('\n\n\n')
        disp(BaseTable)

    end



    % Select Continue Base Edit or (Exit -> To Agent Edit mode)
    fprintf('PLEASE SELECT \n1. Continue Base Edit \n2. Finish Base Edit\n')
    BaseEditMode = round(input("Select [1 or 2] : "));
    % for input mistake
    while ~(isempty(BaseEditMode) || (BaseEditMode > 0) || (BaseEditMode < 3))
        fprintf('You Put Wrong Number. \nSELECT \n1. Edit Base Mode \n2. Finish Base Edit')
        BaseEditMode = round(input("Select [1 or 2] : "));
    end
    if BaseEditMode == 2
        break
    end



end
    % Save Base information in BaseTable.mat
    save('BaseTable.mat', 'BaseTable','num_base')

    


% Plot Base Locations on map figure 
plot(cell2mat(BaseTable(:,:).Location_X), cell2mat(BaseTable(:,:).Location_Y),'r*');
for baseplot_idx = 1:num_base
    tempstr = ['\leftarrow Base',num2str(baseplot_idx)];
    text(cell2mat(BaseTable(baseplot_idx,:).Location_X), cell2mat(BaseTable(baseplot_idx,:).Location_Y),tempstr)
end












%% Agent data Input
clc
disp(BaseTable)

% Load previous saved Base data (BaseTable.mat)
load_agent = input('\n Do you want to load preivous Agent information? (AgentTable.mat) (y/n) :','s');
if isempty(load_agent)
    load_agent = 'n';
end

if load_agent == 'n'
    
    fprintf('\n\n\n----------------------Agent input start------------------------------\n\n\n')

    fprintf('\n Please define [Unmanned Agent] information \n')
    num_agent = input('How many [Unmanned Agents] on environment? :  ');
    while isempty(num_agent) ||  (num_agent < 0)
        num_agent = input('How many [Unmanned Agents] on environment? :  ');
    end

    fprintf('There are %d Agents on environment \n',num_agent)

    % initalizing base table
    % % % % % id_agent = [1:num_agent]';
    % % % % % Agent_Type = ones(num_agent,1);
    % % % % % Agent_BaseDeployment = ones(num_agent,1);
    % % % % % Agent_Gear1 = logical( ones(num_agent,1) );
    % % % % % Agent_Gear2 = logical( ones(num_agent,1) );
    % % % % % Agent_Gear3 = logical( ones(num_agent,1) );
    % % % % % AgentTable = table(id_agent,Agent_Type,Agent_BaseDeployment,Agent_Gear1,Agent_Gear2, Agent_Gear3);
    % % % % % 

    % initalizing base cell struct -> table
    AgentStruct = {};
    AgentTable = [];
    for i = 1:num_agent
        AgentStruct{i}.id_agent = i;
        AgentStruct{i}.Agent_Type = 1;
        AgentStruct{i}.Agent_BaseDeployment = 1;
        AgentStruct{i}.Agent_Gear1 = logical(0); % Camera
        AgentStruct{i}.Agent_Gear2 = logical(0); % Sensor X
        AgentStruct{i}.Agent_Gear3 = logical(0); % Transport
        AgentStruct{i}.Agent_Gear4 = logical(0); % Rescue Tube
        AgentStruct{i}.Location_X=BaseTable(AgentStruct{i}.Agent_BaseDeployment,:).Location_X;
        AgentStruct{i}.Location_Y=BaseTable(AgentStruct{i}.Agent_BaseDeployment,:).Location_Y;
        AgentStruct{i}.Speed = 10; % [unit length]/[unit time]
        AgentStruct{i}.EnergyConsumption = 2; % [%]/[unit time] 
        AgentStruct{i}.RemainEnergy = 100;
        AgentStruct{i}.MineCheckProbability = 0;

        AgentTableTemp = struct2table(AgentStruct{i},'AsArray',true);
        AgentTable = [AgentTable; AgentTableTemp];
    end

else
    load AgentTable.mat
    fprintf('Previous Agent Table data loaded(AgentTable.mat)')
end
AgentEditMode=1;
current_base_plot = cell(1,num_base);
while AgentEditMode
    disp(AgentTable)
    % Select Agent for edit
    current_id_agent = input('Select Agent id for edit : ');
    while isempty(current_id_agent) || (current_id_agent > num_agent) || (current_id_agent < 0) 
        fprintf('\nThere is %d Agents on environment \n',num_agent)
        current_id_agent = input('Select valid Agent id for edit : ');
    end

    % Agent Detail input
    fprintf('\n---------------Agent Edit Mode-------------\n')
    disp(AgentTable)
    valid_input_flag = 1;
    while(valid_input_flag)

        fprintf('Current Agent id is [%d] \n',current_id_agent)
        fprintf('1. Agent Type \n')
        fprintf('2. Agent BaseDeployment \n')
        fprintf('3. Agent Gear1 (Camera) : Y/N \n')
        fprintf('4. Agent Gear2 (SensorX) : Y/N \n')
        fprintf('5. Agent Gear3 (Transporter) : Y/N \n')
        fprintf('6. Agent Gear4 (Tube) : Y/N \n')
        fprintf('7. Speed \n')
        fprintf('8. EnergyConsumption \n')
        fprintf('9. RemainEnergy \n')
        fprintf('10. Finish Editing \n')
        agent_edit_type = input('Choose property type to edit [1~10]: ');
        while isempty(agent_edit_type) || (agent_edit_type > 10) || (agent_edit_type < 0) 
            agent_edit_type = input('Choose property type to edit [1~10]: ');
        end

        switch agent_edit_type
            case 1
                fprintf('[EDIT] 1. Agent_Type \n')
                AgentTable(current_id_agent,:).Agent_Type = input('Type ? (UAV=1, UGV=2, USV=3) :');
                while (AgentTable.Agent_Type(current_id_agent) < 0) || (AgentTable.Agent_Type(current_id_agent) > 3)
                    % errordlg('Please input valid type (UAV=1, UGV=2, USV=3)','Error')
                    AgentTable(current_id_agent,:).Agent_Type= input('Input valid agent Type (UAV=1, UGV=2, USV=3) :');    
                end

            case 2
                fprintf('[EDIT] 2. Agent BaseDeployment : \n Select Base to deploy [1~%d] \n',num_base)
                AgentTable(current_id_agent,:).Agent_BaseDeployment = input('Which base do you want to deploy? :');
                while (AgentTable(current_id_agent,:).Agent_BaseDeployment < 0) || (AgentTable(current_id_agent,:).Agent_BaseDeployment > num_base)
                    % errordlg('Please input valid type (UAV=1, UGV=2, USV=3)','Error')
                    AgentTable(current_id_agent,:).Agent_BaseDeployment = input('Error : Which base do you want to deploy? :');
                end
                AgentTable(current_id_agent,:).Location_X = BaseTable(AgentTable(current_id_agent,:).Agent_BaseDeployment,:).Location_X;
                AgentTable(current_id_agent,:).Location_Y = BaseTable(AgentTable(current_id_agent,:).Agent_BaseDeployment,:).Location_Y;


            case 3
                fprintf('[EDIT] 3. Mount Gear 1 (Camera) : Y/N \n')
                AgentTable(current_id_agent,:).Agent_Gear1 = ~AgentTable.Agent_Gear1(current_id_agent);
            case 4
                fprintf('[EDIT] 4. Mount Gear 2 (SensorX) : Y/N \n')
                AgentTable(current_id_agent,:).Agent_Gear2 = ~AgentTable.Agent_Gear2(current_id_agent);
            case 5
                fprintf('[EDIT] 5. Mount Gear 3 (Transporter) : Y/N \n')
                AgentTable(current_id_agent,:).Agent_Gear3 = ~AgentTable.Agent_Gear3(current_id_agent);
            case 6
                fprintf('[EDIT] 6. Mount Gear 4 (Rescue Tube) : Y/N \n')
                AgentTable(current_id_agent,:).Agent_Gear4 = ~AgentTable.Agent_Gear4(current_id_agent);

            case 7
                AgentTable(current_id_agent,:).EnergyConsumption = input('[EDIT] 7. Speed [unit length]/[unit time]:');
                while (AgentTable.Speed(current_id_agent) < 0) || (AgentTable.Speed(current_id_agent) > 9000)
                    AgentTable(current_id_agent,:).EnergyConsumption = input('[EDIT] 7. Speed [unit length]/[unit time]:');    
                end

            case 8
                AgentTable(current_id_agent,:).Agent_Type = input('[EDIT] 8. EnergyConsumption 0~100 [%%]/[unit time] :');
                while (AgentTable.EnergyConsumption(current_id_agent) <= 0) || (AgentTable.EnergyConsumption(current_id_agent) >= 100)
                    AgentTable(current_id_agent,:).Agent_Type = input('[EDIT] 8. EnergyConsumption 0~100 [%%]/[unit time] ::');    
                end

            case 9
                AgentTable(current_id_agent,:).RemainEnergy = input('[EDIT] 9. RemainEnergy [0~100][%%]:');
                while (AgentTable.RemainEnergy(current_id_agent) <= 0) || (AgentTable.RemainEnergy(current_id_agent) >= 100)
                    AgentTable(current_id_agent,:).RemainEnergy = input('[EDIT] 9. RemainEnergy [0~100][%%]:');    
                end

            case 10
                fprintf('--------------Agent Edit Finised--------------\n\n\n')
                valid_input_flag=0;
            otherwise
                fprintf('\n Please Select valid propety to edit \n')

        end
        fprintf('\n\n\n')
        disp(AgentTable)
    end


    % Select Continue Base Edit or (Exit -> To Agent Edit mode)
    fprintf('PLEASE SELECT \n1. Continue Agent Edit \n2. Finish Agent Edit\n')
    AgentEditMode = round(input("Select [1 or 2] : "));
    % for input mistake
    while ~(isempty(AgentEditMode) || (AgentEditMode > 0) || (AgentEditMode < 3))
        fprintf('You Put Wrong Number. \nPLEASE SELECT \n1. Edit Agent Mode \n2. Finish Agent Edit')
        AgentEditMode = round(input("Select [1 or 2] : "));
    end
    if AgentEditMode == 2
        break
    end


end



% Additional Agent information here

% Normal Operating Speed INFO Here
Agent_SpeedInfo = [3, 1, 2]; % UAV, UGV, USV

for agent_idx = 1:height(AgentTable)
    AgentTable.Speed(agent_idx) = Agent_SpeedInfo(AgentTable.Agent_Type(agent_idx));
end
% FUEL Consumption INFO Here (unit fuel consume/unit length move)
%     Gear1   Gear2   Gear3   Gear4
% UAV   1       1       1       1
% UGV   1       1       1       1
% USV   1       1       1       1
Agent_FuelConsumptionInfo = [1 1 1 1; 
                            2 2 2 2; 
                            3 3 3 3];

for agent_idx = 1:height(AgentTable)
    AgentTable.EnergyConsumption(agent_idx) = Agent_FuelConsumptionInfo(AgentTable.Agent_Type(agent_idx),:)*[AgentTable.Agent_Gear1(agent_idx) AgentTable.Agent_Gear2(agent_idx) AgentTable.Agent_Gear3(agent_idx) AgentTable.Agent_Gear4(agent_idx)]';
end

% Gear 1~4's Sensor range (Camera/SensorX/Transporter/RescueTube)
Agent_SensorRange_GearN = [2 3 0 0]; 
% NOT IMPLEMENTED

% Mine CheckProbability
% Mine CheckProbability INFO Here (0.85 = 85% probability to check mine)
%     Mine    
% UAV   0.7
% UGV   0.9
% USV   0
Agent_MineCheckProbInfo = [0.7; 
                            0.9; 
                            0];

for agent_idx = 1:height(AgentTable)
    AgentTable.MineCheckProbability(agent_idx) = Agent_MineCheckProbInfo(AgentTable.Agent_Type(agent_idx),:);
end


% FOR DEBUGGING
save('AgentTable.mat', 'AgentTable','num_agent')




disp(AgentTable)













%% Objective Location Input
% 받아야 하는거 : 복합임무별로 다르게 필요한 임무지역 위치정보, 
%                 임무 지역 별 중요도(이거 있어야 기술2,3에서 동일 문제 풀수있음 -> reward로 쓰일듯?)
% polygon 내 grid 포인트 
% 임무 지역 별 시간 및 순서 정보(TBD) -> 이거 필요한지 아직 모르겠음, 할당,강화학습 측에서의 결과물과 상충되면 안됨 ->
% 큰 Task 순서는 만들어야 할 듯
% Undecided point들은(popup-threat) 일단 unavailable로 표시 후 상황인식모듈 만들어서 해당 모듈이 시뮬레이터 px4에서
% 받아오는 값으로 task내 정보를 update해야 할 듯

%
% plot Empty Map Figure
fig1 = figure;
title('Mission Map')
plot([],[],'-')
axis equal;
xlim([0 MainMissionGlobalArea(1)]); 
ylim([0 MainMissionGlobalArea(2)]);
hold on;
% Plot Base Locations on map figure 
plot(cell2mat(BaseTable(:,:).Location_X), cell2mat(BaseTable(:,:).Location_Y),'r*');
for baseplot_idx = 1:num_base
    tempstr = ['\leftarrow Base',num2str(baseplot_idx)];
    text(cell2mat(BaseTable(baseplot_idx,:).Location_X), cell2mat(BaseTable(baseplot_idx,:).Location_Y),tempstr)
end




clc
disp(BaseTable)
disp(AgentTable)


% Load previous saved Base data (BaseTable.mat)
load_obj = input('\n Do you want to load preivous Obj information? (BigObjTable.mat) (y/n) :','s');
if isempty(load_obj)
    str = 'n';
end





if load_obj == 'n'

    fprintf('\n\n\n----------------------Objective input start------------------------------\n\n\n')
    fprintf('\n Please define Objective information \n')

    % 주 임무 목표 지점 위치정보 입력
    switch mission_type
        case 1
            fprintf('1. 해양사고 조난자 수색 및 구조 (Selected)\n')
            fprintf('1-1.조난자 발생 의심구역 설정\n')
            % 해양사고 Obj Point Type 1 : 해상 조난자 발생 의심구역
            num_obj1 = input('How many Monitoring area on exists on this environment? (2개정도 추천) :  ');
            fprintf('There is %d Monitoring area on this mission \n \n',num_obj1)



            % DEBUG용 --> 나중에는 사라져야함
            % -> simulator에서 popup point location 받아와야 함
            fprintf('1-2 : [NOW EDIT]조난자 수색 지점(테스트용, popup point 받아와야함) \n')
            fprintf('(원래는 모르는) 조난자 발생 지점 설정\n')
            % 해양사고 Obj Point Type 2 : 조난자 수색 지점 
            num_obj2 = input('How many Popup points on exists on this environment? (5개정도):  ');
            fprintf('There is %d Monitoring points on this mission \n \n',num_obj2)
            % DEBUG용 --> 나중에는 사라져야함



            fprintf('1-3 : 조난자 구조 후 육지 상륙 및 이송지점 설정\n')
             % 해양사고 Obj Point Type 3 : 조난자 구조 후 육지 상륙 및 이송지점
            num_obj3 = input('How many rescue points/area on exists on this environment? :  ');
            fprintf('There is %d rescue points/area on this mission \n \n',num_obj3)

            objlist = [num_obj1 num_obj2 num_obj3];
            total_num_obj=num_obj1 + num_obj2 + num_obj3;
            obj_step = 3;



        case 2
            fprintf('2. 불법 조업 및 영해 침범 감시 (Selected)\n')

            % 해상감시 Obj Point Type 1 : 해상 불법 행위 발생 의심구역(사용자가)
            num_obj1 = input('How many Monitoring points/area on exists on this environment? :  ');
            fprintf('There is %d Monitoring points/area on this mission \n \n',num_obj1)

            % 해상감시 Obj Point Type 2 : 표적 추적/경고/대응 --> Type 1 의심구역 내에서 발생할 것이므로
            %                                                     Type1 정보 그대로
            %                                                     사용 -->
            %                                                     시뮬레이터에서 새로
            %                                                     보내주는 위치로 갱신
            num_obj2 = input('How many target(illegal boat) on exists on this environment? :  ');
            fprintf('There is %d target(illegal boat) points on this mission \n \n',num_obj2)



            % 해상감시 Obj Point Type 3 : 조난자 구조 후 육지 상륙 및 이송지점 (사건발생 이후)
            num_obj3 = input('How many rescue points/area on exists on this environment? :  ');
            fprintf('There is %d rescue points/area on this mission \n \n',num_obj3)

            objlist = [num_obj1 num_obj2 num_obj3];
            total_num_obj=num_obj1+num_obj2+num_obj3;
            obj_step = 3;


        case 3
            fprintf('3. 환경오염 모니터링 및 추적 (Selected)\n')

            % 오염감시 Obj Point Type 1 : 오염물질 발생 의심지역 지정(사용자가)
            num_obj1 = input('How many Monitoring points/area on exists on this environment? :  ');
            fprintf('There is %d Monitoring points/area on this mission \n \n',num_obj1)
            
            % 오염감시 Obj Point Type 2 : 오염원 조사 --> Type 1 내에서 발생, 그대로 사용
            num_obj2 = input('How many Origin points/area on exists on this environment? :  ');
            fprintf('There is %d Origin points/area on this mission \n \n',num_obj1)

            
            objlist = [num_obj1 num_obj2];
            total_num_obj=num_obj1+num_obj2;
            obj_step = 2;

        case 4
            fprintf('4. 긴급 무선 통신망 구축 (Selected)\n')

            % 오염감시 Obj Point Type 1 : 통신중개 필요 지역 지정(사용자가)
            num_obj1 = input('How many Monitoring points/area on exists on this environment? :  ');
            fprintf('There is %d Monitoring points/area on this mission \n \n',num_obj1)

            % 오염감시 Obj Point Type 2 : 통신 중계 위치 최적화 --> Type 1 정보만 필요, 그대로 사용 (범위 내에서 중계는 2 3세부 알고리즘이 해야함)
            objlist = [num_obj1];
            total_num_obj=num_obj1;
            obj_step = 1;

        case 5
            fprintf('5. 정밀 농업 (Selected)\n')
            % 정밀농업 Obj Point Type 1 : 농경지 조사 지역 선정(사용자가)
            num_obj1 = input('How many Monitoring points/area on exists on this environment? :  ');
            fprintf('There is %d Monitoring points/area on this mission \n \n',num_obj1)

            % 정밀농업 Obj Point Type 2 : 파종 및 작물 모니터링 -> Type 1 정보에 기초해서 결정, 
            % input 프로그램이 파종구역 지정해야하나?(기술1 알고리즘) or 작업 할당/강화학습이 담당해야 하나?(기술 2,3 알고리즘) 


            % 정밀농업 Obj Point Type 3 : 병충해 감시/농약살포 -> Type 2에서 결정된 구역 그대로 사용
            objlist = [num_obj1];
            total_num_obj=num_obj1;
            obj_step = 1;

       case 6
            fprintf('6. 지뢰 제거(BETA) (Selected)\n')
            % 지뢰제거 Obj Point Type 1 : 지뢰매설 조사 지역 선정(사용자가)
            num_obj1 = input('How many Monitoring points/area on exists on this environment? :  ');
            fprintf('There is %d Monitoring points/area on this mission \n \n',num_obj1)

            % 지뢰제거 Obj Point Type 2 : 지뢰 의심구역 -> Type 1 정보에 기초해서 결정, 
            num_obj2 = input('How many Dangerous area on exists on this environment? :  ');
            fprintf('There is %d Dangerous area on this mission \n \n',num_obj2)
            
            % 지뢰제거 Obj Point Type 3 : 지뢰 의심구역 Detail -> Type 1 정보에 기초해서 결정, Obj2 주변 구역을 설정할것임 
            num_obj3 = num_obj2;

            % 지뢰제거 Obj Point Type 4 : 의심 구역 내 지뢰 숫자 -> Type 2에서 결정된 구역 그대로 사용
            num_obj4 = input('How many mine in each area on exists on this environment? :  ');
            fprintf('There is %d mine in each area on this mission \n \n',num_obj4)

            
            objlist = [num_obj1 num_obj2 num_obj3 num_obj4];
            total_num_obj=num_obj1+num_obj2+num_obj3+num_obj4;
            obj_step = 4;
            
    end


    pointperarea = 0.1;
    % initalizing Objective cell struct -> table
    BigObjStruct={};
    ObjStruct = {};
    ObjTable = [];
    BigObjTable = {};
    for i = 1:obj_step
        ObjStruct = {};
        ObjTable = [];
        for j = 1:objlist(i)
            ObjStruct{j}.id_obj = j;
            ObjStruct{j}.Obj_Sea = logical(1);
            ObjStruct{j}.Obj_Air = logical(1);
            ObjStruct{j}.Obj_Land = logical(1);    

            ObjStruct{j}.Location_Poly_X={};
            ObjStruct{j}.Location_Poly_Y={};
            ObjStruct{j}.Location_Point_X={};
            ObjStruct{j}.Location_Point_Y={};

            ObjStruct{j}.Density=pointperarea;
            ObjStruct{j}.WindSpeed = 0;
            ObjStruct{j}.WindDirectionDegree = 0;
            
            ObjTableTemp = struct2table(ObjStruct{j},'AsArray',true);
            ObjTable = [ObjTable; ObjTableTemp];
        end
        BigObjStruct{i}= ObjStruct;
        BigObjTable{i}=ObjTable;
    end
    % % OLD
    % id_obj = [1:num_obj]';
    % Obj_Location_x = zeros(num_obj,1);
    % Obj_Location_y = zeros(num_obj,1);
    % Obj_Shape = logical( ones(num_obj,1) );
    % Obj_radius = zeros(num_obj,1)';
    % Obj_Sea = logical( ones(num_obj,1) );
    % Obj_Air = logical( ones(num_obj,1) );
    % Obj_Land = logical( ones(num_obj,1) );
    % ObjTable = table(id_obj,Obj_Location_x,Obj_Location_y,Obj_Shape,Obj_Sea, Obj_Air, Obj_Land);
    % disp(ObjTable)

else
    load BigObjTable.mat
end




if mission_type == 6
        current_Obj_plot_PTMine = cell(1,objlist(3));
        current_Obj_plot_PTMinedot = cell(1,objlist(3));
end
% Objective Edit
fprintf('\n---------------Obj Edit Mode-------------\n')
BigObjflag=1;
while (BigObjflag)

    Continue_Obj_prompt = 'Do you want Continue? Y/N [Y]: ';
    Continue_Obj_str = input(Continue_Obj_prompt,'s');
    if isempty(Continue_Obj_str)
        Continue_Obj_str = 'Y';
    end
    if Continue_Obj_str ~= 'Y'
        break
    end
    
    
    
    % Choose which objective to edit
    switch mission_type
        case 1
            fprintf('\n1. 해양사고 조난자 수색 및 구조 (Selected)\n\n')
            fprintf('M1-1 : 조난자 발생 의심구역 설정\n')
            fprintf('M1-2 : 조난자 수색 지점(테스트용, popup point 받아와야함) \n')
            fprintf('M1-3 : 조난자 구조 후 육지 상륙 및 이송지점 설정\n')
            i_obj_big = round(input('Choose objective to edit [1~3]: ')) ;

            obj_string1 = {'\n[NOW EDIT]M1.1 조난자 발생 의심구역 설정\n', '\n[NOW EDIT]M1.2 조난자 수색 지점(테스트용, popup point 받아와야함)\n','\n[NOW EDIT]M1.3 조난자 구조 후 육지 상륙 및 이송지점 설정\n'};
            fprintf(obj_string1{i_obj_big})

        case 2
            fprintf('2. 불법 조업 및 영해 침범 감시 (Selected)\n')

            fprintf('\n1. 불법 조업 및 영해 침범 감시 (Selected)\n\n')
            fprintf('M2-1 : 불법 조업/영해 침범 의심구역 설정\n')
            fprintf('M2-2 : 범법자 수색 지점(테스트용, popup point 받아와야함) \n')
            fprintf('M2-3 : 범법자 체포 후 육지 상륙 및 이송지점 설정\n')
            i_obj_big = round(input('Choose objective to edit [1~3]: ')) ;

            obj_string2 = {'\n[NOW EDIT]M2.1 불법 조업/영해 침범 의심구역 설정\n', '\n[NOW EDIT]M2.2 범법자 수색 지점(테스트용, popup point 받아와야함)\n','\n[NOW EDIT]M2.3 범법자 체포 후 육지 상륙 및 이송지점 설정\n'};
            fprintf(obj_string2{i_obj_big})


        case 3
            fprintf('3. 환경오염 모니터링 및 추적 (Selected)\n')
            fprintf('\n1. 환경오염 모니터링 및 추적 (Selected)\n\n')
            fprintf('M3-1 : 환경오염 의심구역 설정\n')
            fprintf('M3-2 : 환경오염 맵핑 지점(테스트용, popup point 받아와야함) \n')
            i_obj_big = round(input('Choose objective to edit [1~2]: ')) ;

            obj_string3 = {'\n[NOW EDIT]M3.1 환경오염 의심구역 설정\n', '\n[NOW EDIT]M3.2 환경오염 맵핑 지점(테스트용, popup point 받아와야함)\n'};
            fprintf(obj_string3{i_obj_big})

        case 4
            fprintf('4. 긴급 무선 통신망 구축 (Selected)\n')

            fprintf('\n1. 긴급 무선 통신망 구축 (Selected)\n\n')
            fprintf('M4-1 : 통신망 구축 지역 설정\n')
            i_obj_big = round(input('Choose objective to edit [1]: ')) ;

            obj_string4 = {'\n[NOW EDIT]M4.1 통신망 구축 지역 설정\n'};
            fprintf(obj_string4{i_obj_big})

        case 5
            fprintf('5. 정밀 농업 (Selected)\n')

            fprintf('\n1. 정밀 농업 (Selected)\n\n')
            fprintf('M5-1 : 농경지 후보 지역 설정\n')

            i_obj_big = round(input('Choose objective to edit [1]: ')) ;

            obj_string5 = {'\n[NOW EDIT]M5.1 농경지 후보 지역 설정\n'};
            fprintf(obj_string5{i_obj_big})
            
        case 6
            fprintf('6. 지뢰제거(BETA) (Selected)\n')

            fprintf('\n1. 정밀 농업 (Selected)\n\n')
            fprintf('M6-1 : 지뢰매설 (후보) 지역 설정\n')
            fprintf('M6-3 : 지뢰매설 (의심) 지역 설정\n')
            i_obj_big = round(input('Choose objective to edit [1,3]: ')) ;
            
            obj_string6 = {'\n[NOW EDIT]M6-1 : 지뢰매설 (후보) 지역 설정\n', '','\n[NOW EDIT]M6-3 : 지뢰매설 (의심) 지역 설정\n',''};
            fprintf(obj_string6{i_obj_big})

    end


    disp(BigObjTable{i_obj_big})
    current_id_obj = input("Select obj id for edit [1~"+ objlist(i_obj_big) + "] :");

    while  isempty(current_id_obj) || (current_id_obj > objlist(i_obj_big) ) || (current_id_obj < 0) 
        fprintf("\nThere is "+objlist(i_obj_big)+" objective for"+ obj_string1{i_obj_big}+"\n")
        current_id_obj = input("Select VALID obj id for edit [1~"+ objlist(i_obj_big) + "] :");
    end



    % Initialize for drawing plot
    current_Obj_plot_PT = cell(1,objlist(i_obj_big));
    current_Obj_plot_PTDot = cell(1,objlist(i_obj_big));
    
    
        % Small Obj Detail input loop
        
        valid_input_flag = 1;
        while(valid_input_flag)
            fprintf('\n\n\n')
            disp(BigObjTable{i_obj_big})

            fprintf('Current Obj id is [%d] \n',current_id_obj)
            fprintf('1. Obj Location \n')
            fprintf('2. Obj_Sea : Y/N \n')
            fprintf('3. Obj_Air : Y/N \n')
            fprintf('4. Obj_Land : Y/N \n')
            fprintf('5. Edit Obj Location \n')
            fprintf('6. Obj Grid Density setting \n')
            fprintf('7. Obj Wind Speed (Pollution) \n')
            fprintf('8. Obj Wind Direction in degree (Pollution) \n')
            fprintf('9. Finish Editing \n')

            obj_edit_type = input('Choose property type to edit [1~9]: ');
            while isempty(obj_edit_type) || (obj_edit_type > 9) || (obj_edit_type < 0) 
                obj_edit_type = input('Choose property type to edit [1~9]: ');
            end
            
            pointperarea=BigObjTable{i_obj_big}(current_id_obj,:).Density;
            switch obj_edit_type
                case 1
                    % Objective Location
                    fprintf('\n[EDIT] 1. Objective Location \n')

                    % delete Obj plot location on map if location was already exists
                    if ~isempty(current_Obj_plot_PT{current_id_obj})
                        delete(current_Obj_plot_PT{current_id_obj})
                        delete(current_Obj_plot_PTDot{current_id_obj})
                        drawnow
                    end

                    % click the mouse as many time as you want within figure
                    disp('Click the mouse wherever in the figure; press ENTER when finished.');
                    title('Draw Mission Area : Click the mouse wherever in the figure; press ENTER when finished.')
                    mousePointCoords = ginput;
                    % condition to change exceed value in 0~100 range
                    mousePointCoords(mousePointCoords>100)=100;
                    mousePointCoords(mousePointCoords<0)=0;
                    title('Mission Map.')

                    % Update Objective location
                    BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X   = {mousePointCoords(:,1)};
                    BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_Y   = {mousePointCoords(:,2)};

                    % Draw Obj Area Point location on map
                    mousePointCoordsdraw = [mousePointCoords; mousePointCoords(1,:)];
                    current_Obj_plot_PT{current_id_obj} = plot(mousePointCoordsdraw(:,1),mousePointCoordsdraw(:,2),'-*k');

                    % calculate point area
                    if min(size(mousePointCoords)) == 1
                        legend('Point')
                    else
                        legend('Area')
                        pointinarea = polygrid(mousePointCoordsdraw(:,1), mousePointCoordsdraw(:,2), pointperarea);

                        % Draw Obj Area location on map
                        current_Obj_plot_PTDot{current_id_obj} = plot(pointinarea(:,1),pointinarea(:,2), '*b');

                        % Save Obj Area Data on Table
                        BigObjTable{i_obj_big}(current_id_obj,:).Location_Point_X = {pointinarea(:,1)};
                        BigObjTable{i_obj_big}(current_id_obj,:).Location_Point_Y = {pointinarea(:,2)};


                        allpointsinarea =[];
                        for tempidx = 1:objlist(i_obj_big)
                            tempval=[BigObjTable{i_obj_big}.Location_Point_X{tempidx} BigObjTable{i_obj_big}.Location_Point_Y{tempidx}];
                            if ~iscell(tempval)
                                allpointsinarea =[allpointsinarea ; tempval];
                            end
                        end


                        % FOR DEBUG - Popup Threat 구현하기 -> 1st obj 범위에서
                        % 구역 내에서 Popup point 무작위로 뽑아오기  (갱신)
                        if mission_type == 1 && i_obj_big == 1 || mission_type == 2 && i_obj_big== 1 ||mission_type == 3 && i_obj_big== 1
                            if length(allpointsinarea) < objlist(2) % grid point 수가 너무 적을 경우 
                                error('All points in area (%d) are not enough for generate popup (%d) point\n', length(allpointsinarea),objlist(2) )
                                % temp_pointinarea = polygrid(temp(:,1), temp(:,2), pointperarea*10);
                                % popup_pt = temp_pointinarea(randsample(1:length(temp_pointinarea), objlist(2) ), :);
                            else
                                popup_pt = allpointsinarea(randsample(1:length(allpointsinarea), objlist(2) ), :);
                            end

                            for i_popup = 1:objlist(2)
                                BigObjTable{2}(i_popup,:).Location_Point_X = {popup_pt(i_popup,1)};
                                BigObjTable{2}(i_popup,:).Location_Point_Y = {popup_pt(i_popup,2)};
                            end
                            
                        elseif mission_type == 6 && i_obj_big == 1 % 지뢰제거용 특수 모듈
                            % Reset graph of obj 3
%                             if ~isempty(current_Obj_plot_PTMine{1})
                            
                            for temp_idx =1:length(current_Obj_plot_PTMine)
                                delete(current_Obj_plot_PTMine{temp_idx})
                                delete(current_Obj_plot_PTMinedot{temp_idx})
                                drawnow
                            end

%                                 set(current_Obj_plot_PTMine,'Visible','off')
%                                 set(current_Obj_plot_PTMinedot,'Visible','off')
%                                 drawnow
%                             end
                            
                            if length(allpointsinarea) < objlist(2) % grid point 수가 너무 적을 경우 
                                error('All points in area (%d) are not enough for generate popup (%d) point\n', length(allpointsinarea),objlist(2) )
                                % temp_pointinarea = polygrid(temp(:,1), temp(:,2), pointperarea*10);
                                % popup_pt = temp_pointinarea(randsample(1:length(temp_pointinarea), objlist(2) ), :);
                            else
                                popup_pt = allpointsinarea(randsample(1:length(allpointsinarea), objlist(2) ), :);
                            end
                            
                            for i_popup = 1:objlist(2)
                                BigObjTable{2}(i_popup,:).Location_Point_X = {popup_pt(i_popup,1)};
                                BigObjTable{2}(i_popup,:).Location_Point_Y = {popup_pt(i_popup,2)};
                            end
                            

                            % Obj 2(points) to Obj3(area)
                            for i_popup2 = 1:objlist(2)
                                % Obj3 Polygon vertex from obj 2
                                poppopup_area = popup_pt(i_popup2,:)+[5,0;0,5;-5,0;0,-5];
                                BigObjTable{3}(i_popup2,:).Location_Poly_X={poppopup_area(:,1)};
                                BigObjTable{3}(i_popup2,:).Location_Poly_Y={poppopup_area(:,2)};
                                
                                % Obj3 Polygon grid point
                                poppopup_grid = polygrid(poppopup_area(:,1), poppopup_area(:,2), pointperarea*2);
                                BigObjTable{3}(i_popup2,:).Location_Point_X={poppopup_grid(:,1)};
                                BigObjTable{3}(i_popup2,:).Location_Point_Y={poppopup_grid(:,2)};
                                
                                
                                current_Obj_plot_PTMine{i_popup2} = plot(poppopup_area(:,1),poppopup_area(:,2),'-*g');
                                current_Obj_plot_PTMinedot{i_popup2} = plot(poppopup_grid(:,1),poppopup_grid(:,2),'*m');
                                
                            end
                                
                            
                            
                                % Select Obj 3's popup
                                allpointsinarea2 =[];
                                for tempidx2 = 1:objlist(3)
                                    tempval2=[BigObjTable{3}.Location_Point_X{tempidx2} BigObjTable{3}.Location_Point_Y{tempidx2}];
                                    if ~iscell(tempval2)
                                        allpointsinarea2 =[allpointsinarea2 ; tempval2];
                                    end
                                end
                                if length(allpointsinarea2) < objlist(4) % grid point 수가 너무 적을 경우 
                                    error('All points in area (%d) are not enough for generate popup (%d) point\n', length(allpointsinarea2),objlist(4) )
                                    % temp_pointinarea = polygrid(temp(:,1), temp(:,2), pointperarea*10);
                                    % popup_pt = temp_pointinarea(randsample(1:length(temp_pointinarea), objlist(2) ), :);
                                else
                                    poppoppopup_pt = allpointsinarea2(randsample(1:length(allpointsinarea2), objlist(4) ), :);
                                    for i_popup3 = 1:objlist(4)
                                        BigObjTable{4}(i_popup3,:).Location_Point_X={poppoppopup_pt(i_popup3,1)};
                                        BigObjTable{4}(i_popup3,:).Location_Point_Y={poppoppopup_pt(i_popup3,2)};
                                    end
                                end
                            
                        end

                    end



                case 2
                    fprintf('2. Obj_Sea : Y/N \n')
                    BigObjTable{i_obj_big}(current_id_obj,:).Obj_Sea = ~BigObjTable{i_obj_big}(current_id_obj,:).Obj_Sea;
                case 3
                    fprintf('3. Obj_Air : Y/N \n')
                    BigObjTable{i_obj_big}(current_id_obj,:).Obj_Air = ~BigObjTable{i_obj_big}(current_id_obj,:).Obj_Air;
                case 4
                    fprintf('4. Obj_Land : Y/N \n')
                    BigObjTable{i_obj_big}(current_id_obj,:).Obj_Land = ~BigObjTable{i_obj_big}(current_id_obj,:).Obj_Land;
                case 5
                    fprintf('5. Edit Obj Polygon by hand \n')
                    fprintf('Current Obj %d-%d s polygon vertex is : \n',i_obj_big , current_id_obj) 
                    disp([BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1}, BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_Y{1}])
                    for loc_poly_idx = 1:length(BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1})
                        fprintf('Edit %d/%d th polygon vertex : \n',loc_poly_idx,length(BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1}))
                        disp([BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1}(loc_poly_idx), BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_Y{1}(loc_poly_idx)])
                        BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1}(loc_poly_idx) = input('X Coordinate [0~100]: ');
                        BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_Y{1}(loc_poly_idx) = input('Y Coordinate [0~100]: ');
                    end
                    BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1}(BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1}<0)=0;
                    BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1}(BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1}>100)=100;
                    BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_Y{1}(BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_Y{1}<0)=0;
                    BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_Y{1}(BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_Y{1}>100)=100;

                    % calculate point area
                    if length(BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1}) == 1
                        fprintf('Point Edit Finished\n')
                        if ~isempty(current_Obj_plot_PT{current_id_obj})
                            delete(current_Obj_plot_PT{current_id_obj})
                            drawnow
                        end
                        temp=[BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1} BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_Y{1}];
                        current_Obj_plot_PT{current_id_obj} = plot(temp(:,1),temp(:,2),'-*g');

                    else
                        fprintf('Draw Edited polygon\n')
                        % For Plot and renew obj popup 
                        if ~isempty(current_Obj_plot_PT{current_id_obj})
                            delete(current_Obj_plot_PT{current_id_obj})
                            delete(current_Obj_plot_PTDot{current_id_obj})
                            drawnow
                        end
                        temp=[BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1} BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_Y{1}];

                        pointinarea = polygrid(temp(:,1), temp(:,2), BigObjTable{i_obj_big}(current_id_obj,:).Density);
                        % Draw Obj Area location on map
                        current_Obj_plot_PT{current_id_obj} = plot(temp(:,1),temp(:,2),'-*k');
                        current_Obj_plot_PTDot{current_id_obj} = plot(pointinarea(:,1),pointinarea(:,2), '*b');

                        % Save Obj Area Data on Table
                        BigObjTable{i_obj_big}(current_id_obj,:).Location_Point_X = {pointinarea(:,1)};
                        BigObjTable{i_obj_big}(current_id_obj,:).Location_Point_Y = {pointinarea(:,2)};

                        % Collect all main obj points for popup point selection
                        allpointsinarea =[];
                        for tempidx = 1:objlist(i_obj_big)
                            tempval=[BigObjTable{i_obj_big}.Location_Point_X{tempidx} BigObjTable{i_obj_big}.Location_Point_Y{tempidx}];
                            if ~iscell(tempval)
                                allpointsinarea =[allpointsinarea ; tempval];
                            end
                        end

                        % FOR DEBUG - Popup Threat 구현하기 -> 1st obj 범위에서
                        % 구역 내에서 Popup point 무작위로 뽑아오기  (갱신)
                        if mission_type == 1 && i_obj_big == 1 || mission_type == 2 && i_obj_big== 1 ||mission_type == 3 && i_obj_big== 1
                            if length(allpointsinarea) < objlist(2) % grid point 수가 너무 적을 경우 
                                error('All pointsr in area (%d) are not enough for generate popup (%d) point\n', length(allpointsinarea),objlist(2) )
                                % temp_pointinarea = polygrid(temp(:,1), temp(:,2), pointperarea*10);
                                % popup_pt = temp_pointinarea(randsample(1:length(temp_pointinarea), objlist(2) ), :);
                            else
                                popup_pt = allpointsinarea(randsample(1:length(allpointsinarea), objlist(2) ), :);
                            end

                            for i_popup = 1:objlist(2)
                                BigObjTable{2}(i_popup,:).Location_Point_X = {popup_pt(i_popup,1)};
                                BigObjTable{2}(i_popup,:).Location_Point_Y = {popup_pt(i_popup,2)};
                            end
                        elseif mission_type == 6 && i_obj_big == 1 % 지뢰제거용 특수 모듈
                            % Reset graph of obj 3
%                             if ~isempty(current_Obj_plot_PTMine{1})
                            
                            for temp_idx =1:length(current_Obj_plot_PTMine)
                                delete(current_Obj_plot_PTMine{temp_idx})
                                delete(current_Obj_plot_PTMinedot{temp_idx})
                                drawnow
                            end

%                                 set(current_Obj_plot_PTMine,'Visible','off')
%                                 set(current_Obj_plot_PTMinedot,'Visible','off')
%                                 drawnow
%                             end
                            
                            if length(allpointsinarea) < objlist(2) % grid point 수가 너무 적을 경우 
                                error('All points in area (%d) are not enough for generate popup (%d) point\n', length(allpointsinarea),objlist(2) )
                                % temp_pointinarea = polygrid(temp(:,1), temp(:,2), pointperarea*10);
                                % popup_pt = temp_pointinarea(randsample(1:length(temp_pointinarea), objlist(2) ), :);
                            else
                                popup_pt = allpointsinarea(randsample(1:length(allpointsinarea), objlist(2) ), :);
                            end
                            
                            for i_popup = 1:objlist(2)
                                BigObjTable{2}(i_popup,:).Location_Point_X = {popup_pt(i_popup,1)};
                                BigObjTable{2}(i_popup,:).Location_Point_Y = {popup_pt(i_popup,2)};
                            end
                            

                            % Obj 2(points) to Obj3(area)
                            for i_popup2 = 1:objlist(2)
                                % Obj3 Polygon vertex from obj 2
                                poppopup_area = popup_pt(i_popup2,:)+[5,0;0,5;-5,0;0,-5];
                                BigObjTable{3}(i_popup2,:).Location_Poly_X={poppopup_area(:,1)};
                                BigObjTable{3}(i_popup2,:).Location_Poly_Y={poppopup_area(:,2)};
                                
                                % Obj3 Polygon grid point
                                poppopup_grid = polygrid(poppopup_area(:,1), poppopup_area(:,2), pointperarea*2);
                                BigObjTable{3}(i_popup2,:).Location_Point_X={poppopup_grid(:,1)};
                                BigObjTable{3}(i_popup2,:).Location_Point_Y={poppopup_grid(:,2)};
                                
                                current_Obj_plot_PTMine{i_popup2} = plot(poppopup_area(:,1),poppopup_area(:,2),'-*g');
                                current_Obj_plot_PTMinedot{i_popup2} = plot(poppopup_grid(:,1),poppopup_grid(:,2),'*m');
                            end
                            
                                % Select Obj 3's popup
                                allpointsinarea2 =[];
                                for tempidx2 = 1:objlist(3)
                                    tempval2=[BigObjTable{3}.Location_Point_X{tempidx2} BigObjTable{3}.Location_Point_Y{tempidx2}];
                                    if ~iscell(tempval2)
                                        allpointsinarea2 =[allpointsinarea2 ; tempval2];
                                    end
                                end
                                if length(allpointsinarea2) < objlist(4) % grid point 수가 너무 적을 경우 
                                    error('All points in area (%d) are not enough for generate popup (%d) point\n', length(allpointsinarea2),objlist(4) )
                                    % temp_pointinarea = polygrid(temp(:,1), temp(:,2), pointperarea*10);
                                    % popup_pt = temp_pointinarea(randsample(1:length(temp_pointinarea), objlist(2) ), :);
                                else
                                    poppoppopup_pt = allpointsinarea2(randsample(1:length(allpointsinarea2), objlist(4) ), :);
                                    for i_popup3 = 1:objlist(4)
                                        BigObjTable{4}(i_popup3,:).Location_Point_X={poppoppopup_pt(i_popup3,1)};
                                        BigObjTable{4}(i_popup3,:).Location_Point_Y={poppoppopup_pt(i_popup3,2)};
                                    end
                                end
                                
                        elseif mission_type == 6 && i_obj_big == 3
                            if length(allpointsinarea) < objlist(i_obj_big+1) % grid point 수가 너무 적을 경우 
                                error('All pointsr in area (%d) are not enough for generate popup (%d) point\n', length(allpointsinarea),objlist(i_obj_big+1) )
                                % temp_pointinarea = polygrid(temp(:,1), temp(:,2), pointperarea*10);
                                % popup_pt = temp_pointinarea(randsample(1:length(temp_pointinarea), objlist(2) ), :);
                            else
                                popup_pt = allpointsinarea(randsample(1:length(allpointsinarea), objlist(i_obj_big+1) ), :);
                            end

                            for i_popup = 1:objlist(i_obj_big+1)
                                BigObjTable{i_obj_big+1}(i_popup,:).Location_Point_X = {popup_pt(i_popup,1)};
                                BigObjTable{i_obj_big+1}(i_popup,:).Location_Point_Y = {popup_pt(i_popup,2)};
                            end
                        end
                    end

                case 6
                    fprintf('6. Obj Grid Density setting \n')
                    fprintf('Current grid densitty is : %.3f \n', BigObjTable{i_obj_big}(current_id_obj,:).Density)
                    BigObjTable{i_obj_big}(current_id_obj,:).Density = input('Grid point Density [0.001~10]: ');

                    % calculate point area
                    if length(BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1}) == 1
                        fprintf('Point Edit Finished')
                    else
                        fprintf('Draw Edited polygon')
                        fprintf('Redrawing locations on map figure\n')
                        % delete Obj plot location on map if location was already exists
                        if ~isempty(current_Obj_plot_PT{current_id_obj})
                            delete(current_Obj_plot_PT{current_id_obj})
                            delete(current_Obj_plot_PTDot{current_id_obj})
                            drawnow
                        end
                        temp=[BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_X{1} BigObjTable{i_obj_big}(current_id_obj,:).Location_Poly_Y{1}];

                        pointinarea = polygrid(temp(:,1), temp(:,2), BigObjTable{i_obj_big}(current_id_obj,:).Density);
                        
                        
                        % Draw Obj Area location on map
                        current_Obj_plot_PT{current_id_obj} = plot(temp(:,1),temp(:,2),'-*k');
                        current_Obj_plot_PTDot{current_id_obj} = plot(pointinarea(:,1),pointinarea(:,2), '*b');

                        % Save Obj Area Data on Table
                        BigObjTable{i_obj_big}(current_id_obj,:).Location_Point_X = {pointinarea(:,1)};
                        BigObjTable{i_obj_big}(current_id_obj,:).Location_Point_Y = {pointinarea(:,2)};

                        % Collect all main obj points for popup point selection
                        allpointsinarea =[];
                        for tempidx = 1:objlist(i_obj_big)
                            tempval=[BigObjTable{i_obj_big}.Location_Point_X{tempidx} BigObjTable{i_obj_big}.Location_Point_Y{tempidx}];
                            if ~iscell(tempval)
                                allpointsinarea =[allpointsinarea ; tempval];
                            end
                        end

                        % FOR DEBUG - Popup Threat 구현하기 -> 1st obj 범위에서
                        % 구역 내에서 Popup point 무작위로 뽑아오기  (갱신)
                        if mission_type == 1 && i_obj_big == 1 || mission_type == 2 && i_obj_big== 1 ||mission_type == 3 && i_obj_big== 1
                            if length(allpointsinarea) < objlist(2) % grid point 수가 너무 적을 경우 
                                error('All pointsr in area (%d) are not enough for generate popup (%d) point\n', length(allpointsinarea),objlist(2) )
                                % temp_pointinarea = polygrid(temp(:,1), temp(:,2), pointperarea*10);
                                % popup_pt = temp_pointinarea(randsample(1:length(temp_pointinarea), objlist(2) ), :);
                            else
                                popup_pt = allpointsinarea(randsample(1:length(allpointsinarea), objlist(2) ), :);
                            end

                            for i_popup = 1:objlist(2)
                                BigObjTable{2}(i_popup,:).Location_Point_X = {popup_pt(i_popup,1)};
                                BigObjTable{2}(i_popup,:).Location_Point_Y = {popup_pt(i_popup,2)};
                            end
                        
                        elseif mission_type == 6 && i_obj_big == 1 % 지뢰제거용 특수 모듈
                            % Reset graph of obj 3
%                             if ~isempty(current_Obj_plot_PTMine{1})
                            
                            for temp_idx =1:length(current_Obj_plot_PTMine)
                                delete(current_Obj_plot_PTMine{temp_idx})
                                delete(current_Obj_plot_PTMinedot{temp_idx})
                                drawnow
                            end

%                                 set(current_Obj_plot_PTMine,'Visible','off')
%                                 set(current_Obj_plot_PTMinedot,'Visible','off')
%                                 drawnow
%                             end
                            
                            if length(allpointsinarea) < objlist(2) % grid point 수가 너무 적을 경우 
                                error('All points in area (%d) are not enough for generate popup (%d) point\n', length(allpointsinarea),objlist(2) )
                                % temp_pointinarea = polygrid(temp(:,1), temp(:,2), pointperarea*10);
                                % popup_pt = temp_pointinarea(randsample(1:length(temp_pointinarea), objlist(2) ), :);
                            else
                                popup_pt = allpointsinarea(randsample(1:length(allpointsinarea), objlist(2) ), :);
                            end
                            
                            % Update Obj 2 based on new Obj1's points
                            for i_popup = 1:objlist(2)
                                BigObjTable{2}(i_popup,:).Location_Point_X = {popup_pt(i_popup,1)};
                                BigObjTable{2}(i_popup,:).Location_Point_Y = {popup_pt(i_popup,2)};
                            end
                            

                            % Obj 2(points) to Obj3(area)
                            for i_popup2 = 1:objlist(2)
                                % Obj3 Polygon vertex from obj 2
                                poppopup_area = popup_pt(i_popup2,:)+[5,0;0,5;-5,0;0,-5];
                                BigObjTable{3}(i_popup2,:).Location_Poly_X={poppopup_area(:,1)};
                                BigObjTable{3}(i_popup2,:).Location_Poly_Y={poppopup_area(:,2)};
                                
                                % Obj3 Polygon grid point
                                poppopup_grid = polygrid(poppopup_area(:,1), poppopup_area(:,2), pointperarea*2);
                                BigObjTable{3}(i_popup2,:).Location_Point_X={poppopup_grid(:,1)};
                                BigObjTable{3}(i_popup2,:).Location_Point_Y={poppopup_grid(:,2)};
                                
                                current_Obj_plot_PTMine{i_popup2} = plot(poppopup_area(:,1),poppopup_area(:,2),'-*g');
                                current_Obj_plot_PTMinedot{i_popup2} = plot(poppopup_grid(:,1),poppopup_grid(:,2),'*m');
                            end
                                
                                % Select Obj 3's popup
                                allpointsinarea2 =[];
                                for tempidx2 = 1:objlist(3)
                                    tempval2=[BigObjTable{3}.Location_Point_X{tempidx2} BigObjTable{3}.Location_Point_Y{tempidx2}];
                                    if ~iscell(tempval2)
                                        allpointsinarea2 =[allpointsinarea2 ; tempval2];
                                    end
                                end
                                if length(allpointsinarea2) < objlist(4) % grid point 수가 너무 적을 경우 
                                    error('All points in area (%d) are not enough for generate popup (%d) point\n', length(allpointsinarea2),objlist(4) )
                                    % temp_pointinarea = polygrid(temp(:,1), temp(:,2), pointperarea*10);
                                    % popup_pt = temp_pointinarea(randsample(1:length(temp_pointinarea), objlist(2) ), :);
                                else
                                    poppoppopup_pt = allpointsinarea2(randsample(1:length(allpointsinarea2), objlist(4) ), :);
                                    for i_popup3 = 1:objlist(4)
                                        BigObjTable{4}(i_popup3,:).Location_Point_X={poppoppopup_pt(i_popup3,1)};
                                        BigObjTable{4}(i_popup3,:).Location_Point_Y={poppoppopup_pt(i_popup3,2)};
                                    end
                                end
                                
                        elseif mission_type == 6 && i_obj_big == 3
                            if length(allpointsinarea) < objlist(i_obj_big+1) % grid point 수가 너무 적을 경우 
                                error('All pointsr in area (%d) are not enough for generate popup (%d) point\n', length(allpointsinarea),objlist(i_obj_big+1) )
                                % temp_pointinarea = polygrid(temp(:,1), temp(:,2), pointperarea*10);
                                % popup_pt = temp_pointinarea(randsample(1:length(temp_pointinarea), objlist(2) ), :);
                            else
                                popup_pt = allpointsinarea(randsample(1:length(allpointsinarea), objlist(i_obj_big+1) ), :);
                            end

                            for i_popup = 1:objlist(i_obj_big+1)
                                BigObjTable{i_obj_big+1}(i_popup,:).Location_Point_X = {popup_pt(i_popup,1)};
                                BigObjTable{i_obj_big+1}(i_popup,:).Location_Point_Y = {popup_pt(i_popup,2)};
                            end
                        end
                        
                    end





                case 7
                    fprintf('--------------Objective Edit Finised--------------\n\n\n')
                    fprintf('7. Edit Wind Speed \n')
                    fprintf('Current %d-%d Objective wind speed is %d : \n',i_obj_big,current_id_obj,BigObjTable{i_obj_big}(current_id_obj,:).WindSpeed)
                    BigObjTable{i_obj_big}(current_id_obj,:).WindSpeed = input('Wind Speed [0~10]: ');
                case 8
                    fprintf('--------------Objective Edit Finised--------------\n\n\n')
                    fprintf('8. Edit Wind direction \n')
                    fprintf('Current %d Objective wind speed is %d : \n',i_obj_big,current_id_obj,BigObjTable{i_obj_big}(current_id_obj,:).WindSpeed)
                    BigObjTable{i_obj_big}(current_id_obj,:).WindDirectionDegree = input('Wind direction [0~360deg] : ');
                    
                case 9
                    fprintf('--------------Objective Edit Finised--------------\n\n\n')
                otherwise
                    fprintf('\n Please Select valid propety to edit \n')

            end
            % Select Continue current Obj Edit or (Exit -> To Select Obj mode)
            fprintf('PLEASE SELECT \n1. Continue current Obj Edit \n2. Finish current Obj Edit and Select other Obj Edit\n')
            smallObjEditMode = round(input("Select [1 or 2] : "));
            % for input mistake
            while ~(isempty(smallObjEditMode) || (smallObjEditMode > 0) || (smallObjEditMode < 3))
                fprintf('You Put a Wrong Number. \n1. Continue current Obj Edit \n2. Finish current Obj Edit and Select other Obj Edit\n')
                smallObjEditMode = round(input("Select [1 or 2] : "));
            end

            % User choose to edit other objectives
            if smallObjEditMode == 2
                break
            end

        end
end

% ADD Wind speed and direction for pollution mission 
if mission_type==6
    for obj_idx1 = 1:height(BigObjTable{3})
        BigObjTable{3}(obj_idx1,:).WindSpeed=randi([0,10]);
        BigObjTable{3}(obj_idx1,:).WindDirectionDegree=randi([0,360]);
    end
    for obj_idx1 = 1:height(BigObjTable{4})
        BigObjTable{4}(obj_idx1,:).WindSpeed=randi([0,10]);
        BigObjTable{4}(obj_idx1,:).WindDirectionDegree=randi([0,360]);
    end
end

% FOR DEBUGGING
save('BigObjTable.mat', 'BigObjTable', 'objlist', 'total_num_obj','obj_step','current_Obj_plot_PT','current_Obj_plot_PTDot')



%% Task generation (복합 임무 별로 만들어놓은 목록에서 task들 가져오기, 기술2의 할당과 다름)

% 복합 임무별로 task 목록 만들어놔야함

% --> 에이전트에 부여 가능한 수준의 task 목록들
% 이동 [단일 좌표] : point to point/area
% 운송(화물 탑재한채로 이동 후 살포) [[단일 좌표] -> [단일 좌표]] : point to point/area
% 추적(이동감시) [단일 좌표] - 지정된 이동 목표를 이동하면서 추적 : point, point to point
% 구역감시 [복수 좌표] - 지정된 고정 목표를 패턴으로 비행 : area
% 정찰 [면적] - 불확실 지역 point to point 비행 : point to point
% 맵핑 [면적] - 패턴비행 + 지도작성 - 완료 트리거는 커버 범위 % : area
% 포획/탑재(화물 태우기)[단일 좌표] : point to point
% 재보급[단일 좌표](Refuel) - 유지보수 작업 총칭 : to point(refuel point)
% 에이전트간 상호작용(지원)(Support) (재급유 등)[단일 좌표] - 지원 에이전트용 task, 상대는 재보급 task?
% 식별/확인(Signal) - 감시/정찰 등의 작업 종료 신호, 임무 순서 트리거로 사용 : Signal[T/F]
% 중계(bridge) - 통신망 구축 복합임무 전용 task : [area]
% 경고 신호 발생(Warning) - 임무 순서 트리거로 사용 : Signal[T/F]

% clc
% fprintf('\n\n\n----------------------Task gen start------------------------------\n\n\n')
% tasklist = NaN;
% Obj_Task = {};
% AgentTask ={};
% 
% fprintf('\n Task Generation Started \n')
% 
% switch mission_type
%     case 1
%         fprintf('1. 해양사고 조난자 수색 및 구조 (Selected)\n')
% 
% %         ObjTable{1} % monitoring area information
% %         ObjTable{2} % rescue spot information
% 
%         for idx_agent = 1:num_agent
%             % Obj 1 : 해양사고 조난자 의심지역 수색하기
%             % Task 1-1 : [이동] 의심구역 이동 [단일 좌표]
%             % Task 1-2 : [구역감시] 구역감시 -> 1-4 task 발생 시 Obj 2로 넘어감 [구역좌표/polygon/circle]
%             % Task 1-3 : [재보급] 기지에서 재보급 [단일 좌표]
%             % Task 1-4 : [식별/확인] 식별/확인 -> Obj2 Task로 상황 전체 전환용 flag [bool]
%             AgentTask{idx_agent}.task11_what     = '의심구역 이동 [lat lon]';
%             AgentTask{idx_agent}.task11_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Camera or Sensor attached Agent인가?
%             AgentTask{idx_agent}.task11_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task11_avail    = AgentTask{idx_agent}.task11_Gear_avail & AgentTask{idx_agent}.task11_Env_avail;
%             AgentTask{idx_agent}.task11_type     = 'move';
%             AgentTask{idx_agent}.task11_value    = {1}; % Obj 1
% %                 AgentTask{idx_agent}.task11_value    = cell2mat([BigObjTable{1}.Location_Point_X BigObjTable{1}.Location_Point_Y]); % 현재 사용자 지정 면적 내부 grid point
% 
% 
%             AgentTask{idx_agent}.task12_what     = '구역감시  [area]--> 나중에 Area 형태로 input할것(작업예정)';
%             AgentTask{idx_agent}.task12_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task12_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea))*3 | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task12_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task12_type     = 'Surveilance';
%             AgentTask{idx_agent}.task12_value    = {1}; % Obj 1
% %                 AgentTask{idx_agent}.task12_value    = cell2mat([BigObjTable{1}.Location_Point_X BigObjTable{1}.Location_Point_Y]); % 현재 사용자 지정 면적 내부 grid point
% 
% 
%             AgentTask{idx_agent}.task13_what     = '재보급 [base_lat base_lon]';
%             AgentTask{idx_agent}.task13_Gear_avail = true; % 재보급이 안되면 그게 agent인가?
%             AgentTask{idx_agent}.task13_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task13_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task13_type     = 'Refuel';
%             AgentTask{idx_agent}.task13_value    = {BaseTable.id_base'};
% %                 AgentTask{idx_agent}.task13_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task14_what     = '구역감시 중 조난자 식별/확인 성공 flag -> Obj2 Task로 상황 전체 전환  [T/F]';
%             AgentTask{idx_agent}.task14_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가? -> % 감시 가능한 agent가 선언 가능
%             AgentTask{idx_agent}.task14_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task14_avail    = AgentTask{idx_agent}.task14_Gear_avail & AgentTask{idx_agent}.task14_Env_avail ;
%             AgentTask{idx_agent}.task14_type     = 'Identify/Check flag';
%             AgentTask{idx_agent}.task14_value    = [~logical(BigObjTable{1}.id_obj)]; % 초기값 false
% 
% 
%             % Obj 2 : 해양사고 조난자 의심지역 수색하기 (의도 : 2-1 / 2-2 각 task에 대해 서로 다른 agent가 task를 수행 -> 임무 분담용 (point 감시 + Area 감시) )
%             % Task 2-1 : [추적(이동감시)] [좌표] [시뮬레이터 갱신 필요]
%             % Task 2-2 : [구역감시] 구역감시 [구역좌표/polygon/circle]
%             % Task 2-3 : [식별/확인] 경고 신호 발생 -> Obj 3 Task로 전환
%             % Task 2-4 : [재보급] 기지 재보급
%             AgentTask{idx_agent}.task21_type     = 'Follow';
%             AgentTask{idx_agent}.task21_what     = '추적(이동감시) [lat lon]';
%             AgentTask{idx_agent}.task21_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Camera or Sensor attached Agent인가?
%             AgentTask{idx_agent}.task21_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task21_avail    = AgentTask{idx_agent}.task21_Gear_avail & AgentTask{idx_agent}.task21_Env_avail;
%             AgentTask{idx_agent}.task21_value    = {2}; % Obj 2
% %                 AgentTask{idx_agent}.task21_value    = [BigObjTable{2}.Location_Poly_X BigObjTable{2}.Location_Poly_Y]; % 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task22_what     = '구역감시  [area]--> 나중에 Area 형태로 input할것(작업예정)';
%             AgentTask{idx_agent}.task22_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task22_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task22_avail    = AgentTask{idx_agent}.task22_Gear_avail & AgentTask{idx_agent}.task22_Env_avail;
%             AgentTask{idx_agent}.task22_type     = 'Surveilance';
%             AgentTask{idx_agent}.task22_value    = {1}; % Obj 1
% %                 AgentTask{idx_agent}.task22_value    = [BigObjTable{2}.Location_Poly_X BigObjTable{2}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함,
% 
%             AgentTask{idx_agent}.task23_what     = '재보급 [base_lat base_lon]';
%             AgentTask{idx_agent}.task23_Gear_avail = true; % 재보급이 안되면 그게 agent인가?
%             AgentTask{idx_agent}.task23_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task23_avail    = AgentTask{idx_agent}.task23_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task23_type     = 'Refuel';
%             AgentTask{idx_agent}.task23_value    =  {BaseTable.id_base'};
%             %[BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task24_what     = '구역감시 중 조난자 식별/확인 성공 flag -> Obj2 Task로 상황 전체 전환  [T/F]';
%             AgentTask{idx_agent}.task24_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가? -> % 감시 가능한 agent가 선언 가능
%             AgentTask{idx_agent}.task24_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task24_avail    = AgentTask{idx_agent}.task24_Gear_avail & AgentTask{idx_agent}.task24_Env_avail ;
%             AgentTask{idx_agent}.task24_type     = 'Identify/Check flag';
%             AgentTask{idx_agent}.task24_value    = [~logical(BigObjTable{2}.id_obj)]; % 초기값 false
% 
% 
%             % Obj 3 : 조난자 구조
%             % Task 3-1 : [추적(이동감시)] [좌표] [시뮬레이터 갱신 필요] 
%             % (2->3->4는 추적하는 agent와 별개의 agent가 진행)
%             % Task 3-2 : [이동] 
%             % Task 3-3 : [포획/탑재]
%             % Task 3-4 : [운송]
%             % Task 3-5 : [재보급]
% 
%             AgentTask{idx_agent}.task31_type     = 'Follow';
%             AgentTask{idx_agent}.task31_what     = '추적(이동감시) [lat lon]';
%             AgentTask{idx_agent}.task31_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Camera or Sensor attached Agent인가?
%             AgentTask{idx_agent}.task31_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task31_avail    = AgentTask{idx_agent}.task31_Gear_avail & AgentTask{idx_agent}.task31_Env_avail;
%             AgentTask{idx_agent}.task31_value    = {2}; % Obj 1
% %                 AgentTask{idx_agent}.task31_value    = [BigObjTable{2}.Location_Poly_X BigObjTable{2}.Location_Poly_Y]; % 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task32_type     = 'Surveilance';
%             AgentTask{idx_agent}.task32_what     = '구역감시  [area] --> 나중에 Area 형태로 input할것(작업예정)';
%             AgentTask{idx_agent}.task32_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task32_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task32_avail    = AgentTask{idx_agent}.task32_Gear_avail & AgentTask{idx_agent}.task32_Env_avail;
%             AgentTask{idx_agent}.task32_value    = {1}; % Obj 1
% %                 AgentTask{idx_agent}.task32_value    = cell2mat([BigObjTable{2}.Location_Poly_X BigObjTable{2}.Location_Poly_Y]); % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task33_type     = 'catch';
%             AgentTask{idx_agent}.task33_what     = '대상 지역의 조난자 포획 및 탑재 [lat lon]';
%             AgentTask{idx_agent}.task33_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가?
%             AgentTask{idx_agent}.task33_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea) ) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task33_avail    = AgentTask{idx_agent}.task33_Gear_avail & AgentTask{idx_agent}.task33_Env_avail;
%             AgentTask{idx_agent}.task33_value    = {2}; % Obj 1
% %                 AgentTask{idx_agent}.task33_value    = [BigObjTable{2}.Location_Poly_X BigObjTable{2}.Location_Poly_Y]; % 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task34_type     = 'transport';
%             AgentTask{idx_agent}.task34_what     = '수송 [lat lon]';
%             AgentTask{idx_agent}.task34_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가?
%             AgentTask{idx_agent}.task34_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{3}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{3}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task34_avail    = AgentTask{idx_agent}.task34_Gear_avail & AgentTask{idx_agent}.task34_Env_avail;
%             AgentTask{idx_agent}.task34_value    = {3}; % Obj 3
% %                 AgentTask{idx_agent}.task34_value    = [BigObjTable{3}.Location_Poly_X BigObjTable{3}.Location_Poly_Y]; % 사용자가 입력한 rescue point로 향해야 함
% 
%             AgentTask{idx_agent}.task35_type     = 'Refuel';                        
%             AgentTask{idx_agent}.task35_what     = '재보급 [base_lat base_lon]';
%             AgentTask{idx_agent}.task35_Gear_avail = true; % 재보급이 안되면 그게 agent인가?
%             AgentTask{idx_agent}.task35_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task35_avail    = AgentTask{idx_agent}.task35_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task35_value    =  {BaseTable.id_base'};
%             %[BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task36_type     = 'Identify/Check flag';            
%             AgentTask{idx_agent}.task36_what     = '조난자 최종 지점(병원/상륙지점)으로 이송 완료 선언 [T/F]';
%             AgentTask{idx_agent}.task36_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가? -> % 운송 가능한 agent가 선언 가능
%             AgentTask{idx_agent}.task36_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{3}.Obj_Sea))*3 | (AgentTable.Agent_Type(idx_agent) == BigObjTable{3}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task36_avail    = AgentTask{idx_agent}.task36_Gear_avail & AgentTask{idx_agent}.task36_Env_avail & AgentTask{idx_agent}.task35_avail; 
%             AgentTask{idx_agent}.task36_value    = [~logical(BigObjTable{1}.id_obj)]; % 초기값 false
% 
% 
%             % Type ? (UAV=1, UGV=2, USV=3)
% %             AgentTable.Agent_Type
% %             ismember(double(ObjTable{1}.Obj_Sea)*2, AgentTable.Agent_Type, 'rows')
% %             ObjTable{1}.Obj_Air
% %             ObjTable{1}.Obj_Land*2
% %             ObjTable{1}.Obj_Sea*3
%             fprintf('Task Generated for Agent [%d] \n', idx_agent)
%             disp(AgentTask{idx_agent})
% 
% 
%         end
% 
% 
% 
% 
% 
%     case 2
%         fprintf('2. 불법 조업 및 영해 침범 감시 (Selected)\n')
% 
%         %         ObjTable{1} % monitoring area information
%         %         ObjTable{2} % safe spot information
% %             AgentTask{idx_agent}.task00_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly)
% %             AgentTask{idx_agent}.task00_value    = [BigObjTable{1}.Location_Point_X BigObjTable{1}.Location_Point_Y]; % 현재 사용자 지정 면적 내의 grid point(Point)
% 
%         for idx_agent = 1:num_agent
%             % Obj 1 : 불법 조업 및 영해 침범 감시(평상시)
%             % Task 1-1 : [이동]       불법 조업 의심구역 이동                       [단일 좌표]
%             % Task 1-2 : [구역감시]   구역감시 -> 1-4 task 발생 시 Obj 2로 넘어감   [구역좌표/polygon/circle]
%             % Task 1-3 : [재보급]     기지/특정 재보급 agent에서 재보급             [단일 좌표]
%             % Task 1-4 : [지원]       에이전트간 상호작용(지원) - 통신 지원 시 사용할 것으로 넣어둠 [단일 좌표]
%             % Task 1-5 : [식별/확인]  식별/확인 -> Obj2 Task로 상황 전체 전환용 flag [bool]
% 
%             AgentTask{idx_agent}.task11_type     = 'move';
%             AgentTask{idx_agent}.task11_what     = '불법조업 의심구역 이동 [lat lon]';
%             AgentTask{idx_agent}.task11_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) || AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Camera or Sensor attached Agent인가?
%             AgentTask{idx_agent}.task11_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task11_avail    = AgentTask{idx_agent}.task11_Gear_avail & AgentTask{idx_agent}.task11_Env_avail;
%             AgentTask{idx_agent}.task11_value    = [BigObjTable{1}.Location_Point_X BigObjTable{1}.Location_Point_Y]; % 현재 사용자 지정 면적 내의 grid point(Point)
% 
%             AgentTask{idx_agent}.task12_type     = 'Surveilance';
%             AgentTask{idx_agent}.task12_what     = '불법조업 의심 구역감시  [area]--> 나중에 Area 형태로 input할것(작업예정)';
%             AgentTask{idx_agent}.task12_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task12_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea))*3 | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task12_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task12_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly)
% 
%             AgentTask{idx_agent}.task13_type     = 'Refuel';
%             AgentTask{idx_agent}.task13_what     = '재보급 [base_lat base_lon] 기지/특정 재보급 agent에서 재보급';
%             AgentTask{idx_agent}.task13_Gear_avail = true; % 재보급이 안되는 경우는 어떤 agent인가? (기지/재보급agent 여부 나중에 고려해보아야 함 -> refuel gear을 갖춘 경우?)
%             AgentTask{idx_agent}.task13_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task13_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task13_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task14_type     = 'Support';
%             AgentTask{idx_agent}.task14_what     = '에이전트간 상호작용(지원)[lat lon](단일좌표) - 지원 agent가 사용할 것으로 넣어둠(피보급 agent는 재보급 task, 보급 agent는 support task 수행, 통신, 자원보급 모두 포함하겠음)';
%             AgentTask{idx_agent}.task14_Gear_avail = (AgentTable.Agent_Gear1(idx_agent)); % Support 형태에 따라서 gear requirement 달라질 것임[임시]
%             AgentTask{idx_agent}.task14_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task14_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task14_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task15_type     = 'Identify/Check flag';
%             AgentTask{idx_agent}.task15_what     = '구역감시 중 불법행위/영해 침범 식별/확인 성공 flag -> Obj2 Task로 상황 전체 전환  [T/F]';
%             AgentTask{idx_agent}.task15_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가? -> % 감시 가능한 agent가 선언 가능
%             AgentTask{idx_agent}.task15_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task15_avail    = AgentTask{idx_agent}.task13_Gear_avail & AgentTask{idx_agent}.task13_Env_avail ;
%             AgentTask{idx_agent}.task15_value    = [~logical(BigObjTable{1}.id_obj)]; % 초기값 false
% 
%             % Obj 2 : 표적 추적, 경고 조치 및 대응            
%             %  Task 2-1 : [구역감시] 	사건 발생시 발생지역 주변 구역 감시 – 지원용)	[구역좌표] 
%             %  Task 2-2 : [추적] 	사건 관련자 추적 감시                [단일좌표]
%             %  Task 2-3 : [맵핑] 	도주&이동경로 확보를 위한 3D 맵핑) 	[구역좌표]
%             %  Task 2-4 : [경고신호] 	경고 신호 발생 -> Obj 3 Task로 전환	[]
%             %  Task 2-5 : [에이전트간 상호작용] 지원 agent가 사용      [단일좌표]
%             %  Task 2-6 : [재보급] 	재보급 필요 agent가 사용        [단일좌표]
% 
%             AgentTask{idx_agent}.task21_type     = 'Surveilance';
%             AgentTask{idx_agent}.task21_what     = '불법조업 의심 구역감시  [area]--> 나중에 Area 형태로 input할것(작업예정)';
%             AgentTask{idx_agent}.task21_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task21_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea))*3 | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task21_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task21_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly)
% 
%             AgentTask{idx_agent}.task22_type     = 'Follow';
%             AgentTask{idx_agent}.task22_what     = '추적(이동감시) [lat lon]';
%             AgentTask{idx_agent}.task22_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Camera or Sensor attached Agent인가?
%             AgentTask{idx_agent}.task22_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task22_avail    = AgentTask{idx_agent}.task11_Gear_avail & AgentTask{idx_agent}.task11_Env_avail;
%             AgentTask{idx_agent}.task11_value    = [BigObjTable{1}.Location_Point_X BigObjTable{1}.Location_Point_Y]; % 현재 사용자 지정 면적 내의 grid point(Point), 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task23_type     = 'Mapping';            
%             AgentTask{idx_agent}.task23_what     = '맵핑  [area] - vertex ';
%             AgentTask{idx_agent}.task23_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task23_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task23_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task23_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task24_type     = 'WarningSignal';
%             AgentTask{idx_agent}.task24_what     = '경고 신호 발생 -> Obj 3 Task로 전환 [T/F]';
%             AgentTask{idx_agent}.task24_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가? -> % 감시 가능한 agent가 선언 가능
%             AgentTask{idx_agent}.task24_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task24_avail    = AgentTask{idx_agent}.task13_Gear_avail & AgentTask{idx_agent}.task13_Env_avail ;
%             AgentTask{idx_agent}.task24_value    = [~logical(BigObjTable{1}.id_obj)]; % 초기값 false
% 
%             AgentTask{idx_agent}.task25_type     = 'Support';
%             AgentTask{idx_agent}.task25_what     = '에이전트간 상호작용(지원)[lat lon](단일좌표) - 지원 agent가 사용할 것으로 넣어둠(피보급 agent는 재보급 task, 보급 agent는 support task 수행, 통신, 자원보급 모두 포함하겠음)';
%             AgentTask{idx_agent}.task25_Gear_avail = (AgentTable.Agent_Gear1(idx_agent)); % Support 형태에 따라서 gear requirement 달라질 것임[임시]
%             AgentTask{idx_agent}.task25_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task25_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task25_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task26_type     = 'Refuel';
%             AgentTask{idx_agent}.task26_what     = '재보급 [base_lat base_lon] 기지/특정 재보급 agent에서 재보급';
%             AgentTask{idx_agent}.task26_Gear_avail = true; % 재보급이 안되는 경우는 어떤 agent인가? (기지/재보급agent 여부 나중에 고려해보아야 함 -> refuel gear을 갖춘 경우?)
%             AgentTask{idx_agent}.task26_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task26_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task26_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
% 
%             % Obj 3 
%             % Task 3-1 : [추적] 	관련자 추적 	[단일좌표]
%             % Task 3-2 : [이동]	관련자 포획을 위한 이동	[단일좌표]
%             % Task 3-3 : [포획/탑재]	관련자 포획 	[단일좌표]
%             % Task 3-4 : [운송]	관련자 안전구역으로 이송[단일좌표]
%             % Task 1-2 : [구역감시] 	사건 발생 지역 감시	[구역좌표]
%             % Task 3-5 : [재보급]	재보급 필요 agent가 선언 [단일좌표]
% 
%             AgentTask{idx_agent}.task31_type     = 'Follow';
%             AgentTask{idx_agent}.task31_what     = '관련자 추적(이동감시) [lat lon]';
%             AgentTask{idx_agent}.task31_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Camera or Sensor attached Agent인가?
%             AgentTask{idx_agent}.task31_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task31_avail    = AgentTask{idx_agent}.task11_Gear_avail & AgentTask{idx_agent}.task11_Env_avail;
%             AgentTask{idx_agent}.task31_value    = [BigObjTable{2}.Location_Poly_X BigObjTable{2}.Location_Poly_Y]; % 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task32_type     = 'Surveilance';
%             AgentTask{idx_agent}.task32_what     = '구역감시  [area] --> 나중에 Area 형태로 input할것(작업예정)';
%             AgentTask{idx_agent}.task32_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task32_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task32_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task32_value    = [BigObjTable{2}.Location_Poly_X BigObjTable{2}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task33_type     = 'Catch';
%             AgentTask{idx_agent}.task33_what     = '대상 지역의 관련자 포획 및 탑재 [lat lon]';
%             AgentTask{idx_agent}.task33_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가?
%             AgentTask{idx_agent}.task33_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea) ) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task33_avail    = AgentTask{idx_agent}.task11_Gear_avail & AgentTask{idx_agent}.task11_Env_avail;
%             AgentTask{idx_agent}.task33_value    = [BigObjTable{2}.Location_Poly_X BigObjTable{2}.Location_Poly_Y]; % 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task34_type     = 'transport';
%             AgentTask{idx_agent}.task34_what     = '관련자 수송 [lat lon]';
%             AgentTask{idx_agent}.task34_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가?
%             AgentTask{idx_agent}.task34_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{3}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{3}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task34_avail    = AgentTask{idx_agent}.task35_Gear_avail & AgentTask{idx_agent}.task35_Env_avail & AgentTask{idx_agent}.task34_avail;
%             AgentTask{idx_agent}.task34_value    = [BigObjTable{3}.Location_Poly_X BigObjTable{3}.Location_Poly_Y]; % 사용자가 입력한 rescue point로 향해야 함
% 
%             AgentTask{idx_agent}.task35_type     = 'Refuel';                        
%             AgentTask{idx_agent}.task35_what     = '재보급 [base_lat base_lon]';
%             AgentTask{idx_agent}.task35_Gear_avail = true; % 재보급이 안되면 그게 agent인가?
%             AgentTask{idx_agent}.task35_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task35_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task35_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task36_type     = 'Identify/Check flag';            
%             AgentTask{idx_agent}.task36_what     = '관련자 최종 지점(병원/상륙지점)으로 이송 완료 선언 [T/F]';
%             AgentTask{idx_agent}.task36_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가? -> % 운송 가능한 agent가 선언 가능
%             AgentTask{idx_agent}.task36_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{3}.Obj_Sea))*3 | (AgentTable.Agent_Type(idx_agent) == BigObjTable{3}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task36_avail    = AgentTask{idx_agent}.task36_Gear_avail & AgentTask{idx_agent}.task36_Env_avail & AgentTask{idx_agent}.task35_avail; 
%             AgentTask{idx_agent}.task36_value    = [~logical(BigObjTable{1}.id_obj)]; % 초기값 false
% 
% 
% 
%         end
% 
%     case 3
%         fprintf('3. 환경오염 모니터링 및 추적 (Selected)\n')
% 
%         for idx_agent = 1:num_agent
%             % Obj 1 환경오염 물질 감시
%             % Task 1-1 : [이동]         감시 범위로 이동	[단일좌표]
%             % Task 1-2 : [구역감시] 	환경오염 물질 감시	[구역좌표]
%             % Task 1-3 : [구역감시] 	기상관측 정보 수집	[구역좌표]
%             % Task 1-4 : [식별/확인]  오염물질 관측 시-> Obj2 Task로 상황 전체 전환
%             % Task 1-5 : [에이전트간 상호작용] 지원 agent가 사용	[단일좌표]
%             % Task 1-6 : [재보급]	재보급 필요 agent가 선언 	[단일좌표]
%             AgentTask{idx_agent}.task11_type     = 'move';
%             AgentTask{idx_agent}.task11_what     = '환경오염 감시 범위 이동 [lat lon]';
%             AgentTask{idx_agent}.task11_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Camera or Sensor attached Agent인가?
%             AgentTask{idx_agent}.task11_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task11_avail    = AgentTask{idx_agent}.task11_Gear_avail & AgentTask{idx_agent}.task11_Env_avail;
%             AgentTask{idx_agent}.task11_value    = [BigObjTable{1}.Location_Point_X BigObjTable{1}.Location_Point_Y]; % 현재 사용자 지정 면적 내의 grid point(Point)
% 
%             AgentTask{idx_agent}.task12_type     = 'Surveilance';
%             AgentTask{idx_agent}.task12_what     = '불법조업 의심 구역감시  [area]--> 나중에 Area 형태로 input할것(작업예정)';
%             AgentTask{idx_agent}.task12_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task12_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea))*3 | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task12_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task12_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly)
% 
%             AgentTask{idx_agent}.task13_type     = 'Surveilance';
%             AgentTask{idx_agent}.task13_what     = '불법조업 의심 구역감시  [area]--> 나중에 Area 형태로 input할것(작업예정)';
%             AgentTask{idx_agent}.task13_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task13_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea))*3 | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task13_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task13_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly)
% 
%             AgentTask{idx_agent}.task14_type     = 'Identify/Check flag';
%             AgentTask{idx_agent}.task14_what     = '구역감시 중 불법행위/영해 침범 식별/확인 성공 flag -> Obj2 Task로 상황 전체 전환  [T/F]';
%             AgentTask{idx_agent}.task14_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가? -> % 감시 가능한 agent가 선언 가능
%             AgentTask{idx_agent}.task14_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task14_avail    = AgentTask{idx_agent}.task13_Gear_avail & AgentTask{idx_agent}.task13_Env_avail ;
%             AgentTask{idx_agent}.task14_value    = [~logical(BigObjTable{1}.id_obj)]; % 초기값 false
% 
%             AgentTask{idx_agent}.task15_type     = 'Support';
%             AgentTask{idx_agent}.task15_what     = '에이전트간 상호작용(지원)[lat lon](단일좌표) - 지원 agent가 사용할 것으로 넣어둠(피보급 agent는 재보급 task, 보급 agent는 support task 수행, 통신, 자원보급 모두 포함하겠음)';
%             AgentTask{idx_agent}.task15_Gear_avail = (AgentTable.Agent_Gear1(idx_agent)); % Support 형태에 따라서 gear requirement 달라질 것임[임시]
%             AgentTask{idx_agent}.task15_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task15_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task15_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task16_type     = 'Refuel';
%             AgentTask{idx_agent}.task16_what     = '재보급 [base_lat base_lon] 기지/특정 재보급 agent에서 재보급';
%             AgentTask{idx_agent}.task16_Gear_avail = true; % 재보급이 안되는 경우는 어떤 agent인가? (기지/재보급agent 여부 나중에 고려해보아야 함 -> refuel gear을 갖춘 경우?)
%             AgentTask{idx_agent}.task16_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task16_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task16_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             % Obj 2 환경오염 동적 매핑 및 오염원 추정
%             % Task 2-1 : [구역감시]	환경오염원 확인	[구역좌표]
%             % Task 2-2 : [식별/확인]	환경오염원 파악	[]
%             % Task 2-3 : [추적]		환경오염원 추적	[단일좌표]
%             % Task 2-4 : [맵핑]		환경오염물질 지도 생성	[구역좌표]
%             % Task 2-5 : [에이전트간 상호작용] 지원 agent가 사용	[단일좌표]
%             % Task 2-6 : [재보급] 	재보급 필요 agent가 선언 	[단일좌표]	
% 
%             AgentTask{idx_agent}.task21_type     = 'Surveilance';
%             AgentTask{idx_agent}.task21_what     = '구역감시  [area] --> 나중에 Area 형태로 input할것(작업예정)';
%             AgentTask{idx_agent}.task21_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task21_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task21_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task21_value    = [BigObjTable{2}.Location_Poly_X BigObjTable{2}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task22_type     = 'Identify/Check flag';            
%             AgentTask{idx_agent}.task22_what     = '관련자 최종 지점(병원/상륙지점)으로 이송 완료 선언 [T/F]';
%             AgentTask{idx_agent}.task22_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가? -> % 운송 가능한 agent가 선언 가능
%             AgentTask{idx_agent}.task22_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{3}.Obj_Sea))*3 | (AgentTable.Agent_Type(idx_agent) == BigObjTable{3}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task22_avail    = AgentTask{idx_agent}.task36_Gear_avail & AgentTask{idx_agent}.task36_Env_avail & AgentTask{idx_agent}.task35_avail; 
%             AgentTask{idx_agent}.task22_value    = [~logical(BigObjTable{1}.id_obj)]; % 초기값 false
% 
%             AgentTask{idx_agent}.task23_type     = 'Follow';
%             AgentTask{idx_agent}.task23_what     = '관련자 추적(이동감시) [lat lon]';
%             AgentTask{idx_agent}.task23_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Camera or Sensor attached Agent인가?
%             AgentTask{idx_agent}.task23_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task23_avail    = AgentTask{idx_agent}.task11_Gear_avail & AgentTask{idx_agent}.task11_Env_avail;
%             AgentTask{idx_agent}.task23_value    = [BigObjTable{2}.Location_Poly_X BigObjTable{2}.Location_Poly_Y]; % 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task24_type     = 'Mapping';            
%             AgentTask{idx_agent}.task24_what     = '맵핑  [area] - vertex ';
%             AgentTask{idx_agent}.task24_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task24_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task24_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task24_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task25_type     = 'Support';
%             AgentTask{idx_agent}.task25_what     = '에이전트간 상호작용(지원)[lat lon](단일좌표) - 지원 agent가 사용할 것으로 넣어둠(피보급 agent는 재보급 task, 보급 agent는 support task 수행, 통신, 자원보급 모두 포함하겠음)';
%             AgentTask{idx_agent}.task25_Gear_avail = (AgentTable.Agent_Gear1(idx_agent)); % Support 형태에 따라서 gear requirement 달라질 것임[임시]
%             AgentTask{idx_agent}.task25_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task25_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task25_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task26_type     = 'Refuel';                        
%             AgentTask{idx_agent}.task26_what     = '재보급 [base_lat base_lon]';
%             AgentTask{idx_agent}.task26_Gear_avail = true; % 재보급이 안되면 그게 agent인가?
%             AgentTask{idx_agent}.task26_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task26_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task26_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
% 
% 
%         end
% 
%     case 4
%         fprintf('4. 긴급 무선 통신망 구축 (Selected)\n')
% 
%             % Obj 1 
%             % Task 1-1 : 이동
%             % Task 1-2 : 맵핑(지형)
%             % Task 1-3 : 맵핑(통신강도)
%             % Task 1-4 : 재보급 
%             % Task 1-4 : 식별/확인(완료signal) -> Obj2 Task로 상황 전체 전환
% 
%             AgentTask{idx_agent}.task11_type     = 'move';
%             AgentTask{idx_agent}.task11_what     = '환경오염 감시 범위 이동 [lat lon]';
%             AgentTask{idx_agent}.task11_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Camera or Sensor attached Agent인가?
%             AgentTask{idx_agent}.task11_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task11_avail    = AgentTask{idx_agent}.task11_Gear_avail & AgentTask{idx_agent}.task11_Env_avail;
%             AgentTask{idx_agent}.task11_value    = [BigObjTable{1}.Location_Point_X BigObjTable{1}.Location_Point_Y]; % 현재 사용자 지정 면적 내의 grid point(Point)
% 
%             AgentTask{idx_agent}.task12_type     = 'Mapping';            
%             AgentTask{idx_agent}.task12_what     = '맵핑  [area] - vertex ';
%             AgentTask{idx_agent}.task12_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task12_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task12_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task12_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task13_type     = 'Mapping';            
%             AgentTask{idx_agent}.task13_what     = '맵핑  [area] - vertex ';
%             AgentTask{idx_agent}.task13_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task13_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task13_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task13_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task14_type     = 'Support';
%             AgentTask{idx_agent}.task14_what     = '에이전트간 상호작용(지원)[lat lon](단일좌표) - 지원 agent가 사용할 것으로 넣어둠(피보급 agent는 재보급 task, 보급 agent는 support task 수행, 통신, 자원보급 모두 포함하겠음)';
%             AgentTask{idx_agent}.task14_Gear_avail = (AgentTable.Agent_Gear1(idx_agent)); % Support 형태에 따라서 gear requirement 달라질 것임[임시]
%             AgentTask{idx_agent}.task14_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task14_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task14_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task15_type     = 'Refuel';                        
%             AgentTask{idx_agent}.task15_what     = '재보급 [base_lat base_lon]';
%             AgentTask{idx_agent}.task15_Gear_avail = true; % 재보급이 안되면 그게 agent인가?
%             AgentTask{idx_agent}.task15_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task15_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task15_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task16_type     = 'Identify/Check flag';            
%             AgentTask{idx_agent}.task16_what     = '관련자 최종 지점(병원/상륙지점)으로 이송 완료 선언 [T/F]';
%             AgentTask{idx_agent}.task16_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가? -> % 운송 가능한 agent가 선언 가능
%             AgentTask{idx_agent}.task16_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{3}.Obj_Sea))*3 | (AgentTable.Agent_Type(idx_agent) == BigObjTable{3}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task16_avail    = AgentTask{idx_agent}.task36_Gear_avail & AgentTask{idx_agent}.task36_Env_avail & AgentTask{idx_agent}.task35_avail; 
%             AgentTask{idx_agent}.task16_value    = [~logical(BigObjTable{1}.id_obj)]; % 초기값 false
% 
%             % Obj 2 
%             % Task 2-1 : 이동
%             % Task 2-2 : 식별/확인
%             % Task 2-3 : 맵핑
%             % Task 2-4 : 경고 신호 발생 -> Obj 3 Task로 전환
%             % Task 2-5 : 에이전트간 상호작용(해양경비대 지원)
%             % Task 2-6 : 재보급
% 
%             AgentTask{idx_agent}.task21_type     = 'Surveilance';
%             AgentTask{idx_agent}.task21_what     = '구역감시  [area] --> 나중에 Area 형태로 input할것(작업예정)';
%             AgentTask{idx_agent}.task21_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task21_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task21_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task21_value    = [BigObjTable{2}.Location_Poly_X BigObjTable{2}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task22_type     = 'Identify/Check flag';            
%             AgentTask{idx_agent}.task22_what     = '관련자 최종 지점(병원/상륙지점)으로 이송 완료 선언 [T/F]';
%             AgentTask{idx_agent}.task22_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가? -> % 운송 가능한 agent가 선언 가능
%             AgentTask{idx_agent}.task22_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{3}.Obj_Sea))*3 | (AgentTable.Agent_Type(idx_agent) == BigObjTable{3}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task22_avail    = AgentTask{idx_agent}.task36_Gear_avail & AgentTask{idx_agent}.task36_Env_avail & AgentTask{idx_agent}.task35_avail; 
%             AgentTask{idx_agent}.task22_value    = [~logical(BigObjTable{1}.id_obj)]; % 초기값 false
% 
%             AgentTask{idx_agent}.task23_type     = 'Mapping';            
%             AgentTask{idx_agent}.task23_what     = '맵핑  [area] - vertex ';
%             AgentTask{idx_agent}.task23_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task23_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task23_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task23_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task24_type     = 'WarningSignal';
%             AgentTask{idx_agent}.task24_what     = '경고 신호 발생 -> Obj 3 Task로 전환 [T/F]';
%             AgentTask{idx_agent}.task24_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가? -> % 감시 가능한 agent가 선언 가능
%             AgentTask{idx_agent}.task24_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task24_avail    = AgentTask{idx_agent}.task13_Gear_avail & AgentTask{idx_agent}.task13_Env_avail ;
%             AgentTask{idx_agent}.task24_value    = [~logical(BigObjTable{1}.id_obj)]; % 초기값 false
% 
%             AgentTask{idx_agent}.task25_type     = 'Support';
%             AgentTask{idx_agent}.task25_what     = '에이전트간 상호작용(지원)[lat lon](단일좌표) - 지원 agent가 사용할 것으로 넣어둠(피보급 agent는 재보급 task, 보급 agent는 support task 수행, 통신, 자원보급 모두 포함하겠음)';
%             AgentTask{idx_agent}.task25_Gear_avail = (AgentTable.Agent_Gear1(idx_agent)); % Support 형태에 따라서 gear requirement 달라질 것임[임시]
%             AgentTask{idx_agent}.task25_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task25_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task25_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task26_type     = 'Refuel';
%             AgentTask{idx_agent}.task26_what     = '재보급 [base_lat base_lon] 기지/특정 재보급 agent에서 재보급';
%             AgentTask{idx_agent}.task26_Gear_avail = true; % 재보급이 안되는 경우는 어떤 agent인가? (기지/재보급agent 여부 나중에 고려해보아야 함 -> refuel gear을 갖춘 경우?)
%             AgentTask{idx_agent}.task26_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task26_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task26_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
% 
%             % Obj 3 
%             % Task 3-1 : 이동 
%             % Task 3-2 : 중계
%             % Task 3-3 : 재보급
% 
%             AgentTask{idx_agent}.task11_type     = 'move';
%             AgentTask{idx_agent}.task11_what     = '환경오염 감시 범위 이동 [lat lon]';
%             AgentTask{idx_agent}.task11_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Camera or Sensor attached Agent인가?
%             AgentTask{idx_agent}.task11_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task11_avail    = AgentTask{idx_agent}.task11_Gear_avail & AgentTask{idx_agent}.task11_Env_avail;
%             AgentTask{idx_agent}.task11_value    = [BigObjTable{1}.Location_Point_X BigObjTable{1}.Location_Point_Y]; % 현재 사용자 지정 면적 내의 grid point(Point)
% 
%             AgentTask{idx_agent}.task23_type     = 'Bridge';            
%             AgentTask{idx_agent}.task23_what     = '통신 중계  [area] - vertex ';
%             AgentTask{idx_agent}.task23_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task23_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task23_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task23_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
% 
%             AgentTask{idx_agent}.task25_type     = 'Support';
%             AgentTask{idx_agent}.task25_what     = '에이전트간 상호작용(지원)[lat lon](단일좌표) - 지원 agent가 사용할 것으로 넣어둠(피보급 agent는 재보급 task, 보급 agent는 support task 수행, 통신, 자원보급 모두 포함하겠음)';
%             AgentTask{idx_agent}.task25_Gear_avail = (AgentTable.Agent_Gear1(idx_agent)); % Support 형태에 따라서 gear requirement 달라질 것임[임시]
%             AgentTask{idx_agent}.task25_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task25_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task25_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task26_type     = 'Refuel';
%             AgentTask{idx_agent}.task26_what     = '재보급 [base_lat base_lon] 기지/특정 재보급 agent에서 재보급';
%             AgentTask{idx_agent}.task26_Gear_avail = true; % 재보급이 안되는 경우는 어떤 agent인가? (기지/재보급agent 여부 나중에 고려해보아야 함 -> refuel gear을 갖춘 경우?)
%             AgentTask{idx_agent}.task26_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task26_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task26_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
% 
%     case 5
%         fprintf('5. 정밀 농업 (Selected)\n')
%             % Obj 1 토양/농경지 조사
%             % Task 1-1 : [이동]		농경지로 이동		[단일좌표] : 농경지 좌표
%             % Task 1-2 : [맵핑](지형)		농경지 지형 맵핑		[복수 좌표] : 농경지 면적
%             % Task 1-3 : [맵핑](농작물)	농경지 내 기존 농작물 맵핑	[복수 좌표] : 농경지 면적
%             % Task 1-4 : [재보급]	
% 
%             AgentTask{idx_agent}.task11_type     = 'move';
%             AgentTask{idx_agent}.task11_what     = '환경오염 감시 범위 이동 [lat lon]';
%             AgentTask{idx_agent}.task11_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Camera or Sensor attached Agent인가?
%             AgentTask{idx_agent}.task11_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{1}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{1}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task11_avail    = AgentTask{idx_agent}.task11_Gear_avail & AgentTask{idx_agent}.task11_Env_avail;
%             AgentTask{idx_agent}.task11_value    = [BigObjTable{1}.Location_Point_X BigObjTable{1}.Location_Point_Y]; % 현재 사용자 지정 면적 내의 grid point(Point)
% 
%             AgentTask{idx_agent}.task12_type     = 'Mapping';            
%             AgentTask{idx_agent}.task12_what     = '맵핑  [area] - vertex ';
%             AgentTask{idx_agent}.task12_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task12_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task12_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task12_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task13_type     = 'Mapping';            
%             AgentTask{idx_agent}.task13_what     = '맵핑  [area] - vertex ';
%             AgentTask{idx_agent}.task13_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task13_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task13_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task13_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task15_type     = 'Refuel';                        
%             AgentTask{idx_agent}.task15_what     = '재보급 [base_lat base_lon]';
%             AgentTask{idx_agent}.task15_Gear_avail = true; % 재보급이 안되면 그게 agent인가?
%             AgentTask{idx_agent}.task15_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task15_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task15_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
% 
%         % Obj 2 : 작물 모니터링 및 병충해 감시
%         % Task 2-1 : [구역감시]		병충해 감시를 위한 구역 감시	[복수 좌표] : 농경지 면적
%         % Task 2-2 : [맵핑](지형)		작물 생육 상태 맵핑	 [복수 좌표] : 농경지 면적
%         % Task 2-3 : [재보급]	
%             AgentTask{idx_agent}.task21_type     = 'Surveilance';
%             AgentTask{idx_agent}.task21_what     = '구역감시  [area] --> 나중에 Area 형태로 input할것(작업예정)';
%             AgentTask{idx_agent}.task21_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task21_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task21_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task21_value    = [BigObjTable{2}.Location_Poly_X BigObjTable{2}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task22_type     = 'Mapping';            
%             AgentTask{idx_agent}.task22_what     = '맵핑  [area] - vertex ';
%             AgentTask{idx_agent}.task22_Gear_avail = (AgentTable.Agent_Gear1(idx_agent) & AgentTable.Agent_Gear2(idx_agent)); % 수상 의심구역 관측 가능한 Gear1(Camera) or Gear2(Sensor) attached Agent인가?
%             AgentTask{idx_agent}.task22_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{2}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{2}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task22_avail    = AgentTask{idx_agent}.task12_Gear_avail & AgentTask{idx_agent}.task12_Env_avail;
%             AgentTask{idx_agent}.task22_value    = [BigObjTable{1}.Location_Poly_X BigObjTable{1}.Location_Poly_Y]; % 현재 사용자 지정 면적의 꼭지점(Poly), 사용자 지정 구역 or 시뮬레이터에서 popup point 발생 시 반영해야함
% 
%             AgentTask{idx_agent}.task23_type     = 'Refuel';                        
%             AgentTask{idx_agent}.task23_what     = '재보급 [base_lat base_lon]';
%             AgentTask{idx_agent}.task23_Gear_avail = true; % 재보급이 안되면 그게 agent인가?
%             AgentTask{idx_agent}.task23_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task23_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task23_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
% 
%         % Obj 3 : 파종 및 방제
%         % Task 3-1 : [탑재](종자)		종자 탑재               [단일좌표]
%         % Task 3-2 : [운송](종자)		종자 운송 후 살포       [복수 좌표]
%         % Task 3-3 : [탑재](농약)		농약 탑재               [단일좌표]
%         % Task 3-4 : [운송](농약)		농약 운송 후 살포       [복수 좌표]
%         % Task 3-5 : [재보급]	
% 
%             AgentTask{idx_agent}.task34_type     = 'Pickup';
%             AgentTask{idx_agent}.task34_what     = '관련자 수송 [lat lon]';
%             AgentTask{idx_agent}.task34_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가?
%             AgentTask{idx_agent}.task34_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{3}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{3}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task34_avail    = AgentTask{idx_agent}.task35_Gear_avail & AgentTask{idx_agent}.task35_Env_avail & AgentTask{idx_agent}.task34_avail;
%             AgentTask{idx_agent}.task34_value    = [BigObjTable{3}.Location_Poly_X BigObjTable{3}.Location_Poly_Y]; % 사용자가 입력한 rescue point로 향해야 함
% 
%             AgentTask{idx_agent}.task34_type     = 'transport';
%             AgentTask{idx_agent}.task34_what     = '관련자 수송 [lat lon]';
%             AgentTask{idx_agent}.task34_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가?
%             AgentTask{idx_agent}.task34_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{3}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{3}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task34_avail    = AgentTask{idx_agent}.task35_Gear_avail & AgentTask{idx_agent}.task35_Env_avail & AgentTask{idx_agent}.task34_avail;
%             AgentTask{idx_agent}.task34_value    = [BigObjTable{3}.Location_Poly_X BigObjTable{3}.Location_Poly_Y]; % 사용자가 입력한 rescue point로 향해야 함
% 
%             AgentTask{idx_agent}.task34_type     = 'transport';
%             AgentTask{idx_agent}.task34_what     = '관련자 수송 [lat lon]';
%             AgentTask{idx_agent}.task34_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가?
%             AgentTask{idx_agent}.task34_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{3}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{3}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task34_avail    = AgentTask{idx_agent}.task35_Gear_avail & AgentTask{idx_agent}.task35_Env_avail & AgentTask{idx_agent}.task34_avail;
%             AgentTask{idx_agent}.task34_value    = [BigObjTable{3}.Location_Poly_X BigObjTable{3}.Location_Poly_Y]; % 사용자가 입력한 rescue point로 향해야 함
% 
%             AgentTask{idx_agent}.task34_type     = 'transport';
%             AgentTask{idx_agent}.task34_what     = '관련자 수송 [lat lon]';
%             AgentTask{idx_agent}.task34_Gear_avail = (AgentTable.Agent_Gear3(idx_agent)); % Transport 가능한 Agent인가?
%             AgentTask{idx_agent}.task34_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BigObjTable{3}.Obj_Sea)) | (AgentTable.Agent_Type(idx_agent) == BigObjTable{3}.Obj_Air); % 수상환경에 접근 가능한 종류의 Agent인가?
%             AgentTask{idx_agent}.task34_avail    = AgentTask{idx_agent}.task35_Gear_avail & AgentTask{idx_agent}.task35_Env_avail & AgentTask{idx_agent}.task34_avail;
%             AgentTask{idx_agent}.task34_value    = [BigObjTable{3}.Location_Poly_X BigObjTable{3}.Location_Poly_Y]; % 사용자가 입력한 rescue point로 향해야 함
% 
%             AgentTask{idx_agent}.task14_type     = 'Support';
%             AgentTask{idx_agent}.task14_what     = '에이전트간 상호작용(지원)[lat lon](단일좌표) - 지원 agent가 사용할 것으로 넣어둠(피보급 agent는 재보급 task, 보급 agent는 support task 수행, 통신, 자원보급 모두 포함하겠음)';
%             AgentTask{idx_agent}.task14_Gear_avail = (AgentTable.Agent_Gear1(idx_agent)); % Support 형태에 따라서 gear requirement 달라질 것임[임시]
%             AgentTask{idx_agent}.task14_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task14_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task14_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
%             AgentTask{idx_agent}.task35_type     = 'Refuel';                        
%             AgentTask{idx_agent}.task35_what     = '재보급 [base_lat base_lon]';
%             AgentTask{idx_agent}.task35_Gear_avail = true; % 재보급이 안되면 그게 agent인가?
%             AgentTask{idx_agent}.task35_Env_avail  = (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isAir_base)*1) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isLand_base)*2) | (AgentTable.Agent_Type(idx_agent) == double(BaseTable.isSea_base)*3); % 어떤 base에 접근 가능한가?
%             AgentTask{idx_agent}.task35_avail    = AgentTask{idx_agent}.task13_Env_avail; % Agent가 착륙/접안이 가능한 base에 대해 task availability 부여할것 = UAV는 공항, UGV는 지상기지, USV는 항구
%             AgentTask{idx_agent}.task35_value    = [BaseTable.Location_X BaseTable.Location_Y];
% 
% end
% %     Obj_Task{idx_obj} = {AgentTask};
% 
% fprintf('Task Generated for Each Agent \n')
% disp(AgentTask)

%%
disp(MainMissionGlobalArea) % 위치좌표(Area) : 전체 대표임무 수행 범위 (시뮬레이션 하는 전체 범위)
disp(BaseTable)
disp(AgentTable)
for tempidx=length(BigObjTable)
    disp(BigObjTable{tempidx})
end

% % Celltest
% AgentCell = table2cell(AgentTable)
% AgentCell2 = [AgentTable.Properties.VariableNames;AgentCell]
% 
% 
% % plot Empty Map Figure
% fig1 = figure;
% title('Mission Map')
% plot([],[],'-')
% axis equal;
% xlim([0 100]); ylim([0 100]);
% hold on;
% 
%  % plot Base on Figure
% plot(BaseTable.Location_X, BaseTable.Location_Y,'*')
% legend('Base')
% 
% % launch a new figure and click the mouse as many time as you want within figure
% disp('Click the mouse wherever in the figure; press ENTER when finished.');
% title('Draw Mission Area : Click the mouse wherever in the figure; press ENTER when finished.')
% mousePointCoords = ginput;
% % plot the mouse point coordinates on the figure
% mousePointCoordsdraw = [mousePointCoords; mousePointCoords(1,:)];
% plot(mousePointCoordsdraw(:,1), mousePointCoordsdraw(:,2),'.-b','MarkerSize',8);
% 
% title('Mission Map.')
% % calculate point area
% if min(size(mousePointCoords)) == 1
%     legend('Point')
% else
%     legend('Area')
%     pointperarea = 0.05;
%     pointinarea = polygrid(mousePointCoordsdraw(:,1), mousePointCoordsdraw(:,2), pointperarea);
%     plot(pointinarea(:,1),pointinarea(:,2), '*')
%     legend('Points in Area')
% end


% save('MissionGen.mat','AgentTask','AgentTable','BaseTable','BigObjTable')
save('MissionGen1.mat','AgentTable','BaseTable','BigObjTable')
fprintf('Variable Saved in MissionGen.mat')



%% CSV Export
saveas( fig1 , 'Map' )
writetable(BaseTable,'Base.csv','WriteMode','overwrite')
writetable(AgentTable,'Agent.csv','WriteMode','overwrite')

for obj_idx = 1:length(BigObjTable)
    tt = rows2vars(BigObjTable{obj_idx});
    for val_idx = 2:height(BigObjTable{obj_idx})+1
        writetable(tt(:,[1,val_idx]),['Obj_',num2str(obj_idx),'.csv'],'WriteMode','append')
    end
end

%% EXCEL EXPORT
% 빈 sheet 만들기
% writetable(table(),'empty.xls')

% 
% writetable(BaseTable,'empty.xls','Sheet','Base','WriteMode','replacefile')
% writetable(AgentTable,'empty.xls','Sheet','Agent')


% % Agent 쓰기
% for agent_idx = 1:num_agent
%     AgentTasktable_temp = rows2vars(struct2table(AgentTask{agent_idx},'AsArray',true));
%     writetable(AgentTasktable_temp,'empty.xls','Sheet',['AgentTask_',num2str(agent_idx)])
% end

% writetable(tt(:,[1,2]),['Obj_',num2str(obj_idx),'.csv'],'WriteMode','append')

% % Objective 쓰기
% for obj_idx = 1:length(BigObjTable)
%     for table_idx = 1:height(BigObjTable{obj_idx})
%         writecell(BigObjTable{1}.Properties.VariableNames, 'empty.xls','Sheet',['Obj_',num2str(obj_idx)],'WriteMode','append')
%         writematrix(BigObjTable{obj_idx}{table_idx,1:4}','empty.xls','Sheet',['Obj_',num2str(obj_idx)],'WriteMode','append')
%         writematrix(BigObjTable{obj_idx}{table_idx,5:8}{1}','empty.xls','Sheet',['Obj_',num2str(obj_idx)],'WriteMode','append')
%         writematrix(BigObjTable{obj_idx}{table_idx,5:8}{2}','empty.xls','Sheet',['Obj_',num2str(obj_idx)],'WriteMode','append')
%         if isempty(BigObjTable{obj_idx}{table_idx,5:8}{3})
%             writematrix('NaN','empty.xls','Sheet',['Obj_',num2str(obj_idx)],'WriteMode','append')
%             writematrix('NaN','empty.xls','Sheet',['Obj_',num2str(obj_idx)],'WriteMode','append')
%         else
%             writematrix(BigObjTable{obj_idx}{table_idx,5:8}{3}','empty.xls','Sheet',['Obj_',num2str(obj_idx)],'WriteMode','append')
%             writematrix(BigObjTable{obj_idx}{table_idx,5:8}{4}','empty.xls','Sheet',['Obj_',num2str(obj_idx)],'WriteMode','append')
%         end
%     end
% end

% For Debuging
% test_length = length(fieldnames(AgentTask{1}))
% getfield(AgentTask{1},testidx{3})
% class(getfield(AgentTask{agent_idx},testidx{6}))
% test1 = struct2table(AgentTask{1},'AsArray',true)
% test2 = rows2vars(struct2table(AgentTask{1},'AsArray',true))










%%
% % demo for cell, struct, table
% S={}
% S{1}.id = 1;
% S{1}.mousePointCoords = mousePointCoords
% S{1}.pointinarea = pointinarea
% 
% S{2}.id = 2;
% S{2}.mousePointCoords = mousePointCoords
% S{2}.pointinarea = pointinarea
% 
% S1Table = struct2table(S{1},'AsArray',true)
% S2Table = struct2table(S{2},'AsArray',true)
% 
% BigSTable = [S1Table; S2Table]
% BigSTable.mousePointCoords




% Legend for Loop
%  Legend=cell(N,1)
%  for iter=1:N
%    Legend{iter}=strcat('Your_Data number', num2str(iter));
%  end
%  legend(Legend)





    



%% Calculate input to output

% Generate tables based on Task calculation
% switch mission_type
%     case 1
%         fprintf('1. 해양사고 조난자 수색 및 구조 (Selected)\n')
% 
%     case 2
%         fprintf('2. 불법 조업 및 영해 침범 감시 (Selected)\n')
% 
%     case 3
%         fprintf('3. 환경오염 모니터링 및 추적 (Selected)\n')
% 
%     case 4
%         fprintf('4. 긴급 무선 통신망 구축 (Selected)\n')
% 
%     case 5
%         fprintf('5. 정밀 농업 (Selected)\n')
% 
% end




%% Output
% Generate Excel output file for each technique


% 세부기술 2, 3에 제공해야 하는 것 목록 (최대한 자세하게)
% 1. 초기 기지 위치 및 무인 에이전트 배치 상황
% 1. 초기 기지 종류(무엇을 배치할 수 있는지 여부, EX)항구 : Sea OK, Air OK, Land X)
% 2. 무인 에이전트 수, 종류, 탑재 장비(task 수행 가능여부 달라짐), 기지 배치 정보(해당 기지에서 모든 무인 에이전트가 출발)
% 3. 주/부 임무 정보(위치, 모양, 접근 가능한 에이전트 종류, 우선순위, 임무 프로파일 개념의 순서 루틴)
% 4. 이외 사용자가 입력하면 좋은 정보들 (항속거리, 탑재 연료량 etc) 
% 5. (WIP) 에이전트에 할당 가능한 Task 수준의 task 정보들 (이동, 정찰, 상호작용, 추적, 










%% 기술1(SAI)가 4세부 시뮬레이터에 주고 받을 거 목록 생각
% SAI가 Simulator Input 줄꺼 :
% 1. 주 임무/기지/Agent 배치 등의 위치정보
% 2. 임무 순서 루틴 (주 목표 1 달성시 2로 넘어가는 등의 루틴)
% 3. 각 Task들 정보 (이건 기술2,3에서 주어야 정확한가?)

% SAI가 Simulator output 받을꺼 : 
% 1. 주 목표/부 목표 달성 여부(무인기가 목표 지점 도달, 임무 완료 여부 등등 정보 모두 포함)




% prompt = 'Do you want more? Y/N [Y]: ';
% str = input(prompt,'s');
% if isempty(str)
%     str = 'Y';
% end
