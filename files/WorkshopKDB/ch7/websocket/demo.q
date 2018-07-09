/ websocket demo

/ set listening port
\p 5020

/ set .z.ws to execute query and return the console output
/ the i/o is serialized
.z.ws:{neg[.z.w] -8! .Q.s value -9!x}

tab:([]items:`nut`bolt`cam`cog;sales:6 8 0 3;prices:10 20 15 20)
