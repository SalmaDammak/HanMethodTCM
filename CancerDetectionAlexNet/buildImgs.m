function imds = buildImgs(Path_Img,WSINameList)   
    Files = [];
    Labels = [];
    for w = 1:size(WSINameList,1)
        WSIName = WSINameList{w,1};
        Pathfull_Img = [Path_Img,WSIName];
        PathfullCheckCancer = fullfile(Pathfull_Img,'Cancer','*.tif');
        PathfullCheckNonCancer = fullfile(Pathfull_Img,'NonCancer','*.tif');
        if size(dir(PathfullCheckCancer),1)==0&&size(dir(PathfullCheckNonCancer),1)==0
            disp('empty folder');
            disp(WSIName);
            disp('\\')
            continue;
        end
        imds = imageDatastore(Pathfull_Img, 'IncludeSubfolders',true, 'LabelSource','foldernames');
        Files = [Files;imds.Files];
        Labels = [Labels;imds.Labels];
    end
    imds.Files = Files;
    imds.Labels = Labels;
end