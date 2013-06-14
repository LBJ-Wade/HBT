m=[264103
206580
177951
158416
143713
132220
122930
115422
109699
105445
102365
100176
98456
97083
95964
95046
94252
93596
93064
92624
92223
91866
91592
91332
91107
90926
90785
90657
90548
90442
90339
90248
90153
90069
90003
89947
89880
89833
89796
89758
89730
89705
89687
89673
89658
89642
89623
89607
89597
89589
89586
89579
89576
89571
89567
89563
89553
89546
89543
89536
89528
89523
];
%%
m=[78192
72894
71266
70771
70606
70543
70523
70519
70515
70513
70513
];
%%
m=[33810
31497
30611
30243
30059
29976
29942
29927
29923
29917
29914
29912
29912
];
%%
m=[3725
1964
1486
1279
1206
1169
1149
1141
1132
1126
1121
1121
];
%%
myfigure;%('visible','off');
x=1:numel(m);
plot(x,m,'-o');
xlabel('Number of Iterations $n$');
ylabel('Bound Mass $M_n$(particles)');

outputdir='/home/kam/Projects/HBT/code/data/show';
%outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show';
print('-depsc',[outputdir,'/unbinding_mass.eps']);

myfigure;%('visible','off');
x=1:numel(m);
plot(x(2:end),m(2:end)./m(1:end-1),'-o');
xlabel('Number of Iterations $n$');
ylabel('$M_n/M_{n{-}1}$');
print('-depsc',[outputdir,'/unbinding_precision.eps']);
% plot(1./x(1:end-1),-diff(m),'.');
