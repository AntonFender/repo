'use strict';

<<<<<<< HEAD
var arr = [12, 19, 28, 13, 14, 345];
var result = [];

for (var i = 0; i < 10; i++) {
	if (inRange(arr[i])) {
		result.push(arr[i]);
	}
}
console.log(result);

function inRange(num) {
	var sum = arraySum(getDigits(num));
	return sum >= 1 && sum <= 9;
}

function getDigits(num) {
	return String(num).split('');
}

function arraySum(arr) {
	var sum = 0;
	for (var i = 0; i < arr.length; i++) {
		sum += Number(arr[i]);
	}

	return sum;
=======
var arr = [];
for (var i = 0; i < 40; i++) {
	arr.push('x');
>>>>>>> 69cabe658e615a593f7f4b939c568ef4d3b670a4
}

console.log(arr);