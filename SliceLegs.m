function [Measurements] = SliceLegs(vertices_unchanged,faces, SJ_unchanged, Cuts_unchanged, decideRot)

plane_vec = [0 0 1]';


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
temp1 = zy_CutVert(:,1) < 0;
temp2 = zy_CutVert(:,2) > SJ(6,3);

calfBack = CutVertStore1(and(temp1,temp2),:);



zy_CutVert_backCalf = zy_CutVert(and(temp1,temp2),:);
zy_CutVert_front = zy_CutVert(zy_CutVert(:,1) > 0,:);


%look at zx projection
zx_CutVert = [CutVertStore1(:,1), CutVertStore1(:,3)];
% zy_CutVert_back = zy_CutVert(zy_CutVert(:,1) < 0,:);
% zy_CutVert_front = zy_CutVert(zy_CutVert(:,1) > 0,:);

%go through each slice, find the point that is the most positive in y, and
%most negative in y

%find largest slice in calf
Calf_region = calfBack;
[~,ind] = min(Calf_region(:,2));
Cut = Calf_region(ind,3); 
[CalfLargest] = miniSlice(vertices,faces, Cut);
CalfLargest(CalfLargest(:,1) < 0,:) = [];
sliceT = CalfLargest*inv(R);
scatter3(sliceT(:,1),sliceT(:,2), sliceT(:,3),'filled')
CalfLargest = EstimateCurcumference(CalfLargest(:,1), CalfLargest(:,2));

Measurements = CalfLargest;

% 
% figure;
% % subplot(1,3,1)
% scatter3(CutVertStore1(:,1), CutVertStore1(:,2), CutVertStore1(:,3),12,'.')
% %scatter3(OneLeg(:,1), OneLeg(:,2), OneLeg(:,3),12,'.')
% axis equal
% hold on
% scatter3(SJ(:,1), SJ(:,2), SJ(:,3),'filled')
% scatter3(CalfLargest(:,1), CalfLargest(:,2), CalfLargest(:,3))
% xlabel('x')
% ylabel('y')
% zlabel('z')

% subplot(1,3,2)
% scatter(zy_CutVert_backCalf(:,1), zy_CutVert_backCalf(:,2),2,'b')
% hold on
% scatter(zy_CutVert_front(:,1), zy_CutVert_front(:,2),2,'r')
% scatter(ymax_store(:,2), ymax_store(:,3),'k','filled')
% scatter(ymin_store(:,2), ymin_store(:,3),'m','filled')
% 
% scatter(SJ(:,2), SJ(:,3),'filled')
% axis equal
% % ylim([-0.2, 0.4])
% % xlim([-0.2, 0.2])
% title('zy projection')
% xlabel('y')
% ylabel('z')
% 
% 
%subplot(1,3,3)
% figure;
% scatter(OneLeg(:,1), OneLeg(:,3),2,'b')
% title('zx projection')
% axis equal
% hold on
% xlabel('x')
% ylabel('z')
% 
% %scatter torso side1 (will use for verifying waist
% scatter(xmax_store(:,1), xmax_store(:,3),'y','filled')
% scatter(xmin_store(:,1), xmin_store(:,3),'c','filled')
% scatter(SJ(:,1), SJ(:,3),'filled')
% % ylim([-0.2, 0.4])
% % xlim([-0.3, 0.3])


end