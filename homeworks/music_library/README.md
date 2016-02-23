Домашнее задание Music library
==============================

Требуется написать скрипт, который на вход принимает список файлов музыкальной библиотеки, а на выходе рисует таблицу всех композиций, применив к ним, если нужно, фильтры и сортировку.

Функционал должен быть разумно распределен по модулям, в самом скрипте должен остаться абслютно необходимый минимум. В частности, очевидно, что задача отрисовки таблицы может быть логически отделена от задачи сбора данных и их обработки.

Дополнительно предлагается к получившимся модулям добавить автотесты. Это полностью опциональный пункт, на количество баллов его исполнение не повлияет.

Формат входных данных
---------------------

На вход подается список относительных путей (с ведущими `./`) всех файлов музыкальной библиотеки, начиная с ее корня. Пример:

```
$ find -type f
./Dreams Of Sanity/1999 - Masquerade/The Phantom of the Opera.mp3
./Dreams Of Sanity/1999 - Masquerade/Masquerade Act 1.mp3
./Dreams Of Sanity/1999 - Masquerade/Opera.mp3
./Dreams Of Sanity/1999 - Masquerade/The Maiden and the River.mp3
./Dreams Of Sanity/1999 - Masquerade/Lost Paradise '99.mp3
./Dreams Of Sanity/1999 - Masquerade/Masquerade Act 4.mp3
./Dreams Of Sanity/1999 - Masquerade/Masquerade Act 2.mp3
./Dreams Of Sanity/1999 - Masquerade/Masquerade - Interlude.mp3
./Dreams Of Sanity/1999 - Masquerade/Within (The Dragon).mp3
./Dreams Of Sanity/1999 - Masquerade/Masquerade Act 3.mp3
./Midas Fall/2015 - The Menagerie Inside/Low.ogg
./Midas Fall/2015 - The Menagerie Inside/Holes.ogg
./Midas Fall/2015 - The Menagerie Inside/Push.ogg
./Midas Fall/2015 - The Menagerie Inside/The Morning Asked and I Said 'No'.ogg
./Midas Fall/2015 - The Menagerie Inside/Afterthought.ogg
./Midas Fall/2015 - The Menagerie Inside/Half a Mile Outside.ogg
./Midas Fall/2015 - The Menagerie Inside/Tramadol Baby.ogg
./Midas Fall/2015 - The Menagerie Inside/A Song Built From Scraps of Paper.ogg
./Midas Fall/2015 - The Menagerie Inside/Counting Colours.ogg
./Midas Fall/2015 - The Menagerie Inside/Circus Performer.ogg
```

Путь к каждому файлу стандартизирован: `./группа/год - альбом/трек.формат`.

Формат выходных данных
----------------------

На выходе должна быть изображена таблица со следующими колонками (слева-направо): группа, год, альбом, трек, формат.

Вид таблицы строго определен:

```
/------------------------------------------------------------------------------------\
| Midas Fall | 2015 | The Menagerie Inside |                               Low | ogg |
|------------+------+----------------------+-----------------------------------+-----|
| Midas Fall | 2015 | The Menagerie Inside |                             Holes | ogg |
|------------+------+----------------------+-----------------------------------+-----|
| Midas Fall | 2015 | The Menagerie Inside |                              Push | ogg |
|------------+------+----------------------+-----------------------------------+-----|
| Midas Fall | 2015 | The Menagerie Inside | The Morning Asked and I Said 'No' | ogg |
|------------+------+----------------------+-----------------------------------+-----|
| Midas Fall | 2015 | The Menagerie Inside |                      Afterthought | ogg |
|------------+------+----------------------+-----------------------------------+-----|
| Midas Fall | 2015 | The Menagerie Inside |               Half a Mile Outside | ogg |
|------------+------+----------------------+-----------------------------------+-----|
| Midas Fall | 2015 | The Menagerie Inside |                     Tramadol Baby | ogg |
|------------+------+----------------------+-----------------------------------+-----|
| Midas Fall | 2015 | The Menagerie Inside | A Song Built From Scraps of Paper | ogg |
|------------+------+----------------------+-----------------------------------+-----|
| Midas Fall | 2015 | The Menagerie Inside |                  Counting Colours | ogg |
|------------+------+----------------------+-----------------------------------+-----|
| Midas Fall | 2015 | The Menagerie Inside |                  Circus Performer | ogg |
\------------------------------------------------------------------------------------/
```

Для пустот используются только пробелы. Ширина колонки задается самым длинным значением, оно должно отступать от краев на один пробел (слева и справа). Остальные значения выравниваются по правому краю ячейки (отступая от него на один пробел). Для границ используются только символы `/\-+|` по следующим правилам:

| Символ | Когда использовать |
|---|---|
| / | `┏` `┛`  |
| \ | `┓` `┗`  |
| - | `┻` `━` `┳`  |
| + | `╋`  |
| \| |  `┫` `┃` `┣` |

В случае, если в таблице нет ни одной строки, ничего выводить не надо.

Параметры
---------

Параметры задаются скрипту ключами запуска, для их обработки следует использовать [Getopt::Long](https://metacpan.org/pod/Getopt::Long).

| Параметр | Смысл |
|----------|------------|
| --band BAND | Оставить только композиции группы BAND |
| --year YEAR | Оставить только композиции с альбомов года YEAR |
| --album ALBUM | Оставить только композиции с альбомов с именем ALBUM |
| --track TRACK | Оставить только композиции с именем TRACK |
| --format FORMAT | Оставить только композиции в формате FORMAT |
| --sort band\|year\|album\|track\|format | Сортировать по возврастанию указанного параметра |

Необходимо учесть, что фильтрация и сортировка по году должна выполняться с учетом того, что год — это целое число, а не строка. (Однако выводить год в таблице следует без изменений: так, как он указан в имени файла.)