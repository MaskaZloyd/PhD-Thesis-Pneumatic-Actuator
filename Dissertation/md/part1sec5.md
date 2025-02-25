# Анализ задач разгона и торможения в контексте системы управления {#sec:ch1/sec5}

В настоящее время, благодаря стремительному развитию микроэлектроники и
её применению в различных областях, стало возможным использование
сложных алгоритмов управления. Эти достижения позволяют решать вопросы,
которые были исследованы ранее, при помощи разнообразных алгоритмов
управления.

Однако применение алгоритмов управления, предназначенных для непрерывных
систем, к системам с дискретными элементами может быть затруднительным
или даже невозможным. Для использования ПИД-регулятора исследователи
применяют различные преобразователи и модуляции сигнала. Например,
широко распространено использование широтно-импульсной модуляции (ШИМ) в
сочетании с ПИД.

Аналогично, инженеры используют разнообразные интеллектуальные алгоритмы
управления на основе нейросетей или нечёткой логики. Также особую
популярность получило управление в скользящих режимах, которое
зарекомендовало себя в управлении электроприводом. Это связано с тем,
что модель представляет собой дискретную систему.

## Исследование управления с использованием ШИМ {#subsec:ch1/sec5/subsec1}

В работе [-@pwm:Varseveld] подробно рассмотрена разработка системы
позиционного ПП, схема которого представлена на рисунке
[1](#fig:позиционный_пп_pwm){reference-type="ref"
reference="fig:позиционный_пп_pwm"}, с использованием недорогих
дискретных распределителей с электромагнитным управлением, вместо
дорогостоящих пропорциональных. Особое внимание уделено проектированию
системы управления, обеспечивающей высокое быстродействие и точность
позиционирования.

<figure id="fig:позиционный_пп_pwm">

<figcaption>Схема позиционного ПП с дискретными
распределителями</figcaption>
</figure>

Авторами предложен новый алгоритм с использованием широтно-импульсной
модуляции (ШИМ) для управления распределителями, позволяющий получить
практически симметричную и линейную характеристику скорости РО ПП в
зависимости от управляющего сигнала. Это достигается за счет
согласованного управления магистральными и выхлопными распределителями,
что компенсирует асимметрию, вызванную разницей активных площадей поршня
в поршневой и штоковой полостях. Экспериментальные исследования
подтвердили высокую линейность и симметрию полученной характеристики.

На основе экспериментальных данных авторами синтезирована линейная
авторегрессионная модель ПП. Анализ модели показал, что демпфирование
системы существенно зависит от положения поршня, достигая минимума в
центральной части хода. Это объясняется наличием сухого кулоновского
трения.

Для компенсации влияния трения в систему управления введен ПИД-регулятор
с дополнительной компенсацией трения и интегральной составляющей
ограниченной с двух сторон. Применение этих мер позволило существенно
уменьшить статическую ошибку позиционирования.

В ходе экспериментальных исследований авторам удалось достичь высокого
быстродействия системы управления -- время нарастания составило всего
180 ms. При этом статическая ошибка позиционирования не превышала 0,21 
mm, что сопоставимо с результатами, полученными другими исследователями
[-@Varseveld:article1; -@Varseveld:article2; -@Varseveld:article3; -@Surgenor1997ContinuousSM],
использовавшими более дорогостоящие пропорциональные распределители.
Кроме того, система продемонстрировала инвариантность к шестикратному
изменению инерционной нагрузки. Авторы также показали возможность
точного отслеживания $S$-образных траекторий с ошибкой не более 2 mm.

