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
/*
//Многомерный массив студентов:

var students = {
	'boys': ['Коля', 'Вася', 'Петя'],
	'girls': ['Даша', 'Маша', 'Лена'],
};

console.log(students.boys[1])
*/

/*
var a = confirm('Вам уже есть 18 лет?');
if (a) 
    alert("Сила порно в твоих руках!!!");
 else
    alert("Пошел с этого сайта ВОН Щинок!!!!");


var a =-1;
if (a === undefined)  //если переменная a не определена
	alert('Введите a!');
else { //если переменная a НЕ пуста
	if (a > 0) { //спрашиваем, больше ли нуля переменная a
		alert('Больше нуля!'); 
	} else {
		alert('Меньше нуля!'); 
	}
}

*/

/*
var name = prompt('Введите ваше имя:');

switch (name) {
	case 'Антон':
		alert('Таких два в отделе АСУ');
 	break;
	case 'Егор': 
		alert('Молодец');
	break;
	case 'Саша': 
		alert('Ниче такой поцик!:)');
    break;
    case 'Женя': 
    alert('Хороший начальника, епта!:)');
    break;
	default:
		alert('Таких у нас не водится:)'); 
	break;
}
*/


/*
var i = 0;

while (i < 10) {
    i++;
    console.log(i);
}


for (var i = 0; i < 10; i++) {
    alert(i); //выведет 0, 1, 2... 9
}


var arr = [1,2,3,4,5,6,7,100]
for (var i = 0; i <= arr.length-1; i++) {
    console.log(arr[i]);
}




var obj = {Коля: 200, Вася: 300, Петя: 400, Govno: 1000};
for (var key in obj) {
	alert(obj[key]); //выведет 'Коля', 'Вася', 'Петя'
}

*/
//ВЫВОД НА СТРАНИЦУ РЕЗУЛЬТАТА:
var a = 'you_govno1';
document.write(a.replace('gono', 'hello'));
