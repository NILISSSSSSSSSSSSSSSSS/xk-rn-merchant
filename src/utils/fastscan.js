!function(){"use strict";function t(t){this.root=function(t){t=function(t){t=(t=t.map(function(t){return t.trim()})).filter(function(t){return t.length>0});for(var n={},r=[],e=0;e<t.length;e++){var o=t[e];n[o]||(n[o]=!0,r[r.length]=o)}return r.sort()}(t);for(var r={next:{},val:null,back:null,parent:null,depth:0,accept:!1},e=0;e<t.length;e++)n(r,t[e]);return function(t){for(var n=Object.values(t.next);n.length>0;){for(var r=[],e=0;e<n.length;e++){var o=n[e];for(var a in o.next)r.push(o.next[a]);for(var u=o.parent,i=u.back;null!=i;){var f=i.next[o.val];if(f){o.back=f;break}i=i.back}}n=r}}(r),r}(t)}function n(t,n){for(var r=t,e=0;e<n.length;e++){var o=n[e];r.next[o]||(r.next[o]={next:{},val:o,accept:!1,back:t,parent:r,depth:r.depth+1}),r=r.next[o]}r.accept=!0}function r(t){for(var n=[];null!=t.val;)n.unshift(t.val),t=t.parent;return n.join("")}t.prototype.add=function(t){0!=(t=t.trim()).length&&(n(this.root,t),function(t,n){for(var r=t.next[n[0]],e=1;e<n.length;e++){for(var o=n[e],a=r.parent.back;null!=a;){var u=a.next[r.val];if(u){r.back=u;break}a=a.back}r=r.next[o]}}(this.root,t))},t.prototype.locate=function(t){for(var n=this.root.next[t[0]],r=1;r<t.length;r++){var e=t[r];if(null==(n=n.next[e]))break}return n},t.prototype.hits=function(t,n){for(var r=this.search(t,n),e={},o=0;o<r.length;o++){var a=r[o][1],u=e[a]||0;e[a]=u+1}return e},t.prototype.search=function(t,n){var e=[],o=this.root;n=n||{};for(var a=0;a<t.length;a++){var u=t[a],i=o.next[u];if(!i)for(var f=o.back;null!=f&&!(i=f.next[u]);)f=f.back;if(i){f=i;do{if(f.accept){var c=r(f);if(e.push([a-c.length+1,c]),n.quick)return e}f=f.back}while(f!=this.root);o=i}else o=this.root}return n.longest?function(t){for(var n={},r=0;r<t.length;r++){var e=t[r],o=n[e[0]];(!o||o.length<e[1].length)&&(n[e[0]]=e[1])}return Object.keys(n).map(function(t){return parseInt(t)}).sort(function(t,n){return t-n}).map(function(t){return[t,n[t]]})}(e):e},"undefined"!=typeof module&&void 0!==module.exports?module.exports=t:"function"==typeof define&&define.amd?define([],function(){return t}):window.FastScanner=t}();