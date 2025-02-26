Перем Типы;
Перем Токены;
Перем Исходник;
Перем ТаблицаТокенов;
Перем ТаблицаОшибок;
Перем ТаблицаЗамен;
Перем Стек;
Перем Счетчики;
Перем Директивы;
Перем Аннотации;
Перем СимволыПрепроцессора;

Перем Результат;
Перем ПрефиксПеременных;
Перем ЭтоМодульФормы;
Перем ЭтоГлавнаяОбработка;
Перем ЭтоКлиентскийОбщийМодуль;
Перем ТекстСтроковыхФункцийРежимСовместимости;
Перем ОписаниеРасширения;

// Перем КаталогИсходныхФайловРасширения;

Перем УстановилиОбъявлениеСпискаПеременных;

Процедура Открыть(Парсер, Параметры) Экспорт
	
	Типы = Парсер.Типы();
	Токены = Парсер.Токены();
	Исходник = Парсер.Исходник();
	ТаблицаТокенов = Парсер.ТаблицаТокенов();
	ТаблицаОшибок = Парсер.ТаблицаОшибок();
	ТаблицаЗамен = Парсер.ТаблицаЗамен();
	Стек = Парсер.Стек();
	Счетчики = Парсер.Счетчики();
	Директивы = Парсер.Директивы();
	Аннотации = Парсер.Аннотации();
	СимволыПрепроцессора = Парсер.СимволыПрепроцессора();
	
	Результат = Новый Массив;
	
	ЭтоМодульФормы = Параметры.ЭтоМодульФормы;
	ЭтоГлавнаяОбработка = Параметры.ЭтоГлавнаяОбработка;
	ПрефиксПеременных = Параметры.ПрефиксПеременныхИПроцедур;
	ЭтоКлиентскийОбщийМодуль = Параметры.ЭтоКлиентскийОбщийМодуль;

	Если ЭтоМодульФормы Тогда
		ТекстСтроковыхФункцийРежимСовместимости= Параметры.ТекстыСтроковыхФункцияДляСовместимости.МодульФормы;
	Иначе
		ТекстСтроковыхФункцийРежимСовместимости= Параметры.ТекстыСтроковыхФункцияДляСовместимости.Модуль;
	КонецЕсли;

	ОписаниеРасширения= Параметры.ОписаниеРасширения;
КонецПроцедуры

Функция Закрыть() Экспорт
	// ...
	Возврат СтрСоединить(Результат);
КонецФункции

Функция Подписки() Экспорт
	Перем Подписки;
	Подписки = Новый Массив;
	Подписки.Добавить("ПосетитьОбъявления");
	Подписки.Добавить("ПосетитьМодуль");
	Возврат Подписки;
КонецФункции

#Область РеализацияПодписок

Процедура ПосетитьОбъявлениеСпискаПеременныхМодуля(Объявление) Экспорт
	Если УстановилиОбъявлениеСпискаПеременных = Истина Тогда
		Возврат;
	КонецЕсли;
	УстановилиОбъявлениеСпискаПеременных=Истина;

	КодДляВставки = "
	// |&НаКлиенте
	// |Перем "+ПрефиксПеременных+"МестоположениеОбработки;
	|"+?(ЭтоМодульФормы,"&НаКлиенте","")+"
	|Перем "+ПрефиксПеременных+"КэшОбщихМодулей;
	|";
	ПозицияВставки = Объявление.Начало.Позиция;
	
	Если Объявление.Тип = Типы.ОбъявлениеСпискаПеременныхМодуля Тогда
		Если Объявление.Директивы.Количество() > 0 Тогда
			ПозицияВставки = Объявление.Директивы[0].Начало.Позиция;
		КонецЕсли;
	ИначеЕсли Объявление.Тип = Типы.ОбъявлениеМетода Тогда
		Если Объявление.Сигнатура.Директивы.Количество() > 0 Тогда
			ПозицияВставки = Объявление.Сигнатура.Директивы[0].Начало.Позиция;
		КонецЕсли;
	КонецЕсли;
	
	Вставка(КодДляВставки, ПозицияВставки);
КонецПроцедуры // ПосетитьОбъявлениеСпискаПеременныхМодуля()

