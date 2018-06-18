% a=imported data matrix
a = Ca;

A=downsample(a,20);
k=length(A)./5;
A=A(k:end,:);

F=zeros(size(A));

%USE BELOW 2 LINES IF YOU WANT TO USE ALL DATA AS BASELINE
f=mean(A(:,2),1); 
F(:,:)=f;


% for i=1000:length(F)
%     F(i,1)=A(i,1);
%     F(i,2)=mean(A(i-999:i),2);
% end

S=zeros(size(A));

for i=1:size(A,1)
    S(i,1)=A(i,1);
    S(i,2)=(A(i,2)-F(i,2))./F(i,2);
end


%mat2clip(S)
figure; plot(S(:,1),S(:,2))
