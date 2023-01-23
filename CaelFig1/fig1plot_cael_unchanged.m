% start with depth = z, IC flux = ic, Si flux = si, ratio of alpha's = beta, OC flux = oc, b = b, kappa = kappa, gamma = gamma
y = log(oc)+b.*(log(z)-log(1000)); % take log & normalise to 1km depth
x = log(kappa.^gamma_.*(xc+beta_.*xs)); % combine IC+Si fluxes & log to get x-axis
scatter(exp(x),exp(y),50,log10(xc./xs),'filled'); % plot data
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