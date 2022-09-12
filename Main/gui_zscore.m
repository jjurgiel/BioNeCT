function [zscore_matrix normalized_matrix] = gui_zscore(data)
n = size(data,1);
tempmat = zeros(n);
%Find average matrix
for i=1:size(data,3)
    tempmat = tempmat+data(:,:,i);
end
tempmat = tempmat/size(data,3);
tempmat(1:n+1:end)=0;

%Find mean and standard dev
submean = sum(sum(triu(tempmat,1)))/nnz(triu(tempmat,1));
tempstd = triu(tempmat,1);
tempstd = sort(tempstd(:),'descend');
tempstd = tempstd(any(tempstd,2));
substd = std(tempstd);

%Z-score input matrices in data
for z = 1:1:size(data,3) %time periods/sets of matrices
    datatemp = data(:,:,z);
    datatemp(1:n+1:end)=0;
    for i = 1:1:size(data,1) %rows
        for j = 1:1:size(data,2); %cols
            zmattemp(i,j) = (datatemp(i,j) - submean)/substd;
            
        end
    end
    %zmattemp(1:n+1:end)=0;
    matlist = unique(zmattemp(:)); matmin = matlist(2);
    zscore_matrix(:,:,z) = zmattemp;
    normalized_matrix(:,:,z) = mat2gray(zmattemp,[matmin,max(max(zmattemp))]);
end

