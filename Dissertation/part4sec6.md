# Разработка критериев оптимизации и анализ фронта Парето {#sec:ch4/sec6}

## Выбор и обоснование критериев качества управления {#sec:ch4/sec6/subsec1}

Разработка и выбор критериев качества управления является одним из
основных этапов многокритериальной оптимизации параметров пневмопривода,
поскольку выбор критериев, являющихся противоречивыми и
взаимоисключающими, определяет возможные стратегииуправления и область
допустимых решений.

В результате проведенного анализа литературы установлено, что основными
направлениями повышения производительности являются увеличение
быстродействия и точности позиционирования, при этом существенную роль
играет надежность привода. Дискретный характер управления пневмоприводом
обуславливает частые переключения распределителей, что приводит к
ускоренной наработке ресурса и снижению надежности системы.

На основании выявленной специфики задачи предлагается использование
следующих критериев качества:

Первый критерий характеризует точность позиционирования и качество
переходного процесса:

$$J_1 = \int_0^T \left(w_1\left(\frac{e(t)}{e_{max}}\right)^2 + w_2\left(\frac{\dot{e}(t)}{\dot{e}_{max}}\right)^2\right)dt$$

Данный критерий представляет собой модифицированный интегральный
квадратичный критерий. Первое слагаемое оценивает точность
позиционирования через квадрат нормированной ошибки, второе -- учитывает
динамику её изменения. Квадратичная форма обеспечивает более жесткое
штрафование больших отклонений. Нормирование на максимальные значения
$e_{max}$ и $\dot{e}_{max}$ обеспечивает безразмерность и соизмеримость
составляющих. Весовые коэффициенты $w_1$ и $w_2$ позволяют регулировать
соотношение между статической точностью и динамическими
характеристиками.

Второй критерий оценивает ресурсную нагрузку на исполнительные
механизмы:

$$J_2 = \alpha \cdot f_{rms} + \beta \cdot \frac{N}{N_{max}}$$ где
$f_{rms}$ -- среднеквадратичная частота переключений:

$$f_{rms} = \sqrt{\frac{1}{N}\sum_{i=1}^N f_i^2}$$

Использование среднеквадратичного значения частоты позволяет придать
больший вес высокочастотным переключениям, наиболее критичным для
механического износа компонентов. Второе слагаемое учитывает общее
количество переключений относительно допустимого значения. Коэффициенты
$\alpha$ и $\beta$ определяют баланс между динамической и статической
составляющими износа.

Третий критерий оценивает быстродействие системы:
$$J_4 = \gamma_1 t_s + \gamma_2 t_r + \gamma_3 \int_0^T t|e(t)|dt$$

Критерий комбинирует основные временные характеристики: время
регулирования $t_s$, характеризующее длительность переходного процесса,
время нарастания $t_r$, отражающее скорость начального отклика, и
интегральный член, учитывающий длительность существования ошибки с
нарастающим весом. Коэффициенты $\gamma_1$, $\gamma_2$ и $\gamma_3$
позволяют настраивать значимость различных составляющих быстродействия.

Выбранные критерии обладают следующими ключевыми свойствами:

безразмерность и нормированность, обеспечивающие соизмеримость;
физическая интерпретируемость, позволяющая формулировать инженерные
требования; вычислительная эффективность при численной оптимизации;
комплексность оценки различных аспектов функционирования системы.

Данные критерии являются противоречивыми, поскольку улучшение одного
показателя, как правило, влечет ухудшение других. В частности, повышение
быстродействия обычно требует более интенсивного управления и,
следовательно, увеличивает число и частоту переключений. Улучшение
точности позиционирования может потребовать дополнительных
корректирующих воздействий, что отражается на всех остальных критериях.

## Визуализация и анализ фронта Парето {#sec:ch4/sec6/subsec2}
