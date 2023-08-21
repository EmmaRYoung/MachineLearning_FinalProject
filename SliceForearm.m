function [Measurements] = SliceForearm(vertices_unchanged,faces, SJ_unchanged, Cuts_unchanged, decideRot)
plane_vec = [0 0 1]';

%If statement to rotate the person and the location of the joint
%This code will only slice in z, so the person needs to be rotated
%accordingly

if decideRot == 3
    vertices = vertices_unchanged;
    Cuts1 = Cuts_unchanged;
    SJ = SJ_unchanged;
%     disp("test")
elseif decideRot == 2
    R = rotx(90);
    vertices = vertices_unchanged*R;
    Cuts1 = Cuts_unchanged*R;
    SJ = SJ_unchanged*R;
%     disp("test")
elseif decideRot == 1
    R = roty(90);
    vertices = vertices_unchanged*R;
    Cuts1 = Cuts_unchanged*R;
    SJ = SJ_unchanged*R;
%     disp("test")
end

xmax_store = [];
xmin_store = [];
ymax_store = [];
ymin_store = [];
storeCount = 1;

CutVertStore1 = [];
for i=1:size(Cuts_unchanged,1)
    Cuts = Cuts1(i,3);
    plane_point=[0,0,Cuts];

    current_vertex=vertices-plane_point;

    vert_dir=sign(current_vertex*plane_vec);
    elems_list=[];

    for count_elems=1:size(faces,1)

            nodel=faces(count_elems,:);
            if vert_dir(nodel(1)) ~= vert_dir(nodel(2)) || vert_dir(nodel(2)) ~= vert_dir(nodel(3))
                    elems_list=[elems_list;faces(count_elems,:)];

            elseif vert_dir(nodel(1)) == 0 && vert_dir(nodel(2)) == 0 && vert_dir(nodel(3)) == 0
                    elems_list=[elems_list;faces(count_elems,:)];
            end
    end

    segments_vec=[];
    
    counter=1;
    for count_elems_plane=1:size(elems_list,1)
            nodel = elems_list(count_elems_plane,:);
            temp_vertices = vertices(nodel,:);
            current_vert_dir = vert_dir(nodel);

            current_pt=[];
            if current_vert_dir(1) ~= current_vert_dir(2)
                    intersect_point_x=interp1([temp_vertices(1,3),temp_vertices(2,3)],[temp_vertices(1,1),temp_vertices(2,1)],Cuts);
                    intersect_point_y=interp1([temp_vertices(1,3),temp_vertices(2,3)],[temp_vertices(1,2),temp_vertices(2,2)],Cuts);
                    intersect_point=[intersect_point_x,intersect_point_y,Cuts];
                    current_pt=[current_pt;intersect_point];
            end
            if current_vert_dir(1) ~= current_vert_dir(3)
                    intersect_point_x=interp1([temp_vertices(1,3),temp_vertices(3,3)],[temp_vertices(1,1),temp_vertices(3,1)],Cuts);
                    intersect_point_y=interp1([temp_vertices(1,3),temp_vertices(3,3)],[temp_vertices(1,2),temp_vertices(3,2)],Cuts);
                    intersect_point=[intersect_point_x,intersect_point_y,Cuts];
                    current_pt=[current_pt;intersect_point];
            end
            if current_vert_dir(2) ~= current_vert_dir(3)
                    intersect_point_x=interp1([temp_vertices(2,3),temp_vertices(3,3)],[temp_vertices(2,1),temp_vertices(3,1)],Cuts);
                    intersect_point_y=interp1([temp_vertices(2,3),temp_vertices(3,3)],[temp_vertices(2,2),temp_vertices(3,2)],Cuts);
                    intersect_point=[intersect_point_x,intersect_point_y,Cuts];
                    current_pt=[current_pt;intersect_point];
            end
            % the following line checks to see if the plane
            % intersected and adds the points to a list of the
            % line segments present.

            if ~isempty(current_pt)
                    segments_vec=[segments_vec;current_pt];
                    counter=counter+1;
                
            end
    end
    %find maximum x coordinate of each slice
    [~,ind] = max(segments_vec(:,1));
    
    xmax_store(storeCount,1:3) = segments_vec(ind,:);
    xmax_store(storeCount,4) = ind;
    
    %side1

    %find minimum x coordinate of each slice
    [~,ind] = min(segments_vec(:,1));
    xmin_store(storeCount,1:3) = segments_vec(ind,:);
    xmin_store(storeCount,4) = ind;

    %side 2

    %find max y coordinate of each slice
    [~,ind] = max(segments_vec(:,2));
    ymax_store(storeCount,1:3) = segments_vec(ind,:);
    ymax_store(storeCount,4) = ind;  
    %front

    %find min y coordinate of each slice
    [~,ind] = min(segments_vec(:,2));
    ymin_store(storeCount,1:3) = segments_vec(ind,:);
    xmin_store(storeCount,4) = ind;    %back
    
    storeCount = storeCount + 1;

    CutVertStore1 = [CutVertStore1;segments_vec];
