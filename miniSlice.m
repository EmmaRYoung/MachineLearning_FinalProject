function [segments_vec] = miniSlice(vertices,faces, Cuts)

plane_vec = [0 0 1]';

for i=1:size(Cuts,1)
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
end
%scatter3(vertices(:,1), vertices(:,2), vertices(:,3),12,'.')
% hold on
% axis equal
% scatter3(segments_vec(:,1), segments_vec(:,2), segments_vec(:,3))


end