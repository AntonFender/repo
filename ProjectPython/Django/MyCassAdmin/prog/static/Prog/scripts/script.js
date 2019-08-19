'use strict';

/*
var a; //Объявили переменную
var a2, a2, a3; //Объявили группу переменных
var b = 3; // Присвоение переменной значения
*/

//Многострочный комментарий:

/*
let second = 2;
const pi = 3.14;

let person = {
    name: "John",
    age:"25",
    isMarried: false
};

console.log("Имя:" + person.name, ", Возраст:" + person.age, ", Умер:" + person.isMarried);

let arr = ['plumm.png', 'orange.jpg','apple.bmp'];

console.log(arr[0])
*/

//Вывести фразу на экран!

/*
alert("Привет , Мир!!!");

var text = 'Привет, мир!';
alert(text); //выведет на экран фразу 'Привет, мир!'
*/

/*
var a; //объявим наши переменные
a = 1;
a = a + 13;
console.log(a);
*/

//Спрашивает имя, мы его вводим, и выдает результат в виде моего имени:


/*
var name = prompt('Ваше имя?');
alert('Ваше имя: '+name);
*/

/*
var ok = confirm('Вам уже есть 18 лет?');
var ok1 = confirm('Хочешь Амлет?');
var answer = "Ладно можешь далше работать!"
alert(answer);
*/

/*
var arr = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'];
console.log(arr[2]);

var obj = {key1: 200, key2: 300, key2: 400};
console.log(obj['key1']); //выведет 200

var arr = Array('пн', 256, 'ср', 34, 38, 'сб', 95);
console.log(arr); //выведет 200

*/


//var obj = new Object(key1: 200, key2: 300, key3: 400);

/*

var arr = []
arr[0] = 1;
arr[1] = 2;
arr[2] = 3;
alert(arr) //с помощью alert выводим содержимое массива

var obj = {};
obj['Коля'] = 100;
obj['Вася'] = 200;
obj['Петя'] = 300;
alert(obj.Коля) //с помощью alert выводим содержимое массива

*/

//Многомерный массив студентов:
var students = {
	'boys': ['Коля', 'Вася', 'Петя'],
	'girls': ['Даша', 'Маша', 'Лена'],
};

console.log(students.boys[1])