function checkA3Submission(andrewid)
% checkSubmission verifies that your submission zip has the correct structure
% and contains all the needed files.
% 
%   checkSubmission(ANDREWID) checks 'ANDREWID.zip' for the correct structure
% 1. create a folder called <andrewid> 
% 2. put your report, 'code' folder, and 'results' folder in your <andrewid> folder
% 3. create your zip file called <andrewid.zip> 
% 4. run this function with the <andrewid> string. example: checkSubmission('janedoe')

    errors = 0;
    TMPDIR = '.tmpunzip';
    mkdir(TMPDIR)

    ZIPFILE = strcat(andrewid, '.zip');
    ROOT = strcat(TMPDIR, '/');
    WRITEUP = strcat(andrewid, '/', andrewid, '.pdf');
    CODE = strcat(andrewid, '/code');   
    RESULTS = strcat(andrewid, '/results'); 

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
        'LucasKanadeInverseCompositional.m',
        'LucasKanadeBasis.m',
        'LucasKanadeAffine.m',
        'SubtractDominantMotion.m',
        'testCarSequence.m',
        'testUltrasoundSequence.m',
        'testSylvSequence.m',
        'testAerialSequence.m',
        }';

    for i = matlabfiles_code
        mfile = strcat(ROOT, '/', CODE, '/', i{1});
        if exist(mfile, 'file') ~= 2
            fprintf('%s not found.\n', mfile)
            errors = errors+1;
        end
    end
    
    matlabfiles_results = {
        'carseqrects.mat',
        'usseqrects.mat',
        'sylvseqrects.mat',
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
