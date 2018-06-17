%Ca= calcium signal
%input=input trace
% downsample to 200Hz
A=downsample(Ca,30);
B=downsample(input,30);

B=B';
C=zeros(size(B));
D=zeros(size(B));
E=zeros(size(B));

% identify inputs
for i=1:length(B)
if B(i)>=5
C(i)=1;
else
end
end

for i=1:length(C)
    if C(i)==1
        D(i)=1;
        D(i-1)=0;
        D(i-2)=0;
        D(i-3)=0;
    else
    end
end

% extract the indeces of inputs
for i=1:length(D)
    if D(i)==1
        E(i)=i;
    else
    end
end





E(E==0)=[];
E([2:2:end])=[]; %start of all calls

E1=E([1:3:end]); %start of call one
E2=E([2:3:end]); %start of call two
E3=E([3:3:end]); %start of call three

%extract raw fluorescent traces of a specific size
F1=zeros(length(E1),150);
F2=zeros(length(E2),150);
F3=zeros(length(E3),150);


for i=1:length(E1)
F1(i,:)=A(:,(E1(i,1)-49):(E1(i,1)+100));
end

for i=1:length(E2)
F2(i,:)=A(:,(E2(i,1)-49):(E2(i,1)+100));
end

for i=1:length(E3)
F3(i,:)=A(:,(E3(i,1)-49):(E3(i,1)+100));
end



% calculating dF/F

%baselines
F1b=mean(F1(:,1:49),2);
F2b=mean(F2(:,1:49),2);
F3b=mean(F3(:,1:49),2);

F1B=zeros(length(F1b),150);
F2B=zeros(length(F2b),150);
F3B=zeros(length(F3b),150);

for j=1:size(F1B,2)
F1B(:,j)=F1b;
end

for j=1:size(F2B,2)
F2B(:,j)=F2b;
end

for j=1:size(F3B,2)
F3B(:,j)=F3b;
end

%the real dF/F
dFF1=(F1-F1b)./F1b;
dFF2=(F2-F2b)./F2b;
dFF3=(F3-F3b)./F3b;


%plotting
figure 
plot(dFF1')

figure 
plot(dFF2')

figure 
plot(dFF3')

% exporting the data
xlswrite('rec',dFF1','call one');
xlswrite('rec',dFF2','call two');
xlswrite('rec',dFF3','call three');

clear all

