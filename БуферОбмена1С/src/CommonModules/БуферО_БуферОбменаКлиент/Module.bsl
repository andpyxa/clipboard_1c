Функция ИдентификаторКомпоненты() Экспорт
	Возврат "clipboard1c";
КонецФункции

Функция ОбъектКомпонентыРаботыСБуферомОбмена(ОбъектКомпоненты = Неопределено) Экспорт
	Если ОбъектКомпоненты = Неопределено Тогда
		Возврат КомпонентаРаботыСБуферомОбмена();
	Иначе
		Возврат ОбъектКомпоненты;
	КонецЕсли;
КонецФункции

Функция ПроинициализироватьКомпоненту(ПопытатьсяУстановитьКомпоненту = Истина) Экспорт

	ИмяМакетаКомпоненты="ОбщийМакет.БуферО_КомпонентаДляРаботыСБуферомОбмена";
	КодВозврата = ПодключитьВнешнююКомпоненту(ИмяМакетаКомпоненты, ИдентификаторКомпоненты(),
		ТипВнешнейКомпоненты.Native);

#Если Клиент Тогда
	Если Не КодВозврата Тогда

		Если Не ПопытатьсяУстановитьКомпоненту Тогда
			Возврат Ложь;
		КонецЕсли;

		УстановитьВнешнююКомпоненту(ИмяМакетаКомпоненты);

		Возврат ПроинициализироватьКомпоненту(Ложь); // Рекурсивно.

	КонецЕсли;
#КонецЕсли

	Возврат Новый ("AddIn." + ИдентификаторКомпоненты() + ".ClipboardControl");
КонецФункции

