/ lang

/ ---------------------------------------------------------
/ following will give errors:
{1+x} "a"
1 2 + 10 20 30
2 + "hello"

/ ---------------------------------------------------------
x:2 5 4 7 5
x
x*10
count x
sum x
sums x
prds x
distinct x
avg x

/ ---------------------------------------------------------
a:`toronto         / symbol
a
b:"toronto"        / character string
b
count a            / 1 symbol
count b            / 7 characters
a="o"              / error (cannot compare symbol and character)
b="o"              / 1 (= true) where matched

/ ---------------------------------------------------------
f:{2+3*x}
f 10
til 5
f til 5

/ ---------------------------------------------------------
/ execution is right to left:
2 * 5 - 3
(2 * 5) - 3

/ ---------------------------------------------------------
/ Function arguments are x, y, z by default, 
/ and otherwise given in brackets:
addtax:{[rate;sale] sale * 1 + rate % 100}
addtax[7.5;100 200 500]

/ ---------------------------------------------------------
/ indexing is by juxtaposition:
x:2 5 4 7 5
x 3
x 0 3 2
(x 2 4):10 20
x

/ ---------------------------------------------------------
/ adverbs modify functions:
x:(til 4;"hello")
reverse x
reverse each x

1 2 3 +/: 10 20
1 2 3 +\: 10 20
1 2 3 */: 10 20

/ ---------------------------------------------------------
/ update in place:
x:5
x+:2
x

/ ---------------------------------------------------------
/ control word example:
r:1 1
x:10
while[x-:1;r,:sum -2#r]
r

/ ---------------------------------------------------------
/ following loads a script:
\l 2.qLanguage/lists.q

items
sales
prices
sales*prices

tab
tab 0 2
tab `sales
tab, tab
flip tab

select from tab where prices>12
select sales,prices,total:sales*prices from tab
select items,total:sales*prices,
 cumtot:sums sales*prices from tab

/ ---------------------------------------------------------
\l sp.q

select from p where weight=17

q)select from sp where s.city=p.city
s)select sp.s,sp.p,sp.qty from s,p,sp where sp.s=s.s
 and sp.p=p.p and p.city=s.city

/ ---------------------------------------------------------
select p,p.city from sp

/ ---------------------------------------------------------
t:select qty by s from sp
t

t`s1
ungroup t
