% restoredefaultpath;
clear;
ExlFileName = 'CancervsnonDeeplearningAllPatientsNames.xlsx';
[b,EpxFileNameList] = xlsread(ExlFileName);
PatientNameList = EpxFileNameList(1:end,1);
WSINameList = EpxFileNameList(1:end,2);
PatientNames = unique(PatientNameList);
NumOfPatients = size(PatientNames,1);
Path_save = 'D:\Works_DeepLearning\Results\CancervsNon(Nuclei)\';  %% save file path
Path_ImgsTrain = 'C:\ImgTrain\';    %% training dataset path
path_ImgsTest = 'E:\DeepLearningImgCancerDetectTCM(NucleiMap)\ImgTest\';     %% testing dtaset path
net = alexnet;


for P = 1:NumOfPatients
%     setpref('Internet','E_mail','whan25@uwo.ca');
%     setpref('Internet','SMTP_server','smtp.uwo.ca');
    PatientName = PatientNames{P,1};
    EMRsavepath = fullfile(Path_save,PatientName);
    EMRFileName = [PatientName,'_EMR.mat'];
    EMRSave = fullfile(EMRsavepath,EMRFileName);
    TestOutComeFileName = [PatientName,'_TestOutCome.mat'];
    TestSave = fullfile(EMRsavepath,TestOutComeFileName);
    if exist(EMRsavepath,'dir')
        disp(PatientName);
        continue;
    else
        mkdir(EMRsavepath);
    end
    if exist(TestSave,'file') == 0
        [YPred,scores,YValidation,netTransfer,TrainingFileNames,TestingFileNames] = TrainandGuess(PatientNames,WSINameList,P,Path_ImgsTrain,path_ImgsTest,net);
        [EMR,TestOutCome] = CalculateDeepLearningOutCome(YPred,YValidation,scores,TrainingFileNames,TestingFileNames,netTransfer);
        %% save the testing results %%
        save (EMRSave,'EMR');
        save (TestSave,'TestOutCome');
        clear YPred;clear score; clear YValidation; clear netTransfer; clear TrainingFileNames; clear TestingFileNames; clear EMR; clear TestOutCome;
    end
%     emailMSG = ['Deep learning loop',num2str(P),'finished'];
%     sendmail('whan25@uwo.ca','Status update',emailMSG);
end
