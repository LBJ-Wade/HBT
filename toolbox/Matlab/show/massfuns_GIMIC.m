%mass function for five GIMIC    halos

m1=[9.04448      9.15874      9.35088      9.55307      9.76046      9.96363      10.1677      10.3667      10.5894      10.7840      10.9966      11.1932      11.4111      11.5884      11.8226      12.0364      12.1449      12.5574      12.5574      12.6438];
      n1=[4717.08      12846.9      10226.2      6165.12      3838.63      2306.81      1389.73      819.763      537.550      382.552      260.725      171.938      120.561      74.2812      34.9662      21.2173      16.4795      7.99975      7.76675      1.88513];

      m2=[9.04255      9.15428      9.35059      9.55331      9.76099      9.94606      10.1619      10.3636      10.5724      10.7823      10.9926      11.1130      11.3846      11.6094      11.8417      11.9404];
      n2=[816.481      2018.66      1561.03      971.052      558.025      330.766      157.798      112.885      75.6745      50.6692      27.0564      14.3282      4.63695      4.50189      4.37077      2.12173];

      m3=[9.04159      9.15215      9.36425      9.54931      9.76859      9.94049      10.1604      10.3506      10.6004      10.7855      10.9710      11.1975      11.2879      12.0105      12.0579      12.0579];
      n3=[456.172      1094.38      925.403      653.418      396.492      208.155      99.6617      61.8182      39.1420      35.4684      27.0564      16.7162      6.95543      2.18539      4.24347      4.11987];

      m4=[9.04702      9.15512      9.35823      9.54819      9.77756      9.94388      10.1607      10.3694      10.5785      10.7381      10.8244      11.2982      11.2982      11.7358      11.7358];
      n4=[224.780      584.095      501.650      293.433      196.777      122.612      71.9779      56.4427      39.1420      20.2677      4.91934      4.77606      4.63695      2.25095      2.18539];

      m5=[9.03359      9.15233      9.36018      9.56322      9.74450      9.95606      10.1739      10.2689      10.6964      10.6964];
      n5=[59.5006      160.466      137.097      108.903      82.2353      51.3258      24.9154      10.7510      2.60946      2.53346];
      
n1=n1*log10(exp(1));
n2=n2*log10(exp(1));
n3=n3*log10(exp(1));
n4=n4*log10(exp(1));
n5=n5*log10(exp(1));

%M_{200b}
M1=1.249e5;
M2=2.378e4;
M3=1.086e4;
M4=6.356e3;
M5=1.677e3;
%%
RunName='GIMIC';
outputdir='/home/kam/Projects/HBT/code/data/show/massfun';
     myfigure;
      semilogy(m1,n1/M1,'r--o');
      hold on;
      plot(m2,n2/M2,'g--s');
      plot(m3,n3/M3,'b--d');
      plot(m4,n4/M4,'c--<');
      plot(m5,n5/M5,'k-->');
      
      
    xref=logspace(9,13,5);
    yref=10^-3.03*(xref).^-0.9*10^10;
    plot(log10(xref),yref,'k-');
    
    xlabel('$\log(M_{sub}/(M_{\odot}/h))$','interpreter','latex');
    ylabel('$dN/d\ln M_{sub}/M_{host}\times(10^{10}M_{\odot}/h)$','interpreter','latex');
    hl=legend('$M=1.2e15$','2.4e14','1.1e14','6.4e13','1.7e13','G10');
set(hl,'location','southwest','interpreter','latex');
title('GIMIC HALOs');
print('-depsc',[outputdir,'/msfunln_',RunName,'.eps']);
%%
   myfigure;
      semilogy(m1-log10(M1)-10,n1,'r--o');
      hold on;
      plot(m2-log10(M2)-10,n2,'g--s');
      plot(m3-log10(M3)-10,n3,'b--d');
      plot(m4-log10(M4)-10,n4,'c--<');
      plot(m5-log10(M5)-10,n5,'k-->');
      
      
      xref=logspace(-6,0,5);
yref=10^-3.02*(M1*1e10)^0.1*(xref).^-0.9;
    plot(log10(xref),yref,'k-');
    
xlabel('$\log(M_{sub}/M_{200b})$','interpreter','latex');
ylabel('$dN/d\ln(M_{sub}/M_{200b})$','interpreter','latex');
hl=legend('$M_{200b}=1.2e15M_{\odot}$','2.4e14','1.1e14','6.4e13','1.7e13','G10,1.2e15');
set(hl,'location','southwest','interpreter','latex');
title('GIMIC HALOs');

print('-depsc',[outputdir,'/msfunNln_',RunName,'.eps']);

%% Owen's data, for AquaC-4
    data=[  1.24546e+07      376.553
  1.84023e+07      358.622
  2.71902e+07      202.365
  4.01749e+07      174.188
  5.93603e+07      143.449
  8.77075e+07      107.587
  1.29592e+08      61.4781
  1.91478e+08      40.9854
  2.82918e+08      20.4927
  4.18025e+08      17.9311
  6.17651e+08      15.3695
  9.12608e+08      7.68477
  1.34842e+09      2.56159
  1.99236e+09      5.12318
  2.94380e+09      0.00000
  4.34960e+09      5.12318
  6.42674e+09      0.00000
  9.49580e+09      0.00000
  1.40305e+10      0.00000
  2.07307e+10      2.56159];

Maq=1.06e2; %virial mass
mp=5.75e5; %particle mass
 myfigure;
      semilogy(log10(data(:,1)),data(:,2)/Maq,'r--o');
      hold on;
       xref=logspace(7,11,5);
    yref=10^-3.03*(xref).^-0.9*10^10;
    plot(log10(xref),yref,'k-');
    
    xlabel('$\log(M_{sub}/(M_{\odot}/h))$','interpreter','latex');
    ylabel('$dN/d\ln M_{sub}/M_{host}\times(10^{10}M_{\odot}/h)$','interpreter','latex');
%     hl=legend('$M=1.2e15$','2.4e14','1.1e14','6.4e13','1.7e13','G10');
% set(hl,'location','southwest','interpreter','latex');
title('AquaC-4 HALO');
RunName='AquaC4';
outputdir='/home/kam/Projects/HBT/code/data/show/massfun';
print('-depsc',[outputdir,'/msfunln_',RunName,'.eps']);