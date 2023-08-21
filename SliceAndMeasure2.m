function [Body_Information] = SliceAndMeasure2(vertices, faces, SJ)
        close all

        %create body information matrix based off number of samples we
        %gather
        varTypes = ["string","string","double","double","double","double","double","double","double","double","double","double","double","double","double","double","double","double","double","double","double","double","double","double"];
        varNames = ["SubjectID", "Gender", "Height","Floor to Shoulder", "RBiceptUpper", "RBicept Lower", "ForearmUpper", "RWrist","Armpit to wrist",...
        "RThigh Upper", "RThigh Lower", "RCalf Upper", "RCalf Largest", "Ankle", "Groin to Floor", "Butt", "Hips", "Waist",...
        "RBicept Length", "RForarm Length", "RThigh Length", "Chest Circumference", "Cup Size", "Band Size"];
        
        %Body_Information = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

        %figure;
        patch("Faces", faces, "Vertices",vertices,'FaceColor',[0.85 0.85 0.85],'EdgeColor',[0.8 0.8 0.8],'FaceAlpha',.9)
        axis equal
        hold on
        axis off
        set(gcf,'color', [1 1 1]);
        lighting gouraud
        lightangle(130,85)
        rotate3d on;
%         Create sets of evenly spaced points between smpl joints. 

        %between hips and knees #joints 3 to 6
        discr = 25;
        Thigh = [(linspace(SJ(3,1), SJ(6,1), discr))' (linspace(SJ(3,2), SJ(6,2), discr))' (linspace(SJ(3,3), SJ(6,3), discr))'];
        %rotate in y, must indicate for later
%         Thigh(:,4) = 1;
        
        %between knees and ankle #joints  6 to 9
        Calf = [(linspace(SJ(6,1), SJ(9,1), discr))' (linspace(SJ(6,2), SJ(9,2)+0.05, discr))' (linspace(SJ(6,3), SJ(9,3), discr))'];
        %rotate in y, must indicate for later
%         Calf(:,4) = 1;

        Legs = [Thigh; Calf];
 
        discr = 35;
        %between center of hips to center of shoulders
        Ch = [(SJ(2,1) +SJ(3,1))/2 (SJ(2,2) +SJ(3,2))/2-0.05 (SJ(2,3) +SJ(3,3))/2];%joints 2 and 3
        Cs = [(SJ(15,1) +SJ(14,1))/2 (((SJ(15,2) + SJ(14,2))/2)+SJ(10,2))/2 (SJ(15,3) +SJ(14,3))/2]; %15 to 14
        
        

        Spine = [(linspace(Ch(1), Cs(1), discr))' (linspace(Ch(2), Cs(2), discr))' (linspace(Ch(3), Cs(3), discr))'];
       
        %add one more cut at the chest joint
        Spine = [Spine; Spine(end,:)];
        
        %slice torso
        [Measurements] = SliceSpine(vertices,faces, SJ, Spine,2)

     
%         Measurements = [CupSize-23, BandSize-24, Butt-16, Waist-18, Chest-22];
        Butt = Measurements(3); %butt
        Waist= Measurements(4); %waist

        
        CupSize = Measurements(1); %cup size
        BandSize = Measurements(2); %band size
        
        Chest = Measurements(5); %chest
 

        %% Calculating lengths of limbs using joints
        %Shoulder to Wrist, 9
        ShoulderToWrist = (norm(SJ(18,:) - SJ(22,:)))*100;
        
        %Shoulder to Elbow , 19
        ShoulderToElbow = (norm(SJ(18,:) - SJ(20,:)))*100;

        %Elbow to Wrist, 20
        ElbowToWrist = (norm(SJ(22,:) - SJ(20,:)))*100;

% 
%         %% Finding height, inseam, Thigh length, floor to shoulder 
%         Key = ["Height", "Inseam", "Thigh length", "Floor to shoulder"];
% 
        %Height - 3
        %Groin to Floor - 14 
        %Thigh Length - 20
        %Floor to shoulder - 4

        topOfHead = 415;
        Groin = 1210;
        Foot = 6869;
        Knee = 4530;
        Shoulder = 1239;

        Height = (abs(vertices(topOfHead,2) - vertices(Foot,2)))*100;

        GroinToFloor = (abs(vertices(Groin,2) - vertices(Foot,2)))*100;

        ThighLength = (abs(vertices(Groin,2) - vertices(Knee,2)))*100;
 
        FloorToShoulder = (abs(vertices(Foot,2) - vertices(Shoulder,2)))*100;


        %Slice legs
        [Measurements] = SliceLegs(vertices,faces, SJ, Legs, 2); %finds max calf circumference
        %store calf measurement - 12
        CalfLargest = Measurements(1);

        %Various other (easy to find) leg measurements
        %ankle - 13, calf upper - 11, thigh lower 10, thigh upper 9 
        Cuts = [SJ(9,1), SJ(9,2)+0.05, SJ(9,3);... %ankle
           SJ(6,1) SJ(6,2)-0.04 SJ(6,3); %Calf Upper
           SJ(6,1) SJ(6,2)+0.05 SJ(6,3); %Thigh Lower
           vertices(Groin,1) vertices(Groin,2)-0.03 vertices(Groin,3)];%groin
        
        %rotate point cloud
        R = rotx(90);
        verticesROT = vertices*R;
        CutsROT = Cuts*R;
        SJROT = SJ*R;
%         scatter3(SJROT(:,1), SJROT(:,2), SJROT(:,3),'filled')

        Measurements = [];
        for j=1:size(Cuts,1)
            [segments_vec] = miniSlice(verticesROT,faces, CutsROT(j,3));
            %sliced through both legs, remove one half of slice
            segments_vec(segments_vec(:,1) < 0,:) = [];
            sliceT = segments_vec*inv(R);
            scatter3(sliceT(:,1), sliceT(:,2), sliceT(:,3),'filled')
            Measurements(j) = EstimateCurcumference(segments_vec(:,1), segments_vec(:,2)) ;
%             Measurements(j) = segments_vec
        end
        Ankle = Measurements(1);
        CalfUpper = Measurements(2);
        ThighLower = Measurements(3);
        ThighUpper = Measurements(4);
%         

        %Slice arms
        discr = 20;
        forarm = [(linspace(SJ(22,1), SJ(20,1), discr))' (linspace(SJ(22,2), SJ(20,2), discr))' (linspace(SJ(22,3), SJ(20,3), discr))'];
        [Measurements] = SliceForearm(vertices,faces, SJ, forarm, 1);
        ForearmLargest = Measurements;
    
        Cuts = [SJ(22,1) SJ(22,2) SJ(22,3);... %wrist
            SJ(20,1)+0.05 SJ(20,2) SJ(20,3);... %lower bicept
            SJ(18,1)-0.05 SJ(18,2) SJ(18,3)]; %upper bicept

        R = roty(90);
        verticesROT = vertices*R;
        CutsROT = Cuts*R;
        SJROT = SJ*R;
        
        Measurements = [];
        for j=1:size(Cuts,1)
            [segments_vec] = miniSlice(verticesROT,faces, CutsROT(j,3));
            segments_vec(segments_vec(:,2) < 0,:) = [];
            %sliced through both legs, remove one half of slice
%             segments_vec(segments_vec(:,1) < 0,:) = []
            sliceT = segments_vec*inv(R);
            scatter3(sliceT(:,1), sliceT(:,2), sliceT(:,3),'filled')
            Measurements(j) = EstimateCurcumference(segments_vec(:,1), segments_vec(:,2));
%             Measurements(j) = segments_vec
        end
        Wrist = Measurements(1);
        BiceptLower = Measurements(2);
        temp = Measurements(3);
        BiceptUpper = Measurements(3);
%         if graphing == 1
%             disp('test')
%             %visualize
%             p1 = patch('Faces', faces, 'Vertices', vertices_unchanged)
%             set(p1,'FaceColor',[.89 .855 .788], 'FaceLighting','gouraud','EdgeColor','none','FaceAlpha',.7,'SpecularStrength',.5);
%             light('Position',[1 1 1]*1000,'Style','infinite');
%             light('Position',[-1 -1 1]*1000,'Style','infinite');
%             light('Position',[-.5 -.5 -11]*1000,'Style','infinite');
%             xlabel('x')
%             ylabel('y')
%             zlabel('z')
%             axis equal
% %             axis off
%             hold on
%             %scatter3(SJ(:,1), SJ(:,2), SJ(:,3))
% 
%             for i=1:length(slice_sets)
%                 points = slice_sets{1,i};
%                 scatter3(points(:,1), points(:,2), points(:,3))
%             end
%             
%             %also graph lengths of limbs and ect
% %             v = vertices_unchanged; 
% %              topOfHead = 415;
% %         Groin = 1210;
% %         Foot = 6869;
% %         Knee = 4530;
% %         Shoulder = 1239;
% %             
% %             %armpit to wrist
% %             plot3([SJ(18,1) SJ(22,1)],[SJ(18,2) + 0.12 SJ(18,2) + 0.12],[SJ(18,3) SJ(22,3)],'k-', 'LineWidth',1.5)
% %             scatter3(SJ(18,1), SJ(18,2) + 0.12, SJ(18,3), '>k', 'filled')
% %             scatter3(SJ(22,1), SJ(18,2) + 0.12, SJ(22,3), '<k', 'filled')
% %            
% %             
% %             %armpit to elbow
% %             plot3([SJ(18,1) SJ(20,1)],[SJ(20,2) + 0.09 SJ(20,2) + 0.09],[SJ(18,3) SJ(20,3)],'k-', 'LineWidth',1.5)
% %             scatter3(SJ(18,1), SJ(20,2) + 0.09, SJ(18,3), '>k', 'filled')
% %             scatter3(SJ(20,1), SJ(20,2) + 0.09, SJ(20,3), '<k', 'filled')
% %             
% %             %elbow to wrist
% %             plot3([SJ(22,1) SJ(20,1)],[SJ(20,2) - 0.09 SJ(20,2) - 0.09],[SJ(22,3) SJ(20,3)],'k-', 'LineWidth',1.5)
% %             scatter3(SJ(22,1), SJ(20,2) - 0.09, SJ(22,3), '<k', 'filled')
% %             scatter3(SJ(20,1), SJ(20,2) - 0.09, SJ(20,3), '>k', 'filled')
% %             
% %             %"inseam"
% %             plot3([-0.27 -0.27], [v(Groin,2) v(Foot,2)], [0 0], 'k-', 'LineWidth',1.5)
% %             scatter3(-0.27, v(Groin,2), 0, '^k', 'filled')
% %             scatter3(-0.27, v(Foot,2), 0, 'vk', 'filled')
% %            
% %             %Thigh length
% %             plot3([-0.24 -0.24], [v(Groin,2) v(Knee,2)], [0 0], 'k-', 'LineWidth',1.5)
% %             scatter3(-0.24, v(Groin,2), 0, '^k', 'filled')
% %             scatter3(-0.24, v(Knee,2), 0, 'vk', 'filled')
% % 
% %             %floor to shoulder 
% %             plot3([0.24 0.24], [v(Shoulder,2) v(Foot,2)], [0 0], 'k-', 'LineWidth',1.5)
% %             scatter3(0.24, v(Shoulder,2), 0, '^k', 'filled')
% %             scatter3(0.24, v(Foot,2), 0, 'vk', 'filled')
% %             
% %             %heigth
% %             plot3([0.27 0.27], [v(topOfHead,2) v(Foot,2)], [0 0],'k-', 'LineWidth',1.5)
% %             scatter3(0.27, v(topOfHead,2), 0, '^k', 'filled')
% %             scatter3(0.27, v(Foot,2), 0, 'vk', 'filled')
%             
%             xlabel('x')
%             ylabel('y')
% 
% 
%             x = input('Lookin good? ')       %stops code, let's you look at graph
%             close all
%         end
%     print("body Info")
%     print(Body_Information)
      Body_Information = [Ankle, BandSize, BiceptLower, BiceptUpper, Butt, CalfLargest, CalfUpper, Chest, CupSize, ElbowToWrist, FloorToShoulder, ForearmLargest, GroinToFloor, Height, ShoulderToElbow, ShoulderToWrist, ThighLength, ThighLower, ThighUpper, Waist, Wrist]; 
end
