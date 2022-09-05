
$TITLE FK_Book Chapter: AoN Representation- PROJECT MODEL WITH RENEWABLE RESOURCES
*****MODEL-4: MINIMIZE THE PROJECT COMPLETION TIME FIRST AND THEN LEVEL THE RENEWABLE RESOURCE TO MINIMIZE****
************************************************************************ *********************
set
        i  activities (t is for terminal- s is for start dummy activities)
           / s,a,b,c,d,e,f,g,h,i,j,t /
        tt time in weeks.. 0 is project start time.
           / 0*30/
;
alias(i,j);
alias(tt,ttt)
set
        A set of activities having immediate predecessor relation- arcs
*                        (immediate predecessor of activity j is activity i)
           /s.a,s.b,a.c,b.d,b.e,c.f,d.f,c.g,d.g,c.h,d.h,e.h,c.i, d.i, e.i, f.j, h.j, g.t, j.t, i.t/
;
parameters
        t(i) time(duration)in weeks required  for activity i
             /a 2, b 3, c 2, d 3, e 2, f 3, g 2, h 7, i 5, j 6/

        rr(i) renewable resource needed for i (number of workers for i)
            /a 0, b 5, c 0, d 7, e 3, f 2, g 1, h 2, i 5, j 6/
        ResourceUsedAtTT(tt) resource used at time tt
;

scalar
       epsi an arbitrarily small positive number
         /0.01/
;
variables
   Z         Objective function value
   V         proje süresince kullanýlan maks kaynak miktarý

;

binary variables
  x(i,tt)   whether activity i is completed at time tt or not
;
equations
   ObjF             obj. func. value
   ConstraintA      constraints for nodes(activities) that each activity has to be completed
   ConstraintTime   time constraint for each arc (time needed between activities having IP relation)
   ConstraintV      constraint to minimize number of workers at each week tt
;

ObjF..
       Z =E= epsi*V + sum(tt,(ord(tt)-1)*x('t',tt));
;


*ConstraintA(i) $ (ord(i)ne card(i)and (ord(i)<> 1))..
ConstraintA(i)..
           sum(tt, x(i,tt))=E=1  ;
ConstraintTime(i,j) $ A(i,j)..
           sum(tt, (ord(tt)-1)*x(j,tt))- sum(tt, (ord(tt)-1)*x(i,tt))  =G= t(j) ;
ConstraintV(tt)..
****           V=G= sum((i,ttt) $((ord(ttt) >= (ord(tt)+1)) and (ord(ttt) <= ord(tt)+ t(i))), rr(i)*x(i,ttt)); asagýdaki kýsýt daha dogru
            V=G= sum((i,ttt) $((ord(ttt) >= (ord(tt))) and (ord(ttt) <= ord(tt)+ t(i)-1)), rr(i)*x(i,ttt));

option optcr= 0.0001;
model Model_4 /all/;
*y.fx('f')=1;

solve Model_4 using MIP Minimizing Z ;
loop (tt,
****       ResourceUsedAtTT(tt)= sum((i,ttt) $((ord(ttt) >= (ord(tt)+1)) and (ord(ttt) <= ord(tt)+ t(i))), rr(i)*x.l(i,ttt)); asagýdaki kýsýt daha dogru
        ResourceUsedAtTT(tt)= sum((i,ttt) $((ord(ttt) >= (ord(tt))) and (ord(ttt) <= ord(tt)+ t(i)-1)), rr(i)*x.l(i,ttt));
);
display z.l, v.l, x.l,ResourceUsedAtTT ;
