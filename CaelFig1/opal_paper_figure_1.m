clear all; clc; load mouw_allfluxes.mat;

b = .4:.01:1; % parameter space to scan -- b-value
csr = .1:.01:.5; % parameter space to scan -- ratio of alphas
j = find(Y<-30); % find different regions -- data are sparse enough that one can draw a line of constant longitude to split Atl. vs. Pac.
nboot = 1000; % number of bootstrap iterations

z = Z(j); s = S(j); i = I(j); o = O(j); % subset data
z = z(o>0); i = i(o>0); s = s(o>0); o = o(o>0);
z = z(s>0); i = i(s>0); o = o(s>0); s = s(s>0);
z = z(i>0); o = o(i>0); s = s(i>0); i = i(i>0);
o = o(z>0); i = i(z>0); s = s(z>0); z = z(z>0);

clearvars -EXCEPT z s o i csr b nboot;

xc = i; % one x variable
xs = s; % the other

lo = log(o); % y is the log of Foc
n = length(lo);

for k = 1:nboot;

btstrp = randi(n,n,1); % get a bootstrap sample
yb = lo(btstrp); 
xcb = xc(btstrp);
xsb = xs(btstrp);
zb = z(btstrp);


for i = 1:length(b); % for each b-value
    for j = 1:length(csr); % & each ratio of alphas
        y = yb+b(i).*(log(zb)-log(1000)); % rescale by depth
        x = log(xcb+csr(j).*xsb); % define x variable
        [m(i,j),a(i,j),r(i,j),sm(i,j),sb(i,j)] = lsqfitma(x,y); % major axis type 2 regression
        B(i,j) = b(i);
        CSR(i,j) = csr(j);
    end
end

[R(k),indx] = max(r(:)); % save bootstrap iteration's R^2
bb(k) = B(indx); % and b-value
csrb(k) = CSR(indx); % and ratio of alphas 'beta'
M(k) = m(indx); % and slope, i.e. gamma
Mu(k) = sm(indx); % and slope uncertainty
A(k) = a(indx); % and intercept -- to get kappa, which along with beta gives you the alphas: see equation at end of section 2.1 within the text 
Au(k) = sb(indx); % and the uncertainty in the alphas
k
end

r2_ = median(R.^2) % report bootstrap median r^2
b_ = median(bb) % and median b-value
bu_ = mad(bb) % and m.a.d. of b-values
beta_ = median(csrb) % and median ratio of alphas -- which along with kappa and gamma gives you the alphas
betau_ = mad(csrb) % and m.a.d. of this ratio
gamma_ = median(M) % and median gamma
gammau_ = median(Mu) % and median uncertainty in gamma (could & maybe should use m.a.d. of gammas in text, actually... will change this)
kappa_ = median(exp(A)) % and median kappa
kappau_ = .5*median(exp(A+Au)-exp(A-Au)) % and transform uncertainty in log-kappa to uncertainty in kappa -- but like above should just report m.a.d. of bootstraps actually


