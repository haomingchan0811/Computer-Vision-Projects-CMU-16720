function checkSubmission(andrewid)
% checkSubmission verifies that your submission zip has the correct structure
% and contains all the needed files.
%
%   checkSubmission(ANDREWID) checks 'ANDREWID.zip' for the correct structure

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

    if exist(strcat(ROOT, '/', WRITEUP), 'file') ~= 2
        fprintf('Writeup not found. Please save writeup to %s and zip.\n', WRITEUP)
        errors = errors+1;
    end

    matlabfiles_code = {
        'createGaussianPyramid.m',
        'displayPyramid.m',
        'createDoGPyramid.m',
        'computePrincipalCurvature.m',
        'getLocalExtrema.m',
        'DoGdetector.m',
        'makeTestPattern.m',
        'computeBrief.m',
        'briefLite.m',
        'briefMatch.m',
        'plotMatches.m',
        'briefRotTest.m',
        'computeH.m',
        'imageStitching.m',
        'imageStitching_noClip.m',
        'ransacH.m',
        'generatePanorama.m',
        }';

    for i = matlabfiles_code
        mfile = strcat(ROOT, '/', CODE, '/', i{1});
        if exist(mfile, 'file') ~= 2
            fprintf('%s not found.\n', mfile)
            errors = errors+1;
        end
    end
    
    matlabfiles_results = {
        'testPattern.mat',
        'q6_1.jpg',
        'q6_1.mat',
        'q6_2_pan.jpg',
        'q6_3.jpg'
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
