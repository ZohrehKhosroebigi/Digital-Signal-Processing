clc;
clear;


[s,FS] = audioread('Sound\s.wav');
[t] = audioread('Sound\t.wav');
[a] = audioread('Sound\a.wav');
[aa] = audioread('Sound\aa.wav');
[y] = audioread('Sound\y.wav');
[sh] = audioread('Sound\sh.wav');
%////////////////////////////////////////////
[f] = audioread('Sound\f.wav');
[e] = audioread('Sound\e.wav');
[l] = audioread('Sound\l.wav');
[i] = audioread('Sound\i.wav');
[n] = audioread('Sound\n.wav');
[b] = audioread('Sound\b.wav');
[r] = audioread('Sound\r.wav');
[v] = audioread('Sound\v.wav');
[d] = audioread('Sound\d.wav');
%/////////////////////////////////////////////
[k] = audioread('Sound\k.wav');
[ein] = audioread('Sound\ein.wav');
[m] = audioread('Sound\m.wav');
[o] = audioread('Sound\o.wav');
[u] = audioread('Sound\u.wav');
%/////////////////////////////////////////////Creat Word setayesh
combined = [s;t;aa;y;sh]; 
pause(7)
sound(combined,FS)
wavwrite(real(combined),FS,'Word Creat\Seytaesh.Wav');
pause(7) 
%/////////////////////////////////////////////Creat Word Feleshtin
combined = [f;e;l;e;s;t;i;n]; 
sound(combined,FS)
wavwrite(real(combined),FS,'Word Creat\Felestin.Wav');
pause(7) 
%/////////////////////////////////////////////Creat Word Beravid
combined = [b;e;r;a;v;i;d]; 
sound(combined,FS)
wavwrite(real(combined),FS,'Word Creat\Beravid.Wav');
pause(5) 
%/////////////////////////////////////////////Creat Word Daneshkadeye olomo
%fenon
combined1 = [d;a;n;e;sh;k;a;d;e;y;e];
sound(combined1,FS)
pause(7) 
combined2 = [ein;l;o;m;v;f;e;n;u;n]; 
sound(combined2,FS)
wavwrite(real([combined1;combined2]),FS,'Word Creat\Olom.Wav');
pause(6)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Pishnadahd 
[info,FS] = audioread('Sound\infoword.wav');
sound(info,FS)
pause(35)
%///setayesh
[seta,FS] = audioread('Sound\seta.wav');
[yesh,FS] = audioread('Sound\yesh.wav');
sound([seta;yesh],FS)
wavwrite(real([seta;yesh]),FS,'Word Creat\Setayesh2.Wav');
pause(4)
%///felestin
[feles,FS] = audioread('Sound\feles.wav');
[tin,FS] = audioread('Sound\tin.wav');
sound([feles;tin],FS)
wavwrite(real([feles;tin]),FS,'Word Creat\Felestin2.Wav');
pause(4)
%///beravid
[bera,FS] = audioread('Sound\bera.wav');
[vid,FS] = audioread('Sound\vid.wav');
sound([bera;vid],FS)
wavwrite(real([bera;vid]),FS,'Word Creat\Beravid2.Wav');
pause(7)
%///daneshkadeye olom va fenon
[daneshkade,FS] = audioread('Sound\daneshkade.wav');
sound(daneshkade,FS)
pause(1)

[olom,FS] = audioread('Sound\olom.wav');
sound(olom,FS)
pause(1)

[va,FS] = audioread('Sound\va.wav');
sound(va,FS)
pause(1)

[fenon,FS] = audioread('Sound\fenon.wav');
sound(fenon,FS)
wavwrite(real([daneshkade;olom;va;fenon]),FS,'Word Creat\Fenon2.Wav');



