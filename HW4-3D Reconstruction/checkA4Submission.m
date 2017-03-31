function checkA4Submission(andrewid)
% checkSubmission verifies that your submission zip has the correct structure
% and contains all the needed files.
% 
%   checkSubmission(ANDREWID) checks 'ANDREWID.zip' for the correct structure
% 1. create a folder called <andrewid> 
% 2. put your report, ‘matlab’ folder, and ‘custom’ folder in your <andrewid> folder
% 3. create your zip file called <andrewid.zip> 
% 4. run this function with the <andrewid> string. example: checkSubmission('janedoe')

    errors = 0;
    TMPDIR = '.tmpunzip';
    mkdir(TMPDIR)

    ZIPFILE = strcat(andrewid, '.zip');
    ROOT = strcat(TMPDIR, '/');
    CODE = strcat(andrewid, '/matlab');   
    RESULTS = strcat(andrewid, '/matlab'); 

    if exist(ZIPFILE, 'file') == 2
        disp('found');
        unzip(ZIPFILE, TMPDIR)
    else
        fprintf('Could not find handin zip. Please make sure your zipfile is named %s.\n', ZIPFILE)
        errors = errors+1;
        fprintf('Found %d problems.\n', errors)
        return
    end



    matlabfiles_code = {
        'camera2.m',
        'displayEpipolarF.m',
        'eightpoint.m',
        'epipolarCorrespondence.m',
        'essentialMatrix.m',
        'findM2.m',
        'ransacF.m',
        'refineF.m',
        'sevenpoint.m',
        'triangulate.m',
        'visualize.m',
        }';

    for i = matlabfiles_code
        mfile = strcat(ROOT, '/', CODE, '/', i{1});
        if exist(mfile, 'file') ~= 2
            fprintf('%s not found.\n', mfile)
            errors = errors+1;
        end
    end
    
    matlabfiles_results = {
        'q2_1.mat',
        'q2_2.mat',
        'q2_5.mat',
        'q2_6.mat',
        'q2_7.mat'
        }';

    for i = matlabfiles_results
        mfile = strcat(ROOT, '/', RESULTS, '/', i{1});
        if exist(mfile, 'file') ~= 2
            fprintf('%s not found.\n', mfile)
            errors = errors+1;
        end
    end
    
    if errors == 0
        fprintf('Zip file structure looks good.\n')
    else
        fprintf('Found %d problems.\n', errors)
    end

    rmdir(TMPDIR, 's')
end