Процедура ПосетитьОбъявления(Объявления) Экспорт
	ЕстьОбъявлениеПеременныхМодуля=Ложь;
	Для Каждого ТекОбъявление Из Объявления Цикл
		Если ТекОбъявление.Тип = Типы.ОбъявлениеСпискаПеременныхМодуля Тогда
			ПосетитьОбъявлениеСпискаПеременныхМодуля(ТекОбъявление);
			ЕстьОбъявлениеПеременныхМодуля=Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьОбъявлениеПеременныхМодуля и Объявления.Количество()>0 Тогда
		ПосетитьОбъявлениеСпискаПеременныхМодуля(Объявления[0]);
	КонецЕсли;
КонецПроцедуры // ПосетитьОбъявления()

Функция ТекстОпределенияПеременныхОбщихМодулей()

	Если ЭтоМодульФормы Тогда
		ТекстПроцедур = "
		|&НаКлиентеНаСервереБезКонтекста
		|Функция " + ПрефиксПеременных + "ОбщийМодульПоИмени(ИмяМодуля, УИ_ГЕНЕРАЦИЯ_КэшОбщихМодулей=Неопределено, Форма = Неопределено)
		|";

	Иначе
		ТекстПроцедур = "
		|Функция " + ПрефиксПеременных + "ОбщийМодульПоИмени(ИмяМодуля)
		|";

	КонецЕсли;

	ТекстПроцедур = ТекстПроцедур+ "
	|
	|	Если УИ_ГЕНЕРАЦИЯ_КэшОбщихМодулей=Неопределено Тогда
	|		УИ_ГЕНЕРАЦИЯ_КэшОбщихМодулей=Новый Соответствие;
	|	КонецЕсли;
	|
	|";
	Если ЭтоМодульФормы Тогда
		ТекстПроцедур = ТекстПроцедур + "
		|	#Если Клиент Тогда
		|		Если УИ_ГЕНЕРАЦИЯ_КэшОбщихМодулей[НРег(ИмяМодуля)]<>Неопределено Тогда
		|			Возврат УИ_ГЕНЕРАЦИЯ_КэшОбщихМодулей[НРег(ИмяМодуля)];
		|		КонецЕсли;
		|	#КонецЕсли
		|
		| 	#Если ТолстыйКлиентУправляемоеПриложение ИЛИ ТолстыйКлиентОбычноеПриложение  Тогда 
		|	Если "+ПрефиксПеременных+"ЭтоФайловаяБаза() Тогда
		|		ОбщийМодуль=ВнешниеОбработки.Создать(ИмяМодуля);
		|	Иначе
		|		ОбщийМодуль=ПолучитьФорму(""ВнешняяОбработка.""+ИмяМодуля+"".Форма"",,,Ложь);
		|	КонецЕсли;
		|	УИ_ГЕНЕРАЦИЯ_КэшОбщихМодулей.Вставить(НРег(ИмяМодуля),ОбщийМодуль);
		|	#ИначеЕсли Клиент Тогда
		|
		|	ОбщийМодуль=ПолучитьФорму(""ВнешняяОбработка.""+ИмяМодуля+"".Форма"",,,Ложь);
		|	УИ_ГЕНЕРАЦИЯ_КэшОбщихМодулей.Вставить(НРег(ИмяМодуля),ОбщийМодуль);
		|	#Иначе
		|	ОбщийМодуль=ВнешниеОбработки.Создать(ИмяМодуля);
		|	#КонецЕсли";
	Иначе

		Если ЭтоГлавнаяОбработка Тогда
			ТекстПроцедур = ТекстПроцедур + "
			|	Если Не ЭтоАдресВременногоХранилища(ЭтотОбъект.ИспользуемоеИмяФайла) Тогда
			|		Попытка
			|			ОбщийМодуль=ВнешниеОбработки.Создать(ИмяМодуля);
			|		Исключение
			|			"+ПрефиксПеременных+"ПодключитьОбщиеМодули();
			|		КонецПопытки;
			|	КонецЕсли;
			|";
		КонецЕсли;
		ТекстПроцедур=ТекстПроцедур+"
		| 	ОбщийМодуль=ВнешниеОбработки.Создать(ИмяМодуля);
		|	УИ_ГЕНЕРАЦИЯ_КэшОбщихМодулей.Вставить(НРег(ИмяМодуля),ОбщийМодуль);
		|";
	КонецЕсли;
	ТекстПроцедур = ТекстПроцедур + "
		|
	|	Возврат ОбщийМодуль;
	|КонецФункции
	|
	|"+?(ЭтоМодульФормы,"&НаСервереБезКонтекста","")+"
	|Функция "+ПрефиксПеременных+"УИ_БиблиотекаКартинок()
	|	АдресБиблиотеки=УИ_ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(УИ_ОбщегоНазначенияКлиентСервер.КлючОбъектаВХранилищеНастроек(), ""АдресЛокальнойБиблиотекиКартинок"", , ,
	|		ИмяПользователя());
	|
	|	Возврат ПолучитьИзВременногоХранилища(АдресБиблиотеки);
	|КонецФункции
	|
	|// Возвращает флаг того, что работа происходит в файловой базе
	|"+?(ЭтоМодульФормы,"&НаКлиентеНаСервереБезКонтекста","")+"
	|Функция "+ПрефиксПеременных+"ЭтоФайловаяБаза() Экспорт
	|	Возврат Найти(СтрокаСоединенияИнформационнойБазы(), ""File="") > 0;
	|КонецФункции
	|";

	ТекстПроцедур=ТекстПроцедур+ТекстСтроковыхФункцийРежимСовместимости+Символы.ПС;

	Если ЭтоМодульФормы Или ЭтоКлиентскийОбщийМодуль Тогда
		Если ЭтоМодульФормы Тогда
			ТекстПроцедур=ТекстПроцедур+"
			|&НаКлиенте";
		ИначеЕсли ЭтоКлиентскийОбщийМодуль Тогда
			ТекстПроцедур=ТекстПроцедур+"
			|#Если Клиент Тогда";
		КонецЕсли;

		ТекстПроцедур = ТекстПроцедур + "
			|Функция "+ПрефиксПеременных+"УИ_ПараметрыПриложения()
			|Окна=ПолучитьОкна();
			|
			|Для Каждого ТекОкно ИЗ Окна Цикл
			|	Для Каждого Форма ИЗ ТекОкно.Содержимое Цикл
			|		Если ТипЗнч(Форма)<>УИ_ОбщегоНазначенияКлиентСервер.ТипУправляемойФормы() Тогда
			|			Продолжить;
			|		КонецЕсли;
			|
			|		Если Форма.ИмяФормы=""ВнешняяОбработка.УИ_ПортативныеУниверсальныеИнструменты.Форма.Форма"" Тогда
			|			Возврат Форма.УИ_ПараметрыПриложения_Портативные;
			|		КонецЕсли;
			|	КонецЦикла;
			|КонецЦикла;
			|
			|Возврат Новый Соответствие;
			|
			|КонецФункции
			|
			|";

			Если ЭтоКлиентскийОбщийМодуль Тогда
				ТекстПроцедур=ТекстПроцедур+"
				|#КонецЕсли";
			КонецЕсли;
	КонецЕсли;

	Если Не ЭтоМодульФормы И ЭтоГлавнаяОбработка Тогда
		ТекстПроцедур=ТекстПроцедур+"
		|	Функция "+ПрефиксПеременных+"СтруктураОбщихМодулей()
		|		Структура=Новый Структура;
		|";

		Для Каждого ОбщийМодуль Из ОписаниеРасширения.ОбщиеМодули Цикл
			ТекстПроцедур=ТекстПроцедур+"
			|		Структура.Вставить("""+ОбщийМодуль.Имя+""","""+ОбщийМодуль.Имя+".epf"");";
		КонецЦикла;

		ТекстПроцедур=ТекстПроцедур+"
		|		Возврат Структура;
		|	КонецФункции
		|
		|	Процедура "+ПрефиксПеременных+"ПодключитьОбщиеМодули()
		|		РазделительПути=ПолучитьРазделительПути();
		|
		|		МассивИмени=_СтрРазделить(ЭтотОбъект.ИспользуемоеИмяФайла,ПолучитьРазделительПути());
		|		МассивИмени.Удалить(МассивИмени.Количество()-1);
		|		МассивИмени.Добавить(""ОбщиеМодули"");
		|		
		|		ОписаниеЗащитыОтОпасныхДействиях=Новый ОписаниеЗащитыОтОпасныхДействий;
		|		ОписаниеЗащитыОтОпасныхДействиях.ПредупреждатьОбОпасныхДействиях=Ложь;
		|		
		|		ИмяКаталогаОбщихМодулей= _СтрСоединить(МассивИмени, РазделительПути);
		|		СтруктураОбщихМодулей="+ПрефиксПеременных+"СтруктураОбщихМодулей();
		|		
		|		Для каждого КлючЗначение Из СтруктураОбщихМодулей Цикл
		|			ИмяФайлаМодуля=ИмяКаталогаОбщихМодулей+РазделительПути+КлючЗначение.Значение;
		|			ДД=Новый ДвоичныеДанные(ИмяФайлаМодуля);
		|			Адрес=ПоместитьВоВременноеХранилище(ДД);
		|			ВнешниеОбработки.Подключить(Адрес, ,Ложь, ОписаниеЗащитыОтОпасныхДействиях);
		|		КонецЦикла;
		|
		|
		|	КонецПроцедуры
		|";
	КонецЕсли;

	ТекстПроцедур=Символы.ПС+ТекстПроцедур+Символы.ПС;
	Возврат ТекстПроцедур;
КонецФункции

Процедура ПосетитьМодуль(Модуль) Экспорт
	Позиция=Неопределено;
	КоличествоОбъявлений=Модуль.Объявления.Количество();
	Для НомерОбъявления=1 По КоличествоОбъявлений Цикл
		ТекОбъявление=Модуль.Объявления[КоличествоОбъявлений-НомерОбъявления];
		Если ТекОбъявление.Тип=Типы.ИнструкцияПрепроцессораЕсли
			Или ТекОбъявление.Тип=Типы.ИнструкцияПрепроцессораИначеЕсли Тогда
			Продолжить;
		КонецЕсли;
		Позиция=ТекОбъявление.Конец.Позиция+ТекОбъявление.Конец.Длина;
		Прервать;

	КонецЦикла;

	Если Позиция=Неопределено Тогда
		Если Модуль.Операторы.Количество() > 0 Тогда
			Позиция=Модуль.Операторы[0].Начало.Позиция;
		КонецЕсли;
	КонецЕсли;

	Если Позиция=Неопределено Тогда
		Возврат;
	КонецЕсли;

	Вставка(ТекстОпределенияПеременныхОбщихМодулей(), Позиция);
	// Если Модуль.Операторы.Количество() > 0 Тогда
	// 	Вставка(ТекстОпределенияПеременныхОбщихМодулей(), Модуль.Операторы[0].Начало.Позиция);
	// ИначеЕсли Модуль.Объявления.Количество() > 0 Тогда
	// 	Вставка(ТекстОпределенияПеременныхОбщихМодулей(), Модуль.Объявления[Модуль.Объявления.Количество() - 1].Конец.Позиция + Модуль.Объявления[Модуль.Объявления.Количество() - 1].Конец.Длина);
	// КонецЕсли;
КонецПроцедуры

#КонецОбласти

Процедура Ошибка(Текст, Начало, Конец = Неопределено, ЕстьЗамена = Ложь)
	Ошибка = ТаблицаОшибок.Добавить();
	Ошибка.Источник = "ДобавлениеВызововОбщихМодулей";
	Ошибка.Текст = Текст;
	Ошибка.ПозицияНачала = Начало.Позиция;
	Ошибка.НомерСтрокиНачала = Начало.НомерСтроки;
	Ошибка.НомерКолонкиНачала = Начало.НомерКолонки;
	Если Конец = Неопределено Или Конец = Начало Тогда
		Ошибка.ПозицияКонца = Начало.Позиция + Начало.Длина;
		Ошибка.НомерСтрокиКонца = Начало.НомерСтроки;
		Ошибка.НомерКолонкиКонца = Начало.НомерКолонки + Начало.Длина;
	Иначе
		Ошибка.ПозицияКонца = Конец.Позиция + Конец.Длина;
		Ошибка.НомерСтрокиКонца = Конец.НомерСтроки;
		Ошибка.НомерКолонкиКонца = Конец.НомерКолонки + Конец.Длина;
	КонецЕсли;
	Ошибка.ЕстьЗамена = ЕстьЗамена;
КонецПроцедуры

Процедура Замена(Текст, Начало, Конец = Неопределено)
	НоваяЗамена = ТаблицаЗамен.Добавить();
	НоваяЗамена.Источник = "ДобавлениеВызововОбщихМодулей";
	НоваяЗамена.Текст = Текст;
	НоваяЗамена.Позиция = Начало.Позиция;
	Если Конец = Неопределено Тогда
		НоваяЗамена.Длина = Начало.Длина;
	Иначе
		НоваяЗамена.Длина = Конец.Позиция + Конец.Длина - Начало.Позиция;
	КонецЕсли;
КонецПроцедуры

Процедура Вставка(Текст, Позиция)
	НоваяЗамена = ТаблицаЗамен.Добавить();
	НоваяЗамена.Источник = "ДобавлениеВызововОбщихМодулей";
	НоваяЗамена.Текст = Текст;
	НоваяЗамена.Позиция = Позиция;
	НоваяЗамена.Длина = 0;
КонецПроцедуры

УстановилиОбъявлениеСпискаПеременных=Ложь;