%% Convert .nd2 files to .tif files
% You will set this code running, and then bring the NIS-Elements
%   window into focus. Convert the first movie in a folder full of movies
%   and this code will do the rest of them with the same settings that were
%   chosen for the first one.

number_of_movies = 6;
longest_time_to_export = 1; %in seconds

%After hitting CTRL+ENTER you will have 3 seconds to make NIS-Elements the focus
nd2_to_tif(number_of_movies, longest_time_to_export);

%% Preparing file system
% Once you have the tifs, you need to organise them in a certain way 
%   depending on what they were. For a 2D movie you can put them wherever
%   you want, but they need to, in the end, be contained in a folder titled
%   'orig_movies'. However, for a 3D movie the folder needs to be named
%   'movies'. The 3D code will create folders named orig_movies in folders 
%   in the movies folder.

%% Running the movies
% I'll try to put all options in here, and you can switch between them as
%   needed.
%   1 -> 2D movie
%   2 -> 3D movie
%   3 -> 2D sequence movie
%   4 -> 3D sequence movie
% You need to provide values for everything up until the switch. If your folder contains
%   many different movies and some of the properties are different, then any of these can
%   be a vector instead of a scalar. See comb_run for notes on movie order.

movie_type = 1;

movie_folder = 'some_folder_that_contains_orig_movies_or_movies';
frame_gap = 3;
background = 400;
t_stacks = 25;
z_stacks = 20;
num_sequences = 11;


switch movie_type
    case 1
        comb_run(movie_folder, frame_gap, background);
    case 2
        comb_run_3D(movie_folder, t_stacks, z_stacks, frame_gap, background);
        nsta = running_for_3Dt(movie_folder, frame_gap, background);
        SaveNSTASeparate(movie_folder, 'separated_', nsta);
    case 3
        comb_run_seq(movie_folder, t_stacks, num_sequences, frame_gap, background)
    case 4
        comb_run_3D_seq(move_folder, t_stacks, z_stacks, num_sequences, frame_gap, background)
        nsta = running_for_3Dt(movie_folder, frame_gap, background);
        SaveNSTASeparate(movie_folder, 'separated_', nsta);
end

%% Analyzing the movies
% If you're working with 2D movies, then you'll have to convert the data into a structure.
%   First you must click on the .mat file to load the variable Threshfxyc into the
%   workspace. Then run these functions.
tmpst = fxyc_to_struct(Threshfxyc);
tmpst = slope_finding(tmpst, frame_time, background);
% These structure have the fields frame, x posision, y posision, class, intensity, 
%   lifetime, and slope.
% The .mat files from 3D movies already contain a structure, but it has the additional
% field of "st" which is short for "stack" and it means the z-position. Ignore the coin
% and weight fields (if they're there). 

% From here you can refer to script_for_jt on tips and tricks for cutting up structures to
%   present data in the ideal way. Common cuts we make on the data are to exclude traces
%   less than 20s or greater than 200s lifetimes. When analyzing lifetime we only use traces
%   with a class 3, but for slopes you can use class 1, 2, and 3. Slopes are padded with
%   zeros so the vectors are all the same length, so be careful to exclude all zero values
%   from the slope. There will never be a true slope value that is exactly zero.
