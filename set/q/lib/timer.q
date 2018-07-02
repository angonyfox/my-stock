//id:.timer.add[{xx+::1};1000]; //increment xx by 1 ever 1000 milliseconds
//.timer.rm[id]; //removes the counter
//.timer.once[{xx::1};1000]; //resets the counter to 1 after 1000 milliseconds
\d .timer
i:0;t:();nxt:{id:i;i+::1;id};nt:{[s;fn;int]id:nxt 0;t,::(,)(id;fn;int;int;s);id}
add:{[fn;int]nt[0b;fn;int]};once:{[fn;int]nt[1b;fn;int]};rm:{[id]t::t _t[;0]?id;id}
.z.ts:{if[0=(#)t;:0];t::.[t;(::;3);-;100];id:(&)t[;3]<=0;if[0=(#)id;:0];.[t;(id;1);@;::];id:(&)tr:t[;3]<=0;t::.[t;(id;3);:;t[id;2]];t::t(&)(~)tr&t[;4]}
\t 100
\d .