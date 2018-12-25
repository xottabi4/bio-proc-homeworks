function [ idx ] = mpGundars( X, D, n_iter )
% MATCHING PURSUIT - naive implementation by Gundars
% Dictionary MUST BE NORMALIZED!!!
    idx = [];
    x = zeros(n_iter,1);
    r = X;
    for ii = 1:n_iter        
        cprod = D*r';
        cprod(idx) = 0;
        [~,I] = max((cprod));
        idx = [idx, I];
        r = r - D(I,:)*cprod(I);
        sqrt(sum(r.^2))
    end
end

%% To test:

% D = LF;
% 
% S = zeros(32,100);
% S([10,25,13],:) = rand(3,100);
% X = D*S;
% 
% for ii = 1:size(D,1)
%    D(:,ii) = D(:,ii)./norm(D(:,ii));
% end
% 
% [ idx ] = MP(X(:,1)', D, 3 )