end

%look at zy projection
zy_CutVert = [CutVertStore1(:,2), CutVertStore1(:,3)];

%find largest slice in this projection
[~,ind] = max(ymax_store(:,2));
Cut = ymax_store(ind,3); 

[ForearmLargest] = miniSlice(vertices,faces, Cut);
vert = ForearmLargest*inv(R);
scatter3(vert(:,1), vert(:,2), vert(:,3),'filled')
ForearmLargest = EstimateCurcumference(ForearmLargest(:,1), ForearmLargest(:,2)); 
Measurements = ForearmLargest;
% figure;
% scatter3(vert(:,1), vert(:,2), vert(:,3))
% hold on
% scatter3(vertices(:,1), vertices(:,2), vertices(:,3))
% scatter3(SJ(:,1), SJ(:,2), SJ(:,3),'filled')
% axis equal
% xlabel('x')
% ylabel('y')
% zlabel('z')
% 
% figure;
% subplot(1,2,1)
% scatter3(CutVertStore1(:,1), CutVertStore1(:,2), CutVertStore1(:,3))
% axis equal
% xlabel('x')
% ylabel('y')
% zlabel('z')
% 
% subplot(1,2,2)
% scatter(zy_CutVert(:,1), zy_CutVert(:,2))
% hold on
% scatter(ymax_store(:,2), ymax_store(:,3))
% scatter(ymin_store(:,2), ymin_store(:,3))
% axis equal
% xlabel('y')
% ylabel('z')



%divide found boundary points into regions

%isolate chest region
% Chest_region = ymax_store(ymax_store(:,3) < SJ(4,3)-0.07,:)
% 
% %find slice where the maximum y coord is (cup size)
% [~,ind] = max(Chest_region(:,2));
% Cut = Chest_region(ind,3); 
% [CupSize] = miniSlice(vertices,faces, Cut);
% sliceT = CupSize*inv(R)
% scatter3(sliceT(:,1),sliceT(:,2), sliceT(:,3))
% CupSize = EstimateCurcumference(CupSize(:,1), CupSize(:,2)) 
% 
% %find slice where the min y coord is (band size)
% [~,ind] = min(Chest_region(:,2));
% Cut = Chest_region(ind,3); 
% [BandSize] = miniSlice(vertices,faces, Cut);
% sliceT = BandSize*inv(R)
% scatter3(sliceT(:,1),sliceT(:,2), sliceT(:,3))
% BandSize = EstimateCurcumference(BandSize(:,1), BandSize(:,2)) 
% 
% %isolate butt
% Butt_region = ymin_store(ymin_store(:,3) > SJ(4,3),:)
% [~,ind] = min(Butt_region(:,2));
% Cut = Butt_region(ind,3); 
% [Butt] = miniSlice(vertices,faces, Cut);
% sliceT = Butt*inv(R)
% scatter3(sliceT(:,1),sliceT(:,2), sliceT(:,3))
% Butt = EstimateCurcumference(Butt(:,1), Butt(:,2)) 
% 
% 
% %isolate waist
% temp1 = xmax_store(:,3) > SJ(10,3)
% temp2 = xmax_store(:,3) < SJ(1,3)
% Waist_region = xmax_store(and(temp1,temp2),:)
% [~,ind] = min(Waist_region(:,1));
% Cut = Waist_region(ind,3); 
% [Waist] = miniSlice(vertices,faces, Cut);
% sliceT = Waist*inv(R)
% scatter3(sliceT(:,1),sliceT(:,2), sliceT(:,3))
% Waist = EstimateCurcumference(Waist(:,1), Waist(:,2)) 
% 
% 
% Measurements = [CupSize, BandSize, Butt, Waist, Chest]

end