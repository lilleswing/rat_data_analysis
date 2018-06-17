% a=imported data matrix

a = Ca;

A=downsample(a,10);
k=length(A)./10;
A=A(k:end,:);

F=zeros(size(A));

for i=1000:length(test)
     F(i,1)=a(i,1);
     F(i,2)=mean(a(i-24000:i),2);
end




%USE BELOW 2 LINES IF YOU WANT TO USE ALL DATA AS BASELINE
%f=mean(A(:,2),1); 
%F(:,:)=f;

%Erin test
%f=mean(A([300:700],2),1); 
%F(:,:)=f;


% for i=1000:length(F)
%     F(i,1)=A(i,1);
%     F(i,2)=mean(A(i-999:i),2);
% end

S=zeros(size(A));

for i=1:size(A,1)
    S(i,1)=A(i,1);
    S(i,2)=(A(i,2)-F(i,2))./F(i,2);
end


mat2clip(S)
plot(S(:,1),S(:,2))