// Функция - Компонента регулярных выражений
//
// Параметры:
//  ВсеСовпадения		 - Булево - Если установлено в Истина, то поиск будет выполняться по всем совпадениям, а не только по первому.
//  ИгнорироватьРегистр	 - Булево - Если установлено в Истина, то поиск будет осуществляться без учета регистра
//  Шаблон				 - Строка - Задает регулярное выражение которое будет использоваться при вызове методов компоненты, 
//									если в метод не передано значение регулярного выражения
//  ВызыватьИсключения	 - Булево - Если установлена в Истина, то при возникновении ошибки, будет вызываться исключение, 
//									при обработке исключения, текст ошибки можно получить из метода ErrorDescription\ОписаниеОшибки
// 
// Возвращаемое значение:
//  ОбъектКомпоненты -"AddIn.RegEx.RegEx". 
//	Неопределено-При неудачной инициализации компоненты 
//
Функция КомпонентаРаботыСБуферомОбмена() Экспорт
	Попытка
		Компонента= ПроинициализироватьКомпоненту(Истина);

		Возврат Компонента;
	Исключение
		ТекстОшибки = НСтр(
			"ru = 'Не удалось подключить внешнюю компоненту для работы с буфером обмена. Подробности в журнале регистрации.'");
		Сообщить(ТекстОшибки + ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки;
КонецФункции

Функция ВерсияПодсистемы() Экспорт
	Возврат "1.0.1.2";
КонецФункции

#Область ПрограммныйИнтерфейс

Функция ВерсияКомпоненты(ОбъектКомпоненты = Неопределено) Экспорт
	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;

	ОбъектКомпоненты=ОбъектКомпонентыРаботыСБуферомОбмена(ОбъектКомпоненты);

	Версия=ОбъектКомпоненты.Версия;

	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;

	Возврат Версия;
КонецФункции

Процедура ОчиститьБуферОбмена(ОбъектКомпоненты = Неопределено) Экспорт
	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;

	ОбъектКомпоненты=ОбъектКомпонентыРаботыСБуферомОбмена(ОбъектКомпоненты);
	ОбъектКомпоненты.Очистить();

	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;

КонецПроцедуры

// Описание
// Помещает переданную картинку в буфер обмена
// 
// Параметры:
// 	Картинка- Картинка, ДвоичныеДанные , АдресВоВременномХранилище
// 	Если передается как адресВоВременномХранилище тип во временном хоранилище должен быть или картинка или двоичные данные
// 	ОбъектКомпоненты - Объект компоненты работы с буфером обмена - Необязательный
Процедура КопироватьКартинкуВБуфер(Картинка, ОбъектКомпоненты = Неопределено) Экспорт
	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;

	Если ТипЗнч(Картинка) = Тип("Строка") И ЭтоАдресВременногоХранилища(Картинка) Тогда

		ТекКартинка=ПолучитьИзВременногоХранилища(Картинка);
	Иначе
		ТекКартинка=Картинка;
	КонецЕсли;

	Если ТипЗнч(ТекКартинка) = Тип("Картинка") Тогда
		ДвоичныеДанные = ТекКартинка.ПолучитьДвоичныеДанные();
	ИначеЕсли ТипЗнч(ТекКартинка) = Тип("ДвоичныеДанные") Тогда
		ДвоичныеДанные=ТекКартинка;
	Иначе
		Сообщить("Неверный тип картинки");
		Возврат;
	КонецЕсли;

	ОбъектКомпоненты=ОбъектКомпонентыРаботыСБуферомОбмена(ОбъектКомпоненты);
	ОбъектКомпоненты.ЗаписатьКартинку(ДвоичныеДанные);

	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;

КонецПроцедуры


// Описание
// получает картинку из буфера обмена в формате PNG
// 
// Параметры:
// 	ОбъектКомпоненты - Неопределено - Описание
// 	ВариантПолучения - Строка - Описание
// 	Один из варинатов
// 	ДвоичныеДанные- получение двоичных данных картинки
// 	Картинка- Преобразованное к типу "Картинка" содержание буфера
// 	Адрес- Адрес двоичных данных картинки во временном хранилище
// Возвращаемое значение:
// 	Неопределено - Описание
Функция КартинкаИзБуфера(ВариантПолучения = "Картинка", ОбъектКомпоненты = Неопределено) Экспорт
	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;

	ОбъектКомпоненты=ОбъектКомпонентыРаботыСБуферомОбмена(ОбъектКомпоненты);
	ДанныеКартинкиВБуфере=ОбъектКомпоненты.Картинка;

	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;

	Если ТипЗнч(ДанныеКартинкиВБуфере) <> Тип("ДвоичныеДанные") Тогда
		Возврат Неопределено;
	КонецЕсли;

	Если НРег(ВариантПолучения) = "двоичныеданные" Тогда
		Возврат ДанныеКартинкиВБуфере;
	ИначеЕсли НРег(ВариантПолучения) = "адрес" Тогда
		Возврат ПоместитьВоВременноеХранилище(ДанныеКартинкиВБуфере);
	Иначе
		Возврат Новый Картинка(ДанныеКартинкиВБуфере);
	КонецЕсли;
КонецФункции

// Описание
// Помещает переданную строку в буфер обмена
// 
// Параметры:
// 	СтрокаКопирования- Тип Строка- Строка, которую необходимо поместить в буфер обмена
// 	ОбъектКомпоненты - Объект компоненты работы с буфером обмена - Необязательный
Процедура КопироватьСтрокуВБуфер(СтрокаКопирования, ОбъектКомпоненты = Неопределено) Экспорт
	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;

	ОбъектКомпоненты=ОбъектКомпонентыРаботыСБуферомОбмена(ОбъектКомпоненты);
	ОбъектКомпоненты.ЗаписатьТекст(СтрокаКопирования);

	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;

КонецПроцедуры

// Описание
// получает текущую строку из буфера обмена 
// 
// Параметры:
// 	ОбъектКомпоненты - Необязательный
// Возвращаемое значение:
// 	ТекстБуфераОбмена - Тип Строка
Функция ТекстИзБуфера(ОбъектКомпоненты = Неопределено) Экспорт
	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;
	
	ОбъектКомпоненты=ОбъектКомпонентыРаботыСБуферомОбмена(ОбъектКомпоненты);
	
	ТекстБуфера=ОбъектКомпоненты.Текст;
	
	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;
	
	Возврат ТекстБуфера;

КонецФункции

// Описание
// Очищает буфер обмена
// 
// Параметры:
// 	ОбъектКомпоненты - Объект компоненты работы с буфером обмена - Необязательный
Процедура ОчиститьБуфер(ОбъектКомпоненты = Неопределено) Экспорт
	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;
	
	ОбъектКомпоненты=ОбъектКомпонентыРаботыСБуферомОбмена(ОбъектКомпоненты);
	ОбъектКомпоненты.Очистить();

	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;

КонецПроцедуры

// Описание
// получает фортмат текущего значения из буфера обмена 
// 
// Параметры:
// 	ОбъектКомпоненты - Необязательный
// Возвращаемое значение:
// 	ФорматБуфераОбмена - Тип Строка
Функция ФорматБуфераОбмена(ОбъектКомпоненты = Неопределено) Экспорт
	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;
	
	ОбъектКомпоненты=ОбъектКомпонентыРаботыСБуферомОбмена(ОбъектКомпоненты);
	
	ФорматБуфера=ОбъектКомпоненты.Формат;
	
	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;
	
	Возврат ФорматБуфера;

	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_Асинхронно

Процедура НачатьПолучениеВерсииКомпоненты(ОписаниеОповещения, ОбъектКомпоненты = Неопределено) Экспорт
	ОбъектКомпоненты=ОбъектКомпонентыРаботыСБуферомОбмена(ОбъектКомпоненты);
	ОбъектКомпоненты.НачатьПолучениеВерсия(ОписаниеОповещения);
КонецПроцедуры

#КонецОбласти