clear all; clc; load mouw_allfluxes.mat;
close all; %TJ - closing all figures. 


b = .4:.01:1; % parameter space to scan -- b-value
csr = .1:.01:.5; % parameter space to scan -- ratio of alphas #TJ THIS IS ALSO BETA. WHY WE CAN'T BE CONSISTENT WITH NAMING IS BEYOND ME. 
j = find(Y<-30); % find different regions -- data are sparse enough that one can draw a line of constant longitude to split Atl. vs. Pac.
nboot = 1000; % number of bootstrap iterations


% TJ - cael's annotations for mouw all fluxes:
% samples with all fluxes, I = F_ic, O = F_oc, S = F_si, Z = depth, Y = lat, X = lon
% here he is renaming 
z = Z(j); s = S(j); i = I(j); o = O(j); % subset data, TJ cael seems to be making sure all values are positive
z = z(o>0); i = i(o>0); s = s(o>0); o = o(o>0);
z = z(s>0); i = i(s>0); o = o(s>0); s = s(s>0);
z = z(i>0); o = o(i>0); s = s(i>0); i = i(i>0);
o = o(z>0); i = i(z>0); s = s(z>0); z = z(z>0);

clearvars -EXCEPT z s o i csr b nboot;

xc = i; % one x variable #i = xc = F_ic, TJ. NAMING CONSISTENCY!!
xs = s; % the other #xs = s = F_si, again, unreasonable TJ

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
%TJ: don't have toolbox for bu, isnt' used later, won't worry about it for
%right now. 
%bu_ = mad(bb) % and m.a.d. of b-values
beta_ = median(csrb) % and median ratio of alphas -- which along with kappa and gamma gives you the alphas

%TJ: don't have toolbox for it, isnt' used later, won't worry about it for
%right now. 
%betau_ = mad(csrb) % and m.a.d. of this ratio
gamma_ = median(M) % and median gamma
gammau_ = median(Mu);%TJ suppress % and median uncertainty in gamma (could & maybe should use m.a.d. of gammas in text, actually... will change this)
kappa_ = median(exp(A)) % and median kappa
kappau_ = .5*median(exp(A+Au)-exp(A-Au)); %tj suppress % and transform uncertainty in log-kappa to uncertainty in kappa -- but like above should just report m.a.d. of bootstraps actually
median(A)

%%% add cael's plotting code
% start with depth = z, IC flux = ic, Si flux = si, ratio of alpha's = beta, OC flux = oc, b = b, kappa = kappa, gamma = gamma
oc = o; %tj - rename with above variable names for this code to make sense. why we need to keep switching single-character variable names is beyond me
kappa = kappa_; 

%TJ I really think he means b_ not b - the median, otherwise it doesn't
%quite make sense, change "b" in the below line to "b_"
y = log(oc)+b_.*(log(z)-log(1000)); % take log & normalise to 1km depth
%x = log(kappa.^gamma_.*(xc+beta_.*xs)); % combine IC+Si fluxes & log to get x-axis TJ: why the f is it called xc/xs and i/s. oh, he renamed it. 
x = log(xc + beta_.*xs); %shall we try to plot what's actually on graph labels

scatter(exp(x),exp(y),50,log10(xc./xs),'filled'); % plot data
%tcol = (log10(xc./xs)); %colour
%scatter(exp(x),exp(y(:,1)),50, tcol, 'filled'); % plot data TJ. 
set(gca,'xscale','log','yscale','log','ticklabelinterpreter','latex','fontsize',16) % y axis
box on % to add top+right edges to figure in matlab
axis([.005 500 .005 500]) % change to see all data as needed

title('Southern Ocean ($r^2 = 0.79$)','interpreter','latex') % example numbers from one region
ylabel('$\mathcal{F}_{OC} \times z^{0.69(\pm0.03)}$','interpreter','latex') % example numbers from one region
xlabel('$1.02(\pm0.03)\mathcal{F}_{IC}+ 0.20(\pm0.02)\mathcal{F}_{Si}$','interpreter','latex') % example numbers from one region
caxis([-2 2]) % change to see all data as needed
hold on % to plot over top of scattered data
spp = plot(logspace(-5,5),kappa_.*logspace(-5,5).^gamma_,'-.k','linewidth',3) % add regression line
spl = legend([spp],'$y\sim x^{0.86(\pm0.02)}$','fontsize',16,'location','southeast') % add legend with gamma+kappa 
set(spl,'interpreter','latex') % make font consistent with rest of plot
set(gca,'xtick',[.01 1 100],'ytick',[.01 1 100]) % feel free to change
colorbar %TJ, show colorbar