Статья [-@Shiee] посвящена сравнительному анализу различных схем ШИМ для
улучшения позиционирования ПП. Авторы рассматривают пять основных
ШИМ-схем представленных на рисунке
[2](#fig:схемы_шим){reference-type="ref" reference="fig:схемы_шим"}.

<figure id="fig:схемы_шим">

<figcaption>Схемы ШИМ</figcaption>
</figure>

Схема [\[fig:схемы_шим-1\]](#fig:схемы_шим-1){reference-type="ref+label"
reference="fig:схемы_шим-1"} не учитывает динамику включения/выключения
распределителей, что приводит к нелинейностям при крайних значениях
входного сигнала. Схема
[\[fig:схемы_шим-2\]](#fig:схемы_шим-2){reference-type="ref+label"
reference="fig:схемы_шим-2"} учитывает только динамику включения
распределителей и добавляет точку перегиба, чтобы минимизировать ширину
импульса ниже определенного значения. Схема
[\[fig:схемы_шим-3\]](#fig:схемы_шим-3){reference-type="ref+label"
reference="fig:схемы_шим-3"} учитывает как задержку включения, так и
задержку выключения распределителей, вводя два пограничных значения для
ширины импульса. Схема
[\[fig:схемы_шим-4\]](#fig:схемы_шим-4){reference-type="ref+label"
reference="fig:схемы_шим-4"} является модифицированным вариантом схемы
[\[fig:схемы_шим-1\]](#fig:схемы_шим-1){reference-type="ref+label"
reference="fig:схемы_шим-1"}, учитывающим задержки клапанов, и
обеспечивает меньшую сумму коэффициентов заполнения сигнала поступающего
на распределитель, особенно вблизи нулевого входного сигнала. Схема
[\[fig:схемы_шим-5\]](#fig:схемы_шим-5){reference-type="ref+label"
reference="fig:схемы_шим-5"} представляет собой модификацию схемы
[\[fig:схемы_шим-3\]](#fig:схемы_шим-3){reference-type="ref+label"
reference="fig:схемы_шим-3"} с учетом задержек включения и выключения
клапанов, давая большую суммарную ширину импульса вблизи нулевого входа.

Авторы провели ряд экспериментов со ступенчатыми и гармоническими
входными воздействиями, чтобы изучить характеристики различных ШИМ-схем.
По характеристикам позиционирования при ступенчатом входе, схема
[\[fig:схемы_шим-1\]](#fig:схемы_шим-1){reference-type="ref+label"
reference="fig:схемы_шим-1"} показала наименьшее время нарастания, но
большую статическую ошибку позиционирования, схема
[\[fig:схемы_шим-4\]](#fig:схемы_шим-4){reference-type="ref+label"
reference="fig:схемы_шим-4"} продемонстрировала наименьшее
перерегулирование, но худшую ошибку, а схема
[\[fig:схемы_шим-5\]](#fig:схемы_шим-5){reference-type="ref+label"
reference="fig:схемы_шим-5"} имела самое большое время нарастания и
ошибку. При отслеживании гармонического сигнала, первые три схемы
показали близкие результаты по среднеквадратичной ошибке, в то время как
схемы [\[fig:схемы_шим-4\]](#fig:схемы_шим-4){reference-type="ref+label"
reference="fig:схемы_шим-4"} и
[\[fig:схемы_шим-5\]](#fig:схемы_шим-5){reference-type="ref+label"
reference="fig:схемы_шим-5"} имели большую ошибку слежения. Эксперименты
с увеличением нагрузки показали, что схема
[\[fig:схемы_шим-4\]](#fig:схемы_шим-4){reference-type="ref+label"
reference="fig:схемы_шим-4"} оказалась наименее устойчивой к увеличению
инерционной нагрузки, а схема
[\[fig:схемы_шим-5\]](#fig:схемы_шим-5){reference-type="ref+label"
reference="fig:схемы_шим-5"}, имеющая высокое рабочее давление,
продемонстрировала наибольшую устойчивость.

Чтобы компенсировать влияние различий в эффективных площадях, авторы
предложили модифицированные версии каждой ШИМ-схемы. Модификация
заключается в сдвиге диаграмм ШИМ-схем с целью достижения нулевой
выходной силы при нулевом входном сигнале.

Экспериментальные результаты при ступенчатом входном воздействии
продемонстрировали, что модифицированные ШИМ-схемы, особенно для схем
[\[fig:схемы_шим-1\]](#fig:схемы_шим-1){reference-type="ref+label"
reference="fig:схемы_шим-1"},
[\[fig:схемы_шим-2\]](#fig:схемы_шим-2){reference-type="ref+label"
reference="fig:схемы_шим-2"},
[\[fig:схемы_шим-3\]](#fig:схемы_шим-3){reference-type="ref+label"
reference="fig:схемы_шим-3"} и
[\[fig:схемы_шим-5\]](#fig:схемы_шим-5){reference-type="ref+label"
reference="fig:схемы_шим-5"}, обеспечивают значительное улучшение
характеристик позиционирования, в частности, снижение статической ошибки
позиционирования. Это связано с тем, что при высоких рабочих давлениях
различия в эффективных площадях поршня становятся более значимыми, и
предложенные модификации эффективно компенсируют этот эффект.

В следующей статье [-@Tran:pwm] авторами представлен модифицированный
метод позиционного управления ПП с использованием четырех дискретных
электромагнитных распределителей, схема ПП аналогична схеме
представленной на рисунке
[1](#fig:позиционный_пп_pwm){reference-type="ref+label"
reference="fig:позиционный_пп_pwm"}.

Первоначально в работе проведен анализ алгоритма, разработанного другим
автором [-@Truong] в 2007 году. Установлено, что данный алгоритм
демонстрирует существенное перерегулирование при задании малых положений
поршня, что обусловливает необходимость дальнейшего совершенствования
методов управления.

С целью повышения качества позиционирования авторами была предложена
модификация алгоритма. Ключевым аспектом модификации стало разделение
диапазона задаваемых положений на две области: малые положения
$(x_d \leqslant \text{50}~\si{\milli\metre})$ и большие положения
$(x_d > \text{50}~\si{\milli\metre})$. Для каждой области авторами
разработаны индивидуальные законы управления с использованием семи
различных режимов работы четырех электромагнитных распределителей в
сочетании с ШИМ.

Для диапазона малых положений при значительной ошибке позиционирования
$e \leqslant -\alpha$ авторами введен новый режим $M_6$, предполагающий
одновременное открытие двух распределителей, что обеспечивало плавное
низкоскоростное движение. В области промежуточных ошибок
$-\alpha < e < -\beta$ применялся режим $M_2$ с импульсным открытием
одного из распределителей, способствующий быстрому замедлению движения и
устранению перерегулирования.

Для диапазона больших положений авторами модифицированы режимы $M_2$ и
$M_2$ контроллера посредством организации поочередного импульсного
открытия распределителей. Данный подход позволял плавно замедлять
движение поршня.

Экспериментальные исследования подтвердили, что модифицированный
алгоритм обеспечивает существенное улучшение качества позиционного
управления по сравнению с исходным алгоритмом, особенно при отработке
малых положений. Более того, при частотах задающего воздействия до
0.1 Hz модифицированный алгоритм продемонстрировал сопоставимые или
превосходящие характеристики относительно алгоритма для ПП с
пропорциональными распределителями. Однако при более высоких частотах
(например, 0.5 Hz) характеристики модифицированного алгоритма
значительно ухудшались, что связано с ограниченной скоростью
переключения используемых распределителей.

Таким образом, результаты проведенного исследования свидетельствуют о
том, что предложенный модифицированный алгоритм позволяет существенно
повысить качество позиционного управления пневматическим приводом с
дискретными распределителями при низких и средних частотах задающего
воздействия по сравнению с ранее разработанными решениями.

В следующей работе [-@AHN2005683] так же представлен подход к разработке
системы управления ПП с использованием дискретных электромагнитных
распределителей вместо традиционных пропорциональных распределителей.
Авторы предлагают модифицированный алгоритм ШИМ для точного позиционного
управления ПП при помощи этих дискретных распределителей.

Центральным элементом разработанной системы управления является
трехконтурная схема, представленная на рисунке
[3](#fig:mpwm_lvqnn){reference-type="ref+label"
reference="fig:mpwm_lvqnn"},

<figure id="fig:mpwm_lvqnn">

<figcaption>Структурная схема системы управления с МШИМ и
LVQNN</figcaption>
</figure>

с обратной связью по положению, скорости и ускорению. Такая структура
обеспечивает высокое быстродействие и точность позиционирования. Для
адаптации параметров регулятора к изменяющимся внешним нагрузкам авторы
применяют нейронную сеть на основе векторного квантования (LVQNN).
Данная интеллектуальная система классификации нагрузки динамически
подстраивает коэффициенты регулятора, компенсируя влияние возмущающих
воздействий.

Проведённые экспериментальные исследования подтвердили, что предложенный
алгоритм МШИМ обеспечивает точность позиционирования в пределах 0.2 mm,
что существенно превосходит результаты стандартного ШИМ-алгоритма
(ошибка около 1.75 mm). Применение LVQNN и адаптивной настройки
параметров регулятора позволило эффективно компенсировать влияние
изменяющейся внешней нагрузки и добиться высокой стабильности системы
управления.

Таким образом, ключевыми элементами разработанной системы управления
являются алгоритм МШИМ, трёхконтурная схема регулирования с обратной
связью, а также интеллектуальная система адаптации параметров регулятора
на основе LVQNN. Полученные результаты демонстрируют высокую
эффективность предложенных методов для точного позиционного управления
пневматическим пневмоприводом в условиях изменяющихся внешних нагрузок.

## Исследование управления в скользящих режимах {#subsec:ch1/sec5/subsec2}

Управление в скользящих режимах [-@utkin2017sliding] -- это класс
нелинейных методов управления, которые делают систему управления
разрывной. Процесс проектирования делится на два этапа: выбор
поверхностей переключения для желаемого режима движения и синтез
разрывного управления для движения системы по этим поверхностям.

Движение системы по поверхностям переключения обладает рядом
преимуществ: снижение порядка системы, инвариантность к параметрическим
и внешним возмущениям. Для описания движения используются специальные
математические методы, такие как регуляризация и метод эквивалентного
управления.

Управление в скользящих режимах эффективно решает задачи управления
сложными нелинейными динамическими объектами в условиях неопределённости
и широко применяется в электроприводах, робототехнике и системах
автоматического управления. Поскольку позиционный ПП с дискретными
распределителями представляет из себя дискретную систему с релейным
управлением, то предостваляется воозможным использовать управление в
скользящих режимах в ПП.

В статье [-@Elsayed] рассматривается исследование, посвящённое
управлению положением РО ПП с использованием дискретных распределителей.

Авторы предлагают использование алгоритма управления скользящим режимом
с коррекцией ошибки регулирования (SMCE), который использует ШИМ для
управления распределителями.

Для управления движением пневматического цилиндра авторы используют
только три режима работы четырёх распределителей, представленные ниже:

1.  Режим 1 -- выдвижение штока;

2.  Режим 2 -- задвижение штока;

3.  Режим 3 -- удержание положения штока;

С целью оптимизации параметров SMCE и ПИД-регулятора была разработана
модель в Simulink. Экспериментальные исследования проводились на стенде
ПП.

Результаты моделирования и экспериментов показывают, что SMCE
обеспечивает более высокую точность позиционирования, меньшее время
установления и меньший выброс по сравнению с традиционным
ПИД-регулятором. Для гармонического входного сигнала среднеквадратичная
ошибка при использовании SMCE составляет 0.22 mm, а для ПИД -- 0.69 mm.
Максимальная абсолютная ошибка для SMCE составляет 0.66 mm, а для ПИД --
1.46 mm. Таким образом, предложенный метод SMCE показал своё
превосходство над ПИД-регулятором при управлении положением РО ПП.

Статья [-@Hodgson:article1] аналогично посвящена разработке алгоритма
управления в скользящих режимах для регулирования ПП с четырмя
дискретными распределителями.

Ключевым отличием от предыдущих работ является расширение числа
доступных дискретных режимов управления с трех до семи.

В основе контроллера лежит скользящая поверхность $s$, которая
определяется как функция ошибки позиционирования $e$, её производной и
второй производной. Авторы вводят семь возможных режимов переключения
распределителей $(M_1 \div M_7)$, выбор которых производится в
зависимости от текущего значения $s$ и eё производной. Диаграмма
переходов представлена на рисунке.

<figure id="fig:actuators_scheme">

<figcaption>Диаграмма переключения режимов </figcaption>
</figure>

Режимы $M_7$ и $M_6$ применяются при больших по модулю значениях $s$ для
обеспечения максимальных ускорений в положительном и отрицательном
направлениях соответственно. Эти режимы позволяют быстро сократить
большие ошибки позиционирования.

Режимы $M_2, M_3, M_4$ и $M_5$ используются при малых ошибках
позиционирования $(\lvert s \rvert < \beta)$. Их применение позволяет
снизить частоту переключений распределителей, что способствует
увеличению срока службы пневматической системы.

Для выбора оптимального режима в области малых ошибок авторы вводят
дополнительные критерии, основанные на разности давлений в камерах
пневмопривода. Это позволяет определить режим, обеспечивающий
максимальное ускорение при минимальном переключении распределителей.
Кроме того, вводится параметр $\tau$, задающий минимальное время между
переключениями в этой области, что также способствует снижению частоты
переключений распределителей.

Теоретический анализ показывает, что при достаточно больших значениях
параметров распределителей, предложенный алгоритм обеспечивает
асимптотическую устойчивость замкнутой системы. Результаты моделирования
и экспериментальных исследований подтверждают, что семирежимный
скользящий контроллер демонстрирует улучшение точности позиционирования
и значительное снижение переключений соленоидных распределителей по
сравнению с трехрежимным аналогом.

Таким образом, данная работа предлагает эффективное решение для
управления пневматическими приводами с дискретными входами, обеспечивая
высокую точность позиционирования при сокращении нагрузки на
исполнительные механизмы.

Аналогично, в статье [-@Zhonglin] рассматривается разработка и проверка
алгоритма управления в скользящем режиме с использованием ШИМ для систем
позиционирования в ПП. Этот алгоритм был так же применён к ПП с четырьмя
дискретными распределителями.

Основная цель исследования заключалась в снижении ошибок
позиционирования и повышении точности слежения. В статье подробно
рассматриваются существующие подходы к управлению в ПП системах.

Разработанный алгоритм основан на использовании семи режимов
переключения распределителей. В отличие от традиционных методов,
использующих высокое или низкое напряжение в одном периоде ШИМ,
предложенная методика применяет два режима переключения за один период,
что улучшает производительность, комбинируя управление фазами ШИМ.

Статья подробно описывает процесс разработки алгоритма управления с
использованием скользящего режима. Он начинается с математической модели
и заканчивается настройкой параметров и верификацией системы на
платформе FPGA. Использование FPGA в электропневматических системах
является инновационным подходом. Авторы продемонстрировали эффективность
предложенного алгоритма как в математической модели, так и в
экспериментальных условиях.

Экспериментальная часть включает настройку аппаратной части системы и
платформы FPGA, а также тестирование на реальной установке. Результаты
подтвердили высокую точность и надёжность предложенного метода по
сравнению с традиционными подходами.

Авторы подытоживают, что предложенный алгоритм обеспечивает высокую
точность и устройчивость управления. Предложенный алгоритм позволил
уменьшить статическую ошибку позиционирования с 2.5 mm до 0.8 mm, что
составляет снижение ошибки на 68%. В свою очередь, точность
позиционирования при математическом моделировании достигла 98.5% по
сравнению с 91.2% при использовании традиционных методов.

Кроме того, время отклика системы сократилось на 33%, обеспечивая более
высокое быстродействие. В эксперименте отклонение при повторяющихся
циклах позиционирования не превышало 1.2 mm, тогда как у традиционного
алгоритма с ШИМ, это значение было в среднем 3.7 mm.
